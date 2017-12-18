require 'test_helper'

class UserRateLimiterTest < ActiveSupport::TestCase
  test 'rate limiting' do
    now = Time.now.utc
    rate_limiter = UserRateLimiter.create(user_id: SecureRandom.uuid)
    Timecop.freeze(now) do
      50.times do
        rate_limiter.consume!
      end

      exception = assert_raise UserRateLimiter::RateLimitExceeded do
        rate_limiter.consume!
      end

      assert_equal 'Rate limit exceeded. Try again in 36 seconds', exception.message
    end

    Timecop.freeze(now + 30.minutes) do
      50.times do
        rate_limiter.consume!
      end

      exception = assert_raise UserRateLimiter::RateLimitExceeded do
        rate_limiter.consume!
      end

      assert_equal 'Rate limit exceeded. Try again in 36 seconds', exception.message
    end

    Timecop.freeze(now + 31.minutes) do
      rate_limiter.consume!
      exception = assert_raise UserRateLimiter::RateLimitExceeded do
        rate_limiter.consume!
      end
      assert_equal 'Rate limit exceeded. Try again in 12 seconds', exception.message
    end
    Timecop.freeze(now + 31.minutes + 10.seconds) do
      exception = assert_raise UserRateLimiter::RateLimitExceeded do
        rate_limiter.consume!
      end
      assert_equal 'Rate limit exceeded. Try again in 2 seconds', exception.message
    end
  end
end
