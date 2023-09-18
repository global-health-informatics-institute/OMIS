class AssetCategoriesController < ApplicationController
  before_action :set_asset_category, only: %i[ show edit update destroy ]

  # GET /asset_categories or /asset_categories.json
  def index
    @asset_categories = AssetCategory.all
  end

  # GET /asset_categories/1 or /asset_categories/1.json
  def show
  end

  # GET /asset_categories/new
  def new
    @asset_category = AssetCategory.new
  end

  # GET /asset_categories/1/edit
  def edit
  end

  # POST /asset_categories or /asset_categories.json
  def create
    @asset_category = AssetCategory.new(asset_category_params)

    respond_to do |format|
      if @asset_category.save
        format.html { redirect_to asset_category_url(@asset_category), notice: "Asset category was successfully created." }
        format.json { render :show, status: :created, location: @asset_category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @asset_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /asset_categories/1 or /asset_categories/1.json
  def update
    respond_to do |format|
      if @asset_category.update(asset_category_params)
        format.html { redirect_to asset_category_url(@asset_category), notice: "Asset category was successfully updated." }
        format.json { render :show, status: :ok, location: @asset_category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @asset_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /asset_categories/1 or /asset_categories/1.json
  def destroy
    @asset_category.destroy

    respond_to do |format|
      format.html { redirect_to asset_categories_url, notice: "Asset category was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_asset_category
      @asset_category = AssetCategory.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def asset_category_params
      params.require(:asset_category).permit(:category, :description, :voided)
    end
end
