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

    for i in 0..(@items.size-1)
      if (@items[i].name != "Aged Brie" && @items[i].name != "Backstage passes to a TAFKAL80ETC concert")
        normal_item_calculation(i)
      else
        increasing_value_calculation(i)
      end
      if (@items[i].name != "Sulfuras, Hand of Ragnaros")
        decrease_sell_in_value(i)
      end
      if (@items[i].sell_in < 0)
        if (@items[i].name != "Aged Brie")
          if (@items[i].name != "Backstage passes to a TAFKAL80ETC concert")
            if (@items[i].quality > 0)
              if (@items[i].name != "Sulfuras, Hand of Ragnaros")
                decrease_quality_value(i)
              end
            end
          else
            @items[i].quality = @items[i].quality - @items[i].quality
          end
        else
          if (@items[i].quality < 50)
            increase_quality_value(i)
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

  def normal_item_calculation(i)
    if (@items[i].quality > 0)
      if (@items[i].name != "Sulfuras, Hand of Ragnaros")
        if (@items[i].name.include? "Conjured")
          @items[i].quality = @items[i].quality - 2
        else
          @items[i].quality = @items[i].quality - 1
        end
      end
    end

  end

  def increasing_value_calculation(i)
    if (@items[i].quality < 50)
      @items[i].quality = @items[i].quality + 1
      if (@items[i].name == "Backstage passes to a TAFKAL80ETC concert")
        if (@items[i].sell_in < 11)
          if (@items[i].quality < 50)
            @items[i].quality = @items[i].quality + 1
          end
        end
        if (@items[i].sell_in < 6)
          if (@items[i].quality < 50)
            @items[i].quality = @items[i].quality + 1
          end
        end
      end
    end
  end

  def decrease_sell_in_value(i)
    @items[i].sell_in = @items[i].sell_in - 1
  end

  def decrease_quality_value(i)
    @items[i].quality = @items[i].quality - 1
  end

  def increase_quality_value(i)
    @items[i].quality = @items[i].quality + 1
  end
end
