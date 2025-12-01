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
