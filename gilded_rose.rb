require './item.rb'

class GildedRose
  attr_reader :items

  def initialize(item_list=nil)
    if item_list
      @items = Array(item_list)
    else
      @items = default_list
    end
  end

  def update_quality
    @items.each do |item|
      next if item.name == "Sulfuras, Hand of Ragnaros"

      if (item.name == "Aged Brie" || item.name == "Backstage passes to a TAFKAL80ETC concert")
        increasing_value_calculation(item)
      else
        normal_item_calculation(item)
      end

      decrease_sell_in_value(item)

      if (item.sell_in < 0)
        case item.name
        when "Aged Brie"
          increase_quality_value(item)
        when "Backstage passes to a TAFKAL80ETC concert"
          make_worthless(item)
        else
          decrease_quality_value(item)
        end
      end
    end
  end

  private
  def default_list
    [Item.new("+5 Dexterity Vest", 10, 20),
     Item.new("Aged Brie", 2, 0),
     Item.new("Elixir of the Mongoose", 5, 7),
     Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
     Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
     Item.new("Conjured Mana Cake", 3, 6),
    ]
  end

  def normal_item_calculation(item)
    if (item.name.include? "Conjured")
      decrease_quality_value(item, 2)
    else
      decrease_quality_value(item)
    end
  end

  def increasing_value_calculation(item)
    if (item.name == "Backstage passes to a TAFKAL80ETC concert")
        by = 2 if (item.sell_in < 11)
        by = 3 if (item.sell_in < 6)
    end

    increase_quality_value(item, by || 1)
  end

  def decrease_sell_in_value(item)
    item.sell_in = item.sell_in - 1
  end

  def decrease_quality_value(item, by=1)
    item.quality = item.quality - by if item.quality > 0
  end

  def increase_quality_value(item, by=1)
    item.quality = item.quality + by if item.quality < 50
  end

  def make_worthless(item)
    item.quality = item.quality - item.quality
  end
end
