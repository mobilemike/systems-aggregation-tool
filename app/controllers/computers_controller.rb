class ComputersController < ApplicationController
  def index
    @computers = Computer.find_all_sorted_by_health
  end
  
  def show
    @computer = Computer.find(params[:id])
  end
       
  def computer_filter
    @computers = Computer.find_all_sorted_by_health(params[:computer_filter])
    render :partial => "computers"
  end
end