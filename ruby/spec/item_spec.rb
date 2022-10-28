require 'rspec'
require_relative '../main'

describe :Item do
  describe :NormalItems do
    let(:item_name) { "Normal Item" }

    [
      # reduces price and sell_by for normal items
      {
        given: { sell_by: 10, price: 20 },
        want: { sell_by: 9, price: 19 },
      },
      # reduces price 2x as fast for normal items past sell_by
      {
        given: { sell_by: -1, price: 20 },
        want: { sell_by: -2, price: 18 },
      },
      # does not allow price to go negative
      {
        given: { sell_by: 10, price: 0 },
        want: { sell_by: 9, price: 0 },
      }
    ].each_with_index do |test_case, i|
      context "TestCase[#{i}] given #{test_case[:given]}" do
        it "returns #{test_case[:want]}" do
          item = Item.create(item_name, test_case[:given][:sell_by], test_case[:given][:price])
          item.end_of_day_update
          expect(item.sell_by).to eq(test_case[:want][:sell_by])
          expect(item.price).to eq(test_case[:want][:price])
        end
      end
    end
  end

  describe :FineArt do
    let(:item_name) { "Fine Art" }

    [
      # increases price for Fine Art
      {
        given: { sell_by: 10, price: 20 },
        want: { sell_by: 9, price: 21 },
      },
      # does not allow price of appreciating items to exceed 50
      {
        given: { sell_by: 10, price: 50 },
        want: { sell_by: 9, price: 50 },
      },
      # increases price 2x as fast after expiring
      {
        given: { sell_by: -1, price: 20 },
        want: { sell_by: -2, price: 22 },
      }
    ].each_with_index do |test_case, i|
      context "TestCase[#{i}] given #{test_case[:given]}" do
        it "returns #{test_case[:want]}" do
          item = Item.create(item_name, test_case[:given][:sell_by], test_case[:given][:price])
          item.end_of_day_update
          expect(item.sell_by).to eq(test_case[:want][:sell_by])
          expect(item.price).to eq(test_case[:want][:price])
        end
      end
    end
  end

  describe :ConcertTickets do
    let(:item_name) { "Concert Tickets" }

    [
      # increases price for Concert Tickets
      {
        given: { sell_by: 20, price: 20 },
        want: { sell_by: 19, price: 21 },
      },
      # increases price 2x as fast when within 11 days of the concert
      {
        given: { sell_by: 10, price: 20 },
        want: { sell_by: 9, price: 22 },
      },
      # increases price 3x as fast when within 6 days of the concert
      {
        given: { sell_by: 5, price: 20 },
        want: { sell_by: 4, price: 23 },
      },
      # price drops to zero after the concert
      {
        given: { sell_by: -1, price: 20 },
        want: { sell_by: -2, price: 0 },
      }
    ].each_with_index do |test_case, i|
      context "TestCase[#{i}] given #{test_case[:given]}" do
        it "returns #{test_case[:want]}" do
          item = Item.create(item_name, test_case[:given][:sell_by], test_case[:given][:price])
          item.end_of_day_update
          expect(item.sell_by).to eq(test_case[:want][:sell_by])
          expect(item.price).to eq(test_case[:want][:price])
        end
      end
    end
  end

  describe :GoldCoins do
    let(:item_name) { "Gold Coins" }

    [
      # does not allow gold coin price to exceed 80
      {
        given: { sell_by: 10, price: 80 },
        want: { sell_by: 10, price: 80 },
      },
      # does not reduce sell_by time for gold coins
      {
        given: { sell_by: 10, price: 80 },
        want: { sell_by: 10, price: 80 },
      },
      # the price is always 80 for gold coins
      {
        given: { sell_by: 10, price: 20 },
        want: { sell_by: 10, price: 80 },
      },
    ].each_with_index do |test_case, i|
      context "TestCase[#{i}] given #{test_case[:given]}" do
        it "returns #{test_case[:want]}" do
          item = Item.create(item_name, test_case[:given][:sell_by], test_case[:given][:price])
          item.end_of_day_update
          expect(item.sell_by).to eq(test_case[:want][:sell_by])
          expect(item.price).to eq(test_case[:want][:price])
        end
      end
    end
  end

  describe :UnknownItems do
    let(:item_name) { "Unknown Item" }

    [
      # reduces price and sell_by for unknown items
      {
        given: { sell_by: 10, price: 20 },
        want: { sell_by: 9, price: 19 },
      },
      # reduces price 2x as fast for unknown items past sell_by
      {
        given: { sell_by: -1, price: 20 },
        want: { sell_by: -2, price: 18 },
      },
      # does not allow price to go negative
      {
        given: { sell_by: 10, price: 0 },
        want: { sell_by: 9, price: 0 },
      }
    ].each_with_index do |test_case, i|
      context "TestCase[#{i}] given #{test_case[:given]}" do
        it "returns #{test_case[:want]}" do
          item = Item.create(item_name, test_case[:given][:sell_by], test_case[:given][:price])
          item.end_of_day_update
          expect(item.sell_by).to eq(test_case[:want][:sell_by])
          expect(item.price).to eq(test_case[:want][:price])
        end
      end
    end
  end
end