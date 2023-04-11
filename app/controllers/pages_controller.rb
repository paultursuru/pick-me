class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
  end

  def dashboard
    @flats = policy_scope(Flat)
    @flat = current_user.flats.new
  end
end
