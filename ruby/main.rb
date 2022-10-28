class Inventory

  def initialize(items)
    @items = items
  end

  def update_price
    @items.each do |item|
      item.end_of_day_update
    end
  end
end
