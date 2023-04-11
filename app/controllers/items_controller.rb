class ItemsController < ApplicationController
  before_action :set_flat, only: [:show, :new, :create, :edit, :update, :destroy]

  # def index
  #   @items = Item.all
  # end

  def show
    @item = Item.find(params[:id])
    @options = @item.options
    @option = Option.new
    authorize @item
  end

  def new
    @item = @flat.items.new
    authorize @item
  end

  def create
    @item = @flat.items.new(item_params)
    authorize @item
    @item.flat = @flat
    if @item.save
      respond_to do |format|
        format.html { redirect_to flat_path(@flat) }
        format.turbo_stream
      end
      # redirect_to flat_path(@flat)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @item = @flat.items.find(params[:id])
    authorize @item
  end

  def update
    @item = @flat.items.find(params[:id])
    authorize @item
    if @item.update(item_params)
      redirect_to flat_path(@flat)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item = @flat.items.find(params[:id])
    authorize @item
    @item.destroy
    respond_to do |format|
      format.html { redirect_to flat_path(@flat), status: :see_other }
      format.turbo_stream
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :importance)
  end

  def set_flat
    @flat = Flat.find(params[:flat_id])
  end
end
