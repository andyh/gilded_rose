require './gilded_rose.rb'
require "rspec"

describe GildedRose do
  describe "+5 Dexterity Vest" do
    let(:gilded_rose) { GildedRose.new(Item.new("+5 Dexterity Vest", 10, 20)) }
  end

  describe "Aged Brie" do
    let(:gilded_rose) { GildedRose.new(Item.new("Aged Brie", 2, 0)) }
    let(:brie) { gilded_rose.items.first }

    it "increases in quality as it ages" do
      2.times { gilded_rose.update_quality }
      expect(brie.sell_in).to eq(0)
      expect(brie.quality).to eq(2)
    end

    it "continues to increase in quality after the sell-in date has passed" do
      4.times { gilded_rose.update_quality }
      expect(brie.sell_in).to eq(-2)
      expect(brie.quality).to eq(6)
    end

    it "does not increase quality beyond 50" do
      60.times { gilded_rose.update_quality }
      expect(brie.sell_in).to eq(-58)
      expect(brie.quality).to eq(50)
    end
  end

  describe "Elixir of the Mongoose" do
    let(:gilded_rose) { GildedRose.new(Item.new("Elixir of the Mongoose", 5, 7)) }
    let(:elixir) { gilded_rose.items.first }

    it "decreases in quality by 1 after 1 day" do
      gilded_rose.update_quality
      expect(elixir.sell_in).to eq(4)
      expect(elixir.quality).to eq(6)
    end

    it "degrades quality by 2 once the sell-in date has passed" do
      6.times { gilded_rose.update_quality }
      expect(elixir.sell_in).to eq(-1)
      expect(elixir.quality).to eq(0)
    end

    it "does not allow the quality to be negative" do
      10.times { gilded_rose.update_quality }
      expect(elixir.sell_in).to eq(-5)
      expect(elixir.quality).to eq(0)
    end
  end

  describe "Sulfuras, Hand of Ragnaros" do
    let(:gilded_rose) { GildedRose.new(Item.new("Sulfuras, Hand of Ragnaros", 0, 80)) }
    let(:sulfuras) { gilded_rose.items.first }

    it "never changes in quality" do
      expect { gilded_rose.update_quality }.not_to change{ sulfuras.quality }
    end

    it "never expires" do
      expect { gilded_rose.update_quality }.not_to change{ sulfuras.sell_in }
    end
  end

  describe "Backstage passes to a TAFKAL80ETC concert" do
    let(:gilded_rose) { GildedRose.new(Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20)) }
    let(:pass) { gilded_rose.items.first }

    it "increases in quality as the sell-in date approaches" do
      5.times { gilded_rose.update_quality }
      expect(pass.sell_in).to eq(10)
      expect(pass.quality).to eq(25)
    end

    it "increases in quality by 2 per day when there are 10 days or less" do
      10.times { gilded_rose.update_quality }
      expect(pass.sell_in).to eq(5)
      expect(pass.quality).to eq(35)
    end

    it "increases in quality by 3 per day when there are 5 days or less" do
      15.times { gilded_rose.update_quality }
      expect(pass.sell_in).to eq(0)
      expect(pass.quality).to eq(50)
    end

    it "is worthless after the concert" do
      20.times { gilded_rose.update_quality }
      expect(pass.sell_in).to eq(-5)
      expect(pass.quality).to eq(0)
    end

    it "does not have a quality greater than 50" do
      long_gilded_rose = GildedRose.new(Item.new("Backstage passes to a TAFKAL80ETC concert", 50, 20))
      35.times { long_gilded_rose.update_quality }
      long_pass = long_gilded_rose.items.first
      expect(long_pass.sell_in).to eq(15)
      expect(long_pass.quality).to eq(50)
    end
  end

  describe "Conjured Mana Cake" do
    let(:gilded_rose) do
      GildedRose.new [
        Item.new("Conjured Mana Cake", 3, 6),
        Item.new("Mana Cake", 3, 6),
      ]
    end
    let(:conjured_mana) { gilded_rose.items.first }
    let(:mana) { gilded_rose.items.last }

    it "degrades in quality twice as fast as normal items" do
      2.times { gilded_rose.update_quality }

      expect(mana.quality).to eq(4)
      expect(conjured_mana.quality).to eq(2)
    end

    it "does not degrade quality below zero" do
      6.times { gilded_rose.update_quality }

      expect(mana.quality).to eq(0)
      expect(conjured_mana.quality).to eq(0)
    end
  end
end
