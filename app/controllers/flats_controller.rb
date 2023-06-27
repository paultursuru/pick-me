class FlatsController < ApplicationController
  before_action :set_flat, only: [:edit, :update, :destroy]

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
        format.html { redirect_to flat_path(@flat) }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @flat.update(flat_params)
      respond_to do |format|
        format.html { redirect_to dashboard_path }
        format.turbo_stream
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @flat.destroy
    respond_to do |format|
      format.html { redirect_to dashboard_path, status: :see_other }
      format.turbo_stream
    end
  end

  private

  def set_flat
    @flat = Flat.find(params[:id])
    authorize @flat
  end

  def flat_params
    params.require(:flat).permit(:name, :address, :budget, :photo)
  end
end
