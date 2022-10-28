module Pricing
  MAXIMUM = 50
  MINIMUM = 0

  # Strategy class that is used as the base for price changes
  class Strategy
    attr_reader :value, :after

    def initialize(value, after: nil)
      @value = value
      @after = after
    end

    private

    def should_apply?(item)
      return true if @after.nil?

      item.sell_by <= @after
    end
  end

  # Adjustment strategy applies a delta change to the price
  class Adjustment < Strategy
    def apply(item)
      item.price += value if should_apply?(item)
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end

  def pricing
    self.class.pricing
  end

  def max_price
    self.class.max_price
  end

  def min_price
    self.class.min_price
  end

  module ClassMethods
    def pricing
      @pricing ||= []
    end

    def max_price
      @max_price ||= MAXIMUM
    end

    # Sets a maximum price for the item
    # @param [integer] maximum new item maximum price
    def has_price_maximum(maximum)
      @max_price = maximum
    end

    def min_price
      @min_price ||= MINIMUM
    end

    # Sets a minimum price for the item
    # @param [integer] minimum new item minimum price
    def has_price_minimum(minimum)
      @min_price = minimum
    end

    # Adds an appreciating adjustment strategy to the item with the delta and optional after sell_by
    # @param [integer|Float::INFINITY] delta price adjustment
    # @param [integer] after sell_by value
    def appreciates(delta = 1, after: nil)
      pricing << Adjustment.new(delta.abs, after: after)
    end

    # Adds a depreciating adjustment strategy to the item with the delta and optional after sell_by
    # @param [integer|Float::INFINITY] delta price adjustment
    # @param [integer] after sell_by value
    def depreciates(delta = 1, after: nil)
      pricing << Adjustment.new(delta.abs * -1, after: after)
    end
  end
end
