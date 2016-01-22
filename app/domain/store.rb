class Store
  VALID_EVENT_NAMES = %w[send click open]

  attr_reader :redis

  def initialize redis
    @redis = redis
  end

  def save event
    event_name = event.data.is_a?(Hash) && event.data['Event']
    return unless VALID_EVENT_NAMES.include? event_name

    email_type = event.data['EmailType'].to_s.downcase
    time = time_at event.data['Timestamp']
    keys = keys_for event_name, email_type, time

    keys.each do |key|
      redis.incr key
    end

    redis.sadd 'email.types', email_type
    if time
      redis.sadd 'years', time.year.to_s
      redis.sadd "year.months:#{time.year}", ("%02d" % time.month)
    end
  end

  def keys_for event_name, email_type, time
    time ||= Time.now
    year  = time.year
    month = "%02d" % time.month

    [
      # sent emails
      "emails.#{event_name}.overall",
      # sent emails of specific type
      "emails.#{event_name}.overall.type:#{email_type}",

      # sent emails in year
      "emails.#{event_name}.year:#{year}",
      # sent emails in year for specific type
      "emails.#{event_name}.year.type:#{year}:#{email_type}",

      # sent emails in year/month
      "emails.#{event_name}.year.month:#{year}:#{month}",
      # sent emails in year/month for specific type
      "emails.#{event_name}.year.month.type:#{year}:#{month}:#{email_type}",
    ]
  end

  def time_at timestamp
    Time.at timestamp
  rescue
  end
end
