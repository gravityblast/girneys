require 'rails_helper'

RSpec.describe Event, :type => :model do
  describe 'validations' do
    context 'invalid data' do
      it 'requires data' do
        event = Event.new
        expect(event).to_not be_valid
        expect(event.errors['data']).to be_present
      end

      it 'requires data to be an Hash' do
        event = Event.new data: 1
        expect(event).to_not be_valid
        expect(event.errors['data']).to be_present
      end
    end

    context 'valid data' do
      it 'is a valid record' do
        event = Event.new data: { foo: :bar }
        expect(event).to be_valid
      end
    end
  end
end
