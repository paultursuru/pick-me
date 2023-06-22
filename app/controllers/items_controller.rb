class ItemsController < ApplicationController
  before_action :set_room, only: [:show, :new, :create, :edit, :update, :destroy]

  # def index
  #   @items = Item.all
  # end

  def show
    @item = Item.find(params[:id])
    @options = @item.options.sort_by(&:average_stars).reverse
    @option = Option.new
    @vote = Vote.new
    authorize @item
  end

  def new
    @item = @room.items.new
    authorize @item
  end

  def create
    @item = @room.items.new(item_params)
    authorize @item
    @item.room = @room
    if @item.save
      respond_to do |format|
        format.html { redirect_to flat_room_path(@room.flat, @room) }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def quick_create_option
    @item = Item.find(params[:id])
    authorize @item

    @url = params[:url]
    # @option = @item.options.new
    @option_scrapped = OptionScrapper.call(url: @url)
    @option_scrapped.item = @item
    @option_scrapped
  end

  def edit
    @item = @room.items.find(params[:id])
    authorize @item
  end

  def update
    @item = @room.items.find(params[:id])
    authorize @item
    if @item.update(item_params)
      redirect_to flat_room_path(@room.flat, @room)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item = @room.items.find(params[:id])
    authorize @item
    @item.destroy
    respond_to do |format|
      format.html { redirect_to flat_room_path(@room.flat, @room), status: :see_other }
      format.turbo_stream
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :importance)
  end

  def set_room
    @room = Room.find(params[:room_id])
  end
end
