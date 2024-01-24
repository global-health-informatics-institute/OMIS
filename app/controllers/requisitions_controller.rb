class RequisitionsController < ApplicationController
  def index
  end

  def show

  end

  def new
    @requisition = Requisition.new()
    @selected_request = params["request_type"]
    @employees = Employee.where(still_employed: true).collect{|x| x.person.full_name}

    case @selected_request
    when 'Petty Cash'
      @petty_cash_limit = 5000
    when 'Asset Request'
      @asset_types = AssetCategory.all.collect{|x| x.category}
    when 'Purchase Request'

    when 'Travel Request'

    when 'Personnel Requests'

    end
  end

  def create
  end

  def edit
  end

end
