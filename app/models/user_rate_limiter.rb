class UserRateLimiter < ApplicationRecord
  validates :user_id, presence: true

  class RateLimitExceeded < StandardError
    def initialize(threshold_limit_minus_now)
      super(
          I18n.t('rate_limit_exceeded',
                 seconds: threshold_limit_minus_now.to_i)
      )
    end
  end

  def check_if_rate_limit_exceeded!
    if (threshold_limit.utc - Time.now.utc) > rate_limit_time_scope_threshold
      raise RateLimitExceeded.new(threshold_limit.utc - Time.now.utc - rate_limit_time_scope_threshold)
    end
  end

  def consume!
    if threshold_limit.nil? || threshold_limit < Time.now.utc
      self.threshold_limit = Time.now.utc + rate_limit_seconds_per_request
    end
    check_if_rate_limit_exceeded!
    update(threshold_limit: threshold_limit + rate_limit_seconds_per_request)
  end

  def rate_limit_seconds_per_request
    rate_limit_time_scope.to_i / rate_limit_requests_count
  end

  def rate_limit_time_scope_threshold
    # this attribute is responsible for wiggle room around blocking requests
    # it allows for bursting requests, in current example we allow users
    # a burst of 50 requests in 30 minutes
    rate_limit_time_scope.to_i / 2
  end

  def rate_limit_time_scope
    1.hour
  end

  def rate_limit_requests_count
    100
  end
end
