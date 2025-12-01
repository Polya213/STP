require_relative 'ingredient'
require_relative 'recipe'
require_relative 'pantry'
require_relative 'unit_converter'
require_relative 'planner'

flour = Ingredient.new('борошно', :g, 3.64)
milk = Ingredient.new('молоко', :ml, 0.06)
egg = Ingredient.new('яйце', :pcs, 72)
pasta = Ingredient.new('паста', :g, 3.5)
sauce = Ingredient.new('соус', :ml, 0.2)
cheese = Ingredient.new('сир', :g, 4.0)

omelet = Recipe.new('Омлет', ['змішати','пожарити'], [
  {ingredient: egg, qty:3, unit: :pcs},
  {ingredient: milk, qty:100, unit: :ml},
  {ingredient: flour, qty:20, unit: :g}
])

pasta_recipe = Recipe.new('Паста', ['відварити','змішати'], [
  {ingredient: pasta, qty:200, unit: :g},
  {ingredient: sauce, qty:150, unit: :ml},
  {ingredient: cheese, qty:50, unit: :g}
])

pantry = Pantry.new
pantry.add('борошно', 1, :kg)
pantry.add('молоко', 0.5, :l)
pantry.add('яйце', 6, :pcs)
pantry.add('паста', 300, :g)
pantry.add('сир', 150, :g)

price_list = {'борошно'=>0.02, 'молоко'=>0.015, 'яйце'=>6.0, 'паста'=>0.03, 'соус'=>0.025, 'сир'=>0.08}

Planner.plan([omelet, pasta_recipe], pantry, price_list)
