class ComputersController < ApplicationController
  def index
    @computers = Computer.find(:all,
                               :include => [ :scom_computer, :akorri_server_storage ],
                               :order => "scom_computers.health DESC, akorri_server_storages.health DESC, computers.fqdn"
                               )
  end
  
  def show
    @computer = Computer.find(params[:id])
  end
  
  def new
    @computer = Computer.new
  end
  
  def create
    @computer = Computer.new(params[:computer])
    if @computer.save
      flash[:notice] = "Successfully created computer."
      redirect_to @computer
    else
      render :action => 'new'
    end
  end
  
  def edit
    @computer = Computer.find(params[:id])
  end
  
  def update
    @computer = Computer.find(params[:id])
    if @computer.update_attributes(params[:computer])
      flash[:notice] = "Successfully updated computer."
      redirect_to @computer
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @computer = Computer.find(params[:id])
    @computer.destroy
    flash[:notice] = "Successfully destroyed computer."
    redirect_to computers_url
  end
end
