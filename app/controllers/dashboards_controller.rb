class DashboardsController < ApplicationController
  def show
    stats = Stats.new(RedisBackend)
    @data = stats.all year: params[:year].presence, month: params[:month].presence
    if request.xhr?
      render partial: 'main', locals: { data: @data }
    end
  end
end
