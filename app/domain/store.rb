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
    keys = keys_for event_name, email_type

    keys.each do |key|
      redis.incr key
    end

    redis.sadd 'email.types', email_type
  end

  def keys_for event_name, email_type
    type = email_type
    today = Date.today
    year  = today.year
    month = "%02d" % today.month

    [
      # sent emails
      "emails.#{event_name}.overall",
      # sent emails of specific type
      "emails.#{event_name}.overall.type:#{type}",

      # sent emails in year
      "emails.#{event_name}.year:#{year}",
      # sent emails in year for specific type
      "emails.#{event_name}.year.type:#{year}:#{type}",

      # sent emails in year/month
      "emails.#{event_name}.year.month:#{year}:#{month}",
      # sent emails in year/month for specific type
      "emails.#{event_name}.year.month.type:#{year}:#{month}:#{type}",
    ]
  end
end
