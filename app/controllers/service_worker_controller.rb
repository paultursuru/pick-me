class ServiceWorkerController < ApplicationController
  protect_from_forgery except: :service_worker
  skip_before_action :authenticate_user!
  skip_after_action :verify_authorized

  def service_worker
  end

  def manifest
  end
end
