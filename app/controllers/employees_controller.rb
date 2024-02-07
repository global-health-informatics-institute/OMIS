class EmployeesController < ApplicationController
  def index
    @list_employees = Person.select(:primary_phone, :alt_phone, :first_name, :last_name, :email_address)
    #@q = Person.ransack(params[:q])
    #@list_employees = @q.result(distinct: true)
  end

  def show 
  end

  def new
  end

  def create
  end

  def edit
  end
end
