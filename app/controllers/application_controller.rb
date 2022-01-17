class ApplicationController < ActionController::API
  rescue_from StandardError do |exception|
    render json: { status: :error, message: exception.message }, status: 422
  end
end
