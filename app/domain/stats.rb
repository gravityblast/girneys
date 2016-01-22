class Stats
  attr_reader :redis

  def initialize redis
    @redis = redis
  end

  def totals year: nil, month: nil, email_type: nil
    suffix = key_suffix year: year, month: month, email_type: email_type
    sent = redis.get("emails.send.#{suffix}").to_f
    opened = redis.get("emails.open.#{suffix}").to_f
    clicked = redis.get("emails.click.#{suffix}").to_f

    {
      total_sent: sent,
      total_opened: opened,
      total_clicks: clicked,
    }
  end

  def rates year: nil, month: nil, email_type: nil
    counts     = totals year: year, month: month, email_type: email_type
    open_rate  = counts[:total_sent] > 0 ? 100 * counts[:total_opened] / counts[:total_sent] : 0
    click_rate = counts[:total_sent] > 0 ? 100 * counts[:total_clicks] / counts[:total_sent] : 0

    {
      open: open_rate.round(2),
      click: click_rate.round(2)
    }
  end

  def all year: nil, month: nil
    result = totals year: year, month: month
    result[:rates] = rates year: year, month: month

    result[:email_types] = []
    redis.smembers('email.types').to_a.each do |type|
      result[:email_types] << {
        name: type,
        rates: rates(year: year, month: month, email_type: type)
      }
    end

    result[:available_dates] = []
    redis.smembers('years').to_a.sort.reverse.each do |year|
      result[:available_dates] << {
        year: year,
        months: redis.smembers("year.months:#{year}").to_a
      }
    end

    result
  end

  private

  def key_suffix year: nil, month: nil, email_type: nil
    keys, values = if year && month
      ["year.month", ":#{year.to_i}:#{"%02d" % month.to_i}"]
    elsif year
      ["year", ":#{year.to_s}"]
    else
      ['overall', '']
    end

    if email_type
      keys << '.type'
      values << ":#{email_type}"
    end

    "#{keys}#{values}"
  end
end
