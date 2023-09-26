class BusinessAssetsController < ApplicationController
  def index
    @categories = AssetCategory.all.collect{|x| [x.id, x.category]}.to_h
    @assets = Asset.all
  end

  def new
    @asset = Asset.new
    @categories = AssetCategory.all.collect{|x|  x.category}
  end

  def create
  end

  def edit
  end
end
