class OwnersController < ApplicationController
  def index
    @owners = Owner.all
  end
  
  def show
    @owner = Owner.find(params[:id])
  end
  
  def new
    @owner = Owner.new
  end
  
  def create
    @owner = Owner.new(params[:owner])
    if @owner.save
      flash[:notice] = "Successfully created owner."
      redirect_to @owner
    else
      render :action => 'new'
    end
  end
  
  def edit
    @owner = Owner.find(params[:id])
  end
  
  def update
    @owner = Owner.find(params[:id])
    if @owner.update_attributes(params[:owner])
      flash[:notice] = "Successfully updated owner."
      redirect_to @owner
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @owner = Owner.find(params[:id])
    @owner.destroy
    flash[:notice] = "Successfully destroyed owner."
    redirect_to owners_url
  end
end
