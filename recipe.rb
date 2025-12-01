require_relative 'unit_converter'
class Recipe
  attr_reader :name, :steps, :items
  def initialize(name, steps, items)
    @name = name
    @steps = steps
    @items = items
  end
  def need
    @items.map do |item|
      qty_base = UnitConverter.to_base(item[:qty], item[:unit])
      {ingredient: item[:ingredient], qty: qty_base, unit: item[:ingredient].unit}
    end
  end
end
