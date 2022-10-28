module Expiration
  def self.included(base)
    base.extend ClassMethods
  end

  def expires?
    self.class.expires?
  end

  module ClassMethods
    def expires?
      @expires = true if @expires.nil?
      @expires
    end

    # Disables the expiration (reduction of sell_by) for the item
    def does_not_expire
      @expires = false
    end
  end
end
