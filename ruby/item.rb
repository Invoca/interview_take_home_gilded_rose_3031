require_relative './item_pricing'
require_relative './item_expiration'

module Item

  # Factory function to build a new item
  #
  # @param [string] name
  # @param [string] sell_by
  # @param [string] price
  # @return [Item::FineArt, Item::ConcertTickets, Item::GoldCoins, Item::NormalItem]
  def create(name, sell_by, price)
    case name
    when 'Fine Art'
      FineArt.new(name, sell_by, price)
    when 'Concert Tickets'
      ConcertTickets.new(name, sell_by, price)
    when 'Gold Coins'
      GoldCoins.new(name, sell_by, price)
    else
      NormalItem.new(name, sell_by, price)
    end
  end

  module_function :create

  class Base
    include Pricing
    include Expiration

    attr_accessor :name, :sell_by, :price

    def initialize(name, sell_by, price)
      @name = name
      @sell_by = sell_by
      @price = price
    end

    # End-of-day item attribute processing
    #
    def end_of_day_update
      @sell_by -= 1 if expires?
      pricing.each do |strategy|
        strategy.apply(self)
      end
      @price = [min_price, [max_price, @price].min].max
    end
  end

  # Concert Tickets
  #
  # Expires normally
  # Appreciates by +1 normally,
  # by +2 within 10 days of the concert,
  # by +3 within 5 days of the concert
  # Depreciates to 0 after the concert
  # Price range is [0..50] inclusive
  class ConcertTickets < Base
    appreciates
    appreciates after: 10
    appreciates after: 5
    depreciates Float::INFINITY, after: 0
  end

  # Gold Coins
  #
  # Does not expire
  # Does not appreciate
  # Does not depreciate
  # Price range is [80..80] inclusive
  class GoldCoins < Base
    does_not_expire

    has_price_minimum 80
    has_price_maximum 80
  end

  # Fine Art
  #
  # Expires normally
  # Appreciates by +1 normally,
  # by +2 after sell by expiration
  # Does not depreciate
  # Price range is [0..50] inclusive
  class FineArt < Base
    appreciates
    appreciates after: 0
  end

  # Normal Items
  #
  # Expires normally
  # Does not appreciate
  # Depreciates by -1 normally,
  # by -2 after sell by expiration
  # Price range is [0..50] inclusive
  class NormalItem < Base
    depreciates
    depreciates after: 0
  end
end