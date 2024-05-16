class InventoryItemsController < ApplicationController
  def new

  end

  def create

  end

  def index

  end

  def show
    @inventory_items = InventoryItem.find_by_sql("SELECT * from inventory_items as ii inner join (select
                      inventory_item_type_id, inventory_item_category_id, item_name from
                      inventory_item_types) as iit on ii.item_type_id = iit.inventory_item_type_id
                      inner join (select inventory_item_category_id, category from inventory_item_categories)
                      as iic on iit.inventory_item_category_id = iic.inventory_item_category_id")
    #raise @inventory_items.inspect
    #@inventory_item_category = InventoryItemCategory.all
  end

  def edit

  end

  def update

  end

  def destroy

  end
end
