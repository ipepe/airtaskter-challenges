class UserRateLimitersController < ApplicationController
  def index
    redirect_to consume_api_user_rate_limiter_path(
      SecureRandom.uuid
    )
  end

  rescue_from UserRateLimiter::RateLimitExceeded do |exception|
    flash[:alert] = exception.message
    render :consume_api, status: 429
  end

  def consume_api
    @result = 'empty'
    @rate_limiter = UserRateLimiter.find_or_create_by(user_id: params[:id])
    @rate_limiter.consume!
    @result = 'ok'
  end
end
