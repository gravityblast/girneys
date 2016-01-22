require 'rails_helper'

RSpec.describe EventsController, :type => :controller do
  context 'valid data' do
    it 'saves the event' do
      expect do
        post :create, EmailType: 'shipment', 'Event': 'foo'
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
