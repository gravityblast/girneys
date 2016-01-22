require 'rails_helper'

class FakeRedisBackend
  def get k; end
  def set k, v; end
  def sadd k, v; end
  def smembers k; [] end
end

RedisBackend = FakeRedisBackend.new

RSpec.describe EventsController, :type => :controller do
  context 'valid data' do
    it 'saves the event' do
      expect do
        post :create, params: { EmailType: 'shipment', 'Event': 'foo' }
      end.to change(Event, :count).by(1)
    end
  end

  context 'invalid data' do
    it 'returns an error' do
      expect do
        post :create
      end.to_not change(Event, :count)
      expect(response.status).to eq(422)
    end
  end
end
