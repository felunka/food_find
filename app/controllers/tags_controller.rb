class TagsController < ApplicationController
  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new params.require(:tag).permit(:name)
    if @tag.save
      flash[:success] = 'Tag created'
      redirect_to action: 'index'
    else
      render :new
    end
  end

  def edit
    @tag = Tag.find_by params.permit(:id)
  end

  def update
    @tag = Tag.find_by params.permit(:id)
    if @tag.update params.require(:tag).permit(:name)
      flash[:success] = 'Tag updated'
      redirect_to action: 'index'
    else
      render :edit
    end
  end

  def index
    @tags = Tag.all
  end

  def destroy
    Tag.find_by(params.permit(:id)).destroy
    flash[:danger] = 'Tag deleted'
    redirect_to action: 'index'
  end
end
