class InventoryItemsController < ApplicationController
  def new

  end

  def create

  end

  def index

  end

  def show
    @inventory_items = InventoryItem.find_by_sql("SELECT inventory_item_id, storage location from inventoryitem ")
    @inventory_item_category = InventoryItemCategory.all
  end

  def edit

  end

  def update

  end

  def destroy

  end
end
