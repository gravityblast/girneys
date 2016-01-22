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

  after_create :save_to_store

  private

  def save_to_store
    Store.new(RedisBackend).save self
  end
end
