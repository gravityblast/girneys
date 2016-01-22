class EventDataFormatValidator < ActiveModel::Validator
  def validate record
    unless record.data.is_a? Hash
      record.errors[:data] << 'is not a valid json object'
    end
  end
end

class Event < ApplicationRecord
  validates :data, presence: true
  validates_with EventDataFormatValidator
end
