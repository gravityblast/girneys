class DashboardsController < ApplicationController
  def show
    stats = Stats.new(RedisBackend)
    @data = stats.all
  end
end
