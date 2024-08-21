class InventoryItemsController < ApplicationController
  def new
    @inventory_item = InventoryItem.new
    @inventory_item_category = InventoryItemCategory.all.collect { |x| x.category }
    @inventory_location = InventoryItem.all.collect { |l| l.storage_location }
  end

  def create
    #raise current_user.employee_id.inspect
    category = InventoryItemCategory.find_or_create_by(category: item_params[:category], voided: false)
    item_type = InventoryItemType.find_or_create_by(item_name: item_params[:item_name],
                                          inventory_item_category_id: category.inventory_item_category_id) do |it|
      it.manufacturer = item_params[:manufacturer]
      it.created_by = current_user.employee_id
    end
    new_inventory_item = InventoryItem.new(item_type_id: item_type.inventory_item_type_id,
                                           quantity: item_params[:quantity],
                                           supplier: item_params[:supplier],
                                           unit_price: item_params[:unit_price],
                                           storage_location: item_params[:storage_location],
                                           created_by: current_user.employee_id)

    if new_inventory_item.save
      flash[:notice] = "Successfully added inventory item to stock"
      redirect_to "/inventory_items/show"
    else
      flash[:error] = "Failed to record inventory item"
      redirect_to new_inventory_item
    end
  end

  def index
    @inventory_items = InventoryItem.joins("INNER JOIN inventory_item_types iit ON inventory_items.item_type_id
                                            = iit.inventory_item_type_id INNER JOIN inventory_item_categories iic
                                            ON iit.inventory_item_category_id = iic.inventory_item_category_id")
                                    .select("inventory_items.*, iit.item_name, iic.category")
                                    .where(voided: false)
    # raise @inventory_items.inspect
    (@inventory_items || []).each do |item|
      @item = item
    end

    @inventory_item_category = InventoryItemCategory.all
    @category_data = @inventory_items.group_by(&:category).map do |category, items|
      {
        category: category,
        total_quantity: items.sum { |item| (item.quantity - item.quantity_used) || 0}
      }
    end
    @storage_data = @inventory_items.group_by(&:storage_location).map do |storage_location, items|
      {
        location: storage_location,
        total_quantity: items.sum { |item| (item.quantity - item.quantity_used) || 0}
      }
    end
    @threshold_data = @inventory_items.select { |item| item.quantity && item.quantity < 10 }.map do |item|
      item.quantity = item.quantity.abs
      item
    end
    @total_low_stock = @threshold_data.size
    @total_stock = @inventory_items.sum { |item| (item.quantity || 0).abs }
  end

  def show
    @inventory_item = InventoryItem.find(params[:id])
    @inventory_items = InventoryItem.joins("INNER JOIN inventory_item_types iit ON inventory_items.item_type_id
                                            = iit.inventory_item_type_id INNER JOIN inventory_item_categories iic
                                            ON iit.inventory_item_category_id = iic.inventory_item_category_id")
                                    .select("inventory_items.*, iit.item_name, iic.category")
                                    .where(voided: false)
    (@inventory_items || []).each do |item|
      @item = item
    end
    # raise @item.inspect
    @inventory_item_type = InventoryItemType.where(inventory_item_type_id: @inventory_item.item_type_id).all.collect {
      |t| [t.item_name, t.manufacturer, t.inventory_item_category_id] }.first
    #raise @inventory_item_type[1].inspect
    respond_to do |format|
      format.html
      format.lbl do
        content = generate_inventory_label_content(@item)
        # raise content.inspect
        send_data content, filename: "inventory_label.lbl", type: 'application/lbl'
      end
    end
  end

  def edit
    @inventory_item = InventoryItem.find(params[:id])
    @inventory_item_type = InventoryItemType.where(inventory_item_type_id: @inventory_item.item_type_id).all.collect {
      |t| [t.item_name, t.manufacturer, t.inventory_item_category_id] }.first
    @category_options = InventoryItemCategory.all.collect{ |c| c.category}
    @inventory_item_categories = InventoryItemCategory.where(inventory_item_category_id: @inventory_item_type[2])
                                                      .all.collect{ |c| c.category}
                                                      .first
  end

  def update
    @inventory_item = InventoryItem.find(params[:id])

    category = InventoryItemCategory.find_or_create_by(category: item_params[:category], voided: false,
                                                       created_by: current_user.employee_id )
    item_type = InventoryItemType.find_or_create_by(item_name: item_params[:item_name],
                                                    inventory_item_category_id: category.inventory_item_category_id) do |it|
      it.manufacturer = item_params[:manufacturer]
      it.created_by = current_user.employee_id
    end

    if @inventory_item.update(
      item_type_id: item_type.inventory_item_type_id,
      quantity: item_params[:quantity],
      supplier: item_params[:supplier],
      unit_price: item_params[:unit_price],
      storage_location: item_params[:storage_location],
      created_by: current_user.employee_id,
    )
      flash[:notice] = "Successfully updated inventory item"
      redirect_to "/inventory_items"
    else
      flash[:error] = "Failed to update inventory item"
      render :edit
    end
  end

  def destroy
    @inventory_item = InventoryItem.find(params[:id])
    if @inventory_item.update(
      voided: true,
      voided_by: current_user.employee_id
    )
      flash[:alert] = "Successfully deleted inventory item"
      redirect_to "/inventory_items"
    else
      flash[:alert] = "Error deleting inventory item"
      redirect_to "/inventory_items"
    end
  end

  def generate_inventory_label_content(inventory_item)
    "\nN\nq609\nQ406,026\nZT\nI8,0,001\nB610,10,1,1,3,6,80,N,\"GN#{inventory_item.id}\"\n" \
    "A30,30,0,1,2,2,N,\"Tag_id: #{inventory_item.id}\"\n" \
    "A30,76,0,1,2,2,N,\"Make: #{inventory_item.item_name}\"\n" \
    "A30,122,0,1,2,2,N,\"Model : #{inventory_item.category}\"\n" \
    "A30,168,0,1,2,2,N,\"S/N: #{inventory_item.created_at}\"\n" \
    #****add expiry date for consumables****
    "P1\n"
  end

  def item_params
    params.require(:inventory_item).permit(:item_type_id, :quantity, :supplier, :unit_price, :category,
                                           :storage_location, :item_name, :category, :created_by, :inventory_item_category_id,
                                           :manufacturer, :inventory_item_type_id)
  end
end
