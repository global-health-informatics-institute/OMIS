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

  def show
    @asset = Asset.find(params[:id])
    respond_to do |format|
      format.html
      format.json {render json: asset}
      format.lbl do
        content = generate_asset_label_content(@asset)
        send_data content, filename: "asset_label.lbl", type: 'application/lbl'
      end
    end
  end

  def generate_asset_label_content(asset)
    "N\nq609\nQ406,026\nZT\nI8,0,001\nB610,10,1,1,3,6,80,N,\"GN#{asset.tag_id}\"\n" \
    "A30,30,0,1,2,2,N,\"Tag_id: #{asset.tag_id}\"\n" \
    "A30,76,0,1,2,2,N,\"Make: #{asset.make}\"\n" \
    "A30,122,0,1,2,2,N,\"Model : #{asset.model}\"\n" \
    "A30,168,0,1,2,2,N,\"S/N: #{asset.serial_number}\"\n" \
    "A30,208,0,1,2,2,N,\"Location: #{asset.location}\"\n" \
    "A30,254,0,1,2,2,N,\"Category: #{asset.asset_category_id}\"\n" \
    "P1"
  end
end
