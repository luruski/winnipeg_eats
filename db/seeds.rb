require 'open-uri'
require 'json'
require 'faker'

# clear out old data first so re-running the seeds doesnt make duplicates
puts "clearing old data..."
Review.destroy_all
MealIngredient.destroy_all
Meal.destroy_all
Ingredient.destroy_all
RestaurantCuisine.destroy_all
Restaurant.destroy_all
Cuisine.destroy_all

# ---------------------------------------------
# SOURCE 1 - OpenStreetMap Overpass API
# gets all restaurants in Winnipeg that have a cuisine tag
# ---------------------------------------------
puts "getting restaurants from OpenStreetMap..."

overpass_query = '[out:json][timeout:60];area["name"="Winnipeg"]["boundary"="administrative"]->.a;node["amenity"="restaurant"]["cuisine"](area.a);out;'
overpass_url = "https://overpass-api.de/api/interpreter?data=" + URI.encode_www_form_component(overpass_query)

restaurant_data = JSON.parse(URI.open(overpass_url).read)

restaurant_data["elements"].each do |element|
  tags = element["tags"]

  # some restaurants dont have a name in the data, skip those
  next if tags["name"] == nil

  address = "#{tags['addr:housenumber']} #{tags['addr:street']}".strip

  restaurant = Restaurant.create(
    name: tags["name"],
    address: address,
    lat: element["lat"],
    lng: element["lon"]
  )

  # if a validation failed the id will be nil so skip it
  next if restaurant.id == nil

  # the cuisine tag can have more than one cuisine like "pizza;italian"
  tags["cuisine"].split(";").each do |cuisine_name|
    cuisine = Cuisine.find_or_create_by(name: cuisine_name.strip.gsub("_", " ").capitalize)
    RestaurantCuisine.create(restaurant: restaurant, cuisine: cuisine)
  end

  puts "created restaurant #{restaurant.name}"
end

# ---------------------------------------------
# SOURCE 2 and 3 - TheMealDB API (filter endpoint and lookup endpoint)
# themealdb calls cuisines "areas" so we check each of our cuisines
# against it and grab some recipes for the ones that match
# ---------------------------------------------
puts "getting meals from TheMealDB..."

Cuisine.all.each do |cuisine|
  begin
    filter_url = "https://www.themealdb.com/api/json/v1/1/filter.php?a=" + URI.encode_www_form_component(cuisine.name)
    filter_data = JSON.parse(URI.open(filter_url).read)
  rescue
    # the api sends back weird responses for cuisines it doesnt know, just skip
    next
  end

  next if filter_data["meals"] == nil

  # only take the first 5 meals per cuisine so seeding doesnt take forever
  filter_data["meals"].first(5).each do |meal_info|
    # second endpoint - look up full details for this meal by its id
    lookup_url = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=" + meal_info["idMeal"]
    lookup_data = JSON.parse(URI.open(lookup_url).read)
    details = lookup_data["meals"][0]

    meal = Meal.create(
      name: details["strMeal"],
      instructions: details["strInstructions"],
      thumbnail: details["strMealThumb"],
      cuisine: cuisine
    )

    next if meal.id == nil

    # the api stores ingredients in 20 numbered fields like strIngredient1, strIngredient2 etc
    (1..20).each do |i|
      ingredient_name = details["strIngredient#{i}"]
      measure = details["strMeasure#{i}"]

      # most meals dont use all 20 slots so lots are empty
      next if ingredient_name == nil || ingredient_name.strip == ""

      ingredient = Ingredient.find_or_create_by(name: ingredient_name.strip.capitalize)
      MealIngredient.create(meal: meal, ingredient: ingredient, measure: measure)
    end

    puts "created meal #{meal.name} with its ingredients"
  end
end

# ---------------------------------------------
# SOURCE 4 - Faker
# fake reviews for every restaurant
# ---------------------------------------------
puts "making fake reviews with faker..."

Restaurant.all.each do |restaurant|
  # every restaurant gets 1 to 4 reviews
  rand(1..4).times do
    Review.create(
      author: Faker::Name.name,
      rating: rand(1..5),
      body: Faker::Restaurant.review,
      restaurant: restaurant
    )
  end
end

puts "done seeding!"
puts "restaurants: #{Restaurant.count}"
puts "cuisines: #{Cuisine.count}"
puts "meals: #{Meal.count}"
puts "ingredients: #{Ingredient.count}"
puts "reviews: #{Review.count}"