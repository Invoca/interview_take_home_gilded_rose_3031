require 'rspec'
require_relative '../main'
require_relative '../item'

describe :Inventory do
  describe '#update_items' do
    [
      {
        given: [
          Item.create("Normal Item", 10, 20),
        ],
        want: [
          { sell_by: 9, price: 19 },
        ]
      },
      {
        given: [
          Item.create("Normal Item", 10, 20),
          Item.create("Normal Item", -1, 20),
        ],
        want: [
          { sell_by: 9, price: 19 },
          { sell_by: -2, price: 18 },
        ]
      },
      {
        given: [
          Item.create("Normal Item", 10, 20),
          Item.create("Normal Item", -1, 20),
          Item.create("Gold Coins", 10, 80),
        ],
        want: [
          { sell_by: 9, price: 19 },
          { sell_by: -2, price: 18 },
          { sell_by: 10, price: 80 },
        ]
      },
      {
        given: [
          Item.create("Normal Item", 10, 20),
          Item.create("Normal Item", -1, 20),
          Item.create("Gold Coins", 10, 80),
        ],
        want: [
          { sell_by: 9, price: 19 },
          { sell_by: -2, price: 18 },
          { sell_by: 10, price: 80 },
        ]
      },
      {
        given: [
          Item.create("Normal Item", 10, 20),
          Item.create("Concert Tickets", 10, 20),
          Item.create("Gold Coins", 10, 80),
          Item.create("Fine Art", 10, 20),
        ],
        want: [
          { sell_by: 9, price: 19 },
          { sell_by: 9, price: 22 },
          { sell_by: 10, price: 80 },
          { sell_by: 9, price: 21 },
        ]
      },
    ].each_with_index do |test_case, i|
      context "TestCase[#{i}] given #{test_case[:given].length} items" do
        inventory = Inventory.new(test_case[:given])
        inventory.update_items

        test_case[:given].each_with_index do |item, i|
          it "updates item[#{i}] to #{test_case[:want][i]}" do
            expect(item.sell_by).to eq(test_case[:want][i][:sell_by])
            expect(item.price).to eq(test_case[:want][i][:price])
          end
        end
      end
    end
  end
end
