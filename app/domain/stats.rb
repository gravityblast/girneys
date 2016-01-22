class Stats
  attr_reader :redis

  def initialize redis
    @redis = redis
  end

  def totals year: nil, month: nil
    suffix = if year && month
      "year.month:#{year.to_i}:#{"%02d" % month.to_i}"
    elsif year
      "year:#{year}"
    else
      'overall'
    end

    {
      total_sent: redis.get("emails.send.#{suffix}"),
      total_opened: redis.get("emails.open.#{suffix}"),
      total_clicks: redis.get("emails.click.#{suffix}")
    }
  end

  def rates year: nil, month: nil, email_type: nil
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

    suffix = "#{keys}#{values}"

    sent = redis.get("emails.send.#{suffix}").to_f
    opened = redis.get("emails.open.#{suffix}").to_f
    clicked = redis.get("emails.click.#{suffix}").to_f

    open_rate = sent > 0 ? 100 * opened / sent : 0
    click_rate = sent > 0 ? 100 * clicked / sent : 0

    {
      open: open_rate.round(2),
      click: click_rate.round(2)
    }
  end

  def all year: nil, month: nil
    result = totals
    result[:rates] = rates year: year, month: month
    result[:email_types] = []

    redis.smembers('email.types').to_a.each do |type|
      result[:email_types] << {
        name: type,
        rates: rates(year: year, month: month, email_type: type)
      }
    end

    result
  end
end
