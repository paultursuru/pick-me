class InvitationsController < ApplicationController
  before_action :set_flat, only: [:new, :create]

  def new
    @invitation = @flat.invitations.new
    authorize @invitation
  end

  def create
    @invitation = @flat.invitations.new(invite_params)
    @user = User.find_by(email: params[:invitation][:email])
    authorize @invitation
    @invitation.flat = @flat
    @invitation.user = @user
    if @invitation.save
      respond_to do |format|
        format.html { redirect_to flat_path(@flat) }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @invitation = Invitation.find(params[:id])
    @flat = @invitation.flat
    authorize @invitation
    @invitation.destroy
    respond_to do |format|
      format.html { redirect_to flat_path(@flat), status: :see_other }
      format.turbo_stream
    end
  end

  private

  def invite_params
    params.require(:invitation).permit(:email)
  end

  def set_flat
    @flat = Flat.find(params[:flat_id])
  end
end
