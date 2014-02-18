require './gilded_rose.rb'
require "rspec"

describe GildedRose do

  describe "#update_quality" do
    it "degrades quality twice as fast when the sell by date has passed" do
      gilded_rose = GildedRose.new(Item.new("Elixir of the Mongoose", 2, 10))
      2.times { gilded_rose.update_quality }
      elixir = gilded_rose.items.first
      expect(elixir.sell_in).to eq(0)
      expect(elixir.quality).to eq(8)
      gilded_rose.update_quality
      elixir = gilded_rose.items.first
      expect(elixir.sell_in).to eq(-1)
      expect(elixir.quality).to eq(6)
    end
    it "doesn't allow the quality of an item to be negative" do
      gilded_rose = GildedRose.new(Item.new("Elixir of the Mongoose", 2, 10))
      12.times { gilded_rose.update_quality }
      elixir = gilded_rose.items.first
      expect(elixir.sell_in).to eq(-10)
      expect(elixir.quality).to eq(0)
    end
    it "increases the quality of Aged Brie as it ages" do
      gilded_rose = GildedRose.new(Item.new("Aged Brie", 2, 0))
      2.times { gilded_rose.update_quality }
      brie = gilded_rose.items.first
      expect(brie.sell_in).to eq(0)
      expect(brie.quality).to eq(2)
      4.times { gilded_rose.update_quality }
      brie = gilded_rose.items.first
      expect(brie.sell_in).to eq(-4)
      expect(brie.quality).to eq(10)
    end
    it "doesn't allow the quality of an item to be greater than 50" do
      gilded_rose = GildedRose.new(Item.new("Aged Brie", 2, 0))
      60.times { gilded_rose.update_quality }
      brie = gilded_rose.items.first
      expect(brie.sell_in).to eq(-58)
      expect(brie.quality).to eq(50)
    end
    it "does not change the quality and sell_in values for Sulfuras" do
      gilded_rose = GildedRose.new(Item.new("Sulfuras, Hand of Ragnaros", 0, 80))
      10.times { gilded_rose.update_quality }
      sulfuras = gilded_rose.items.first
      expect(sulfuras.sell_in).to eq(0)
      expect(sulfuras.quality).to eq(80)
    end
    it "increases the quality of Backstage passes as the sell by date approaches" do
      gilded_rose = GildedRose.new(Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20))
      5.times { gilded_rose.update_quality }
      pass = gilded_rose.items.first
      expect(pass.sell_in).to eq(10)
      expect(pass.quality).to eq(25)

      5.times { gilded_rose.update_quality }
      pass = gilded_rose.items.first
      expect(pass.sell_in).to eq(5)
      expect(pass.quality).to eq(35)

      5.times { gilded_rose.update_quality }
      pass = gilded_rose.items.first
      expect(pass.sell_in).to eq(0)
      expect(pass.quality).to eq(50)

      5.times { gilded_rose.update_quality }
      pass = gilded_rose.items.first
      expect(pass.sell_in).to eq(-5)
      expect(pass.quality).to eq(0)
    end

    it "degrades conjured items twice as fast as normal items" do
      gilded_rose = GildedRose.new([Item.new("Conjured Mana Cake", 10, 20), Item.new("Mana Cake", 10, 20)])
      5.times { gilded_rose.update_quality }
      conjured_mana = gilded_rose.items.first
      standard_mana = gilded_rose.items.last
      expect(conjured_mana.sell_in).to eq(5)
      expect(standard_mana.sell_in).to eq(5)
      expect(conjured_mana.quality).to eq(10)
      expect(standard_mana.quality).to eq(15)
    end
  end
end
