class FlatsController < ApplicationController
  def show
    @flat = Flat.find(params[:id])
    authorize @flat
    @rooms = @flat.rooms.ordered
    @room = Room.new
    # @items = @flat.items.by_importance.ordered
    # @item = Item.new
    @invitations = @flat.invitations.pending_or_accepted
    @current_user_invitation = @invitations.find_by(user: current_user)
    @invitation = Invitation.new
  end

  def new
    @flat = current_user.flats.new
    authorize @flat
  end

  def create
    @flat = current_user.flats.new(flat_params)
    authorize @flat
    if @flat.save
      respond_to do |format|
        format.html { flat_path(@flat) }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @flat = Flat.find(params[:id])
    authorize @flat
    @flat.destroy
    respond_to do |format|
      format.html { redirect_to dashboard_path, status: :see_other }
      format.turbo_stream
    end
  end

  private

  def flat_params
    params.require(:flat).permit(:name, :address, :photo)
  end
end
