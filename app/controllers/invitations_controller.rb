class InvitationsController < ApplicationController
  before_action :set_flat, only: [:new, :create]

  def new
    @invitation = @flat.invitations.new
    authorize @invitation
  end

  def create
    @invitation = @flat.invitations.new(invite_params)
    @user = find_or_create_user(params[:invitation][:email])
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
        format.html { redirect_to flat_path(@flat), status: :see_other }
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
    # if @flat.user == current_user
    #   redirect_to dashboard_path, status: :see_other, target: '_top'
    # else
    respond_to do |format|
      format.html { redirect_to flat_path(@invitation.flat), status: :see_other }
      format.turbo_stream
    end
    # end
  end

  private

  def invite_params
    params.require(:invitation).permit(:email, :level)
  end

  def set_flat
    @flat = Flat.find(params[:flat_id])
  end

  def find_or_create_user(email)
    user = User.find_by(email: email)
    if user.nil?
      user = User.create(email: email, password: SecureRandom.hex(10), nickname: email.split('@').first)
    end
    user
  end
end
