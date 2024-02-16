class EmployeesController < ApplicationController
  def index
    @list_employees = Person.select(:primary_phone, :alt_phone, :first_name, :last_name, :email_address)
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
