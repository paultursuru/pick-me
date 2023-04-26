class RoomsController < ApplicationController
  before_action :set_flat, only: %i[show new create edit update]

  def show
    @room = Room.find(params[:id])
    authorize @room
    @items = @room.items.by_importance.ordered
    @item = Item.new
    @options = @room.options
    @option = Option.new
  end

  def new
    @room = Room.new
    authorize @room
  end

  def create
    @room = @flat.rooms.new(room_params)
    authorize @room
    if @room.save
      respond_to do |format|
        format.html { redirect_to flat_path(@flat) }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @room = Room.find(params[:id])
    authorize @room
    @room.destroy
    respond_to do |format|
      format.html { redirect_to flat_path(@room.flat), status: :see_other }
      format.turbo_stream
    end
  end

  private

  def set_flat
    @flat = Flat.find(params[:flat_id])
  end

  def room_params
    params.require(:room).permit(:name, :kind)
  end
end
