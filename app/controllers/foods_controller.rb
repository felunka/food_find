class FoodsController < ApplicationController
  def index
    @foods = Food.all
  end

  def new
    @food = Food.new
  end

  def create
    @food = Food.new params.require(:food).permit(:name, tag_ids: [])
    if @food.save
      flash[:success] = 'Food created'
      redirect_to action: 'index'
    else
      render :new
    end
  end

  def edit
    @food = Food.find_by params.permit(:id)
  end

  def update
    @food = Food.find_by params.permit(:id)
    if @food.update params.require(:food).permit(:name, tag_ids: [])
      flash[:success] = 'Food updated'
      redirect_to action: 'index'
    else
      render :edit
    end
  end

  def destroy
    Food.find_by(params.permit(:id)).destroy
    flash[:danger] = 'Food deleted'
    redirect_to action: 'index'
  end
end
