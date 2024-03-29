class OptionsController < ApplicationController
  before_action :set_item, only: [:new, :create, :edit, :update, :destroy]

  def new
    @option = @item.options.new
    authorize @option
  end

  def create
    @option = @item.options.new(option_params)
    authorize @option
    if url = params[:option][:image_url]
      file = URI.open(url)
      @option.image.attach(io: file, filename: "option.png", content_type: "image/png")
    end

    if @option.save
      respond_to do |format|
        format.html { redirect_to room_item_path(@item.room, @item) }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @option = Option.find(params[:id])
    authorize @option
  end

  def update
    @option = Option.find(params[:id])
    authorize @option
    if @option.update(option_params)
      redirect_to room_item_path(@item.room, @item)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @option = Option.find(params[:id])
    authorize @option
    @option.destroy
    respond_to do |format|
      format.html { redirect_to room_item_path(@item.room, @item), status: :see_other }
      format.turbo_stream
    end
  end

  private

  def option_params
    params.require(:option).permit(:name, :price, :image, :description, :url, :size)
  end

  def set_item
    @item = Item.find(params[:item_id])
  end
end
