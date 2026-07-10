# README

T# Winnipeg Eats

Rails intro project for my web dev program. Browse real Winnipeg restaurants
pulled from OpenStreetMap, see what cuisines they serve, and find recipes
from TheMealDB you could try making at home.

## Data sources
- OpenStreetMap Overpass API (restaurants with locations)
- TheMealDB API (recipes and ingredients, two endpoints)
- Faker gem (fake reviews)

## Setup
bundle install
rails db:migrate
rails db:seed
rails s