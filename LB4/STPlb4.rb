# ingredient.rb
class Ingredient
  attr_reader :name, :unit, :calories_per_unit

  BASE_UNITS = [:g, :ml, :pcs]

  def initialize(name, unit, calories_per_unit)
    @name = name
    raise "Invalid unit" unless BASE_UNITS.include?(unit)
    @unit = unit
    @calories_per_unit = calories_per_unit
  end
end

# recipe.rb
class Recipe
  attr_reader :name, :steps, :items

  def initialize(name, steps, items)
    @name = name
    @steps = steps
    @items = items # [{ingredient: Ingredient, qty: Float, unit: Symbol}]
  end

  # повертає необхідну кількість у базових одиницях
  def need
    @items.map do |item|
      qty_base = UnitConverter.to_base(item[:qty], item[:unit])
      {ingredient: item[:ingredient], qty: qty_base, unit: item[:ingredient].unit}
    end
  end
end

# pantry.rb
class Pantry
  def initialize
    @storage = {} # {ingredient_name => {qty: Float, unit: Symbol}}
  end

  def add(name, qty, unit)
    qty_base = UnitConverter.to_base(qty, unit)
    if @storage.key?(name)
      @storage[name][:qty] += qty_base
    else
      @storage[name] = {qty: qty_base, unit: unit}
    end
  end

  def available_for(name)
    @storage[name] ? @storage[name][:qty] : 0
  end
end

# unit_converter.rb
module UnitConverter
  MULTIPLIERS = {kg: 1000, g: 1, l: 1000, ml: 1, pcs: 1}

  def self.to_base(qty, unit)
    raise "Cannot convert" unless MULTIPLIERS.key?(unit)
    qty * MULTIPLIERS[unit]
  end
end

# planner.rb
class Planner
  def self.plan(recipes, pantry, price_list)
    total_calories = 0
    total_cost = 0

    # сумуємо потреби
    need_hash = Hash.new(0)
    recipes.each do |recipe|
      recipe.need.each do |item|
        need_hash[item[:ingredient].name] += item[:qty]
      end
    end

    # виводимо дефіцит / наявність
    need_hash.each do |name, needed|
      have = pantry.available_for(name)
      deficit = [needed - have, 0].max
      unit = recipes.flat_map(&:items).find{|i| i[:ingredient].name==name}[:ingredient].unit
      puts "#{name}: потрібно #{needed}#{unit}, є #{have}#{unit}, дефіцит #{deficit}#{unit}"

      # total calories & cost
      ing = recipes.flat_map(&:items).find{|i| i[:ingredient].name==name}[:ingredient]
      total_calories += needed * ing.calories_per_unit
      total_cost += needed * price_list[name]
    end

    puts "Total calories: #{total_calories}"
    puts "Total cost: #{total_cost.round(2)}"
  end
end
