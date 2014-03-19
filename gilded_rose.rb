require './item.rb'

class GildedRose

  @items = []

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
      if (item.name != "Aged Brie" && item.name != "Backstage passes to a TAFKAL80ETC concert")
        normal_item_calculation(item)
      else
        increasing_value_calculation(item)
      end
      if (item.name != "Sulfuras, Hand of Ragnaros")
        decrease_sell_in_value(item)
      end
      if (item.sell_in < 0)
        if (item.name != "Aged Brie")
          if (item.name != "Backstage passes to a TAFKAL80ETC concert")
            if (item.quality > 0)
              if (item.name != "Sulfuras, Hand of Ragnaros")
                decrease_quality_value(item)
              end
            end
          else
            make_worthless(item)
          end
        else
          if (item.quality < 50)
            increase_quality_value(item)
          end
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
    if (item.quality > 0)
      if (item.name != "Sulfuras, Hand of Ragnaros")
        if (item.name.include? "Conjured")
          item.quality = item.quality - 2
        else
          item.quality = item.quality - 1
        end
      end
    end
  end

  def increasing_value_calculation(item)
    if (item.quality < 50)
      item.quality = item.quality + 1
      if (item.name == "Backstage passes to a TAFKAL80ETC concert")
        if (item.sell_in < 11)
          if (item.quality < 50)
            item.quality = item.quality + 1
          end
        end
        if (item.sell_in < 6)
          if (item.quality < 50)
            item.quality = item.quality + 1
          end
        end
      end
    end
  end

  def decrease_sell_in_value(item)
    item.sell_in = item.sell_in - 1
  end

  def decrease_quality_value(item)
    item.quality = item.quality - 1
  end

  def increase_quality_value(item)
    item.quality = item.quality + 1
  end

  def make_worthless(item)
    item.quality = item.quality - item.quality
  end
end
