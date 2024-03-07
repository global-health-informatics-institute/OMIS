class EmployeesController < ApplicationController
  def index
    @list_employees = Employee.where(still_employed: true).collect { |x| x.person }
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
