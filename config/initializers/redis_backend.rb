require 'redis'

RedisBackend = Rails.env.test? ? nil : Redis.new
