class RandomizerController < ApplicationController
  def get
  end

  def randomize
    tags = params.dig(:filter, :tag_ids).reject { |c| c.blank? }
    if tags.any?
      @foods = Food.joins(:tags).where(tags: {id: params.dig(:filter, :tag_ids)})
    else
      @foods = Food.all
    end

    if @foods.any?
      @selected_food = Food.find(@foods.pluck(:id).sample)
    else
      flash[:danger] = 'No food matched your filter...'
    end

    render :get
  end
end
