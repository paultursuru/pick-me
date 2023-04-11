class FlatsController < ApplicationController
  def show
    @flat = Flat.find(params[:id])
    authorize @flat
    @items = @flat.items.by_importance.ordered
    @item = Item.new
  end

  def new
    @flat = current_user.flats.new
    authorize @flat
  end

  def edit
  end
end
