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
    if Invitation.where(user: @user, flat: @flat).any?
      @invitation = Invitation.where(user: @user, flat: @flat).first
      @invitation.update_attribute(:level, params[:invitation][:level])
      @invitation.pending!
    else
      @invitation.flat = @flat
      @invitation.user = @user
    end
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
      format.html { redirect_to flat_path(@invitation.flat), status: :see_other }
      format.turbo_stream
    end
  end

  def accept
    @invitation = Invitation.find(params[:id])
    @flat = @invitation.flat
    authorize @invitation
    @invitation.accepted!
    respond_to do |format|
      format.html { redirect_to flat_path(@invitation.flat), status: :see_other }
      format.turbo_stream
    end
  end

  def decline
    @invitation = Invitation.find(params[:id])
    @flat = @invitation.flat
    authorize @invitation
    @invitation.declined!
    if @flat.user == current_user
      respond_to do |format|
        format.html { redirect_to flat_path(@invitation.flat), status: :see_other }
        format.turbo_stream
      end
    else
      redirect_to dashboard_path, status: :see_other, notice: "You have declined the invitation to join the flat."
    end
  end

  private

  def invite_params
    params.require(:invitation).permit(:email, :level)
  end

  def set_flat
    @flat = Flat.find(params[:flat_id])
  end
end
