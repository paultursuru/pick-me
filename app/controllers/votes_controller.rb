class VotesController < ApplicationController
  def create
    @vote = Vote.new(vote_params)
    @vote.user = current_user
    @vote.option = Option.find(params[:option_id])

    @item = @vote.option.item
    @room = @item.room
    authorize @vote

    if @vote.save!
      respond_to do |format|
        format.html { redirect_to room_item_path(@room, @item) }
      end
    else
      @option = Option.new
      @options = @item.options
      respond_to do |format|
        format.html { render 'items/show' }
      end
    end
  end

  def update
    @vote = Vote.find(params[:id])
    authorize @vote
    @vote.update(vote_params)
    @item = @vote.item
    @room = @item.room
    respond_to do |format|
      format.html { redirect_to room_item_path(@room, @item) }
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:stars)
  end
end
