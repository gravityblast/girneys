class DashboardsController < ApplicationController
  def show
    stats = Stats.new(RedisBackend)
    @data = stats.all
    if request.xhr?
      render partial: 'main', locals: { data: @data }
    end
  end
end
