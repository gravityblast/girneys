require 'rails_helper'

class FakeRedis
  def incr key; end
  def sadd key, item; end
end

RSpec.describe Store do
  let(:redis) { FakeRedis.new }

  describe '#keys_for' do
    it 'builds all-time/year/month keys for a given event' do
      store = Store.new nil
      keys = store.keys_for :send, 'shipment', Date.parse('2015-10-01')

      expected = [
        # sent emails
        'emails.send.overall',
        # sent emails of type shipment
        'emails.send.overall.type:shipment',

        # emails sent in 2015
        'emails.send.year:2015',
        # emails sent in 2015 of type shipment
        'emails.send.year.type:2015:shipment',

        # emails sent in October 2015
        'emails.send.year.month:2015:10',
        # emails sent in October 2015 of type shipment
        'emails.send.year.month.type:2015:10:shipment',
      ]
      expect(keys).to eq(expected)
    end
  end

  describe '#save' do
    context 'unknown event' do
      it 'does nothing' do
        expect(redis).to receive(:incr).at_most(0).times

        store = Store.new redis
        store.save Event.new data: { 'Event' => :foo }
      end
    end

    context 'valid event' do
      it 'increments 6 counters' do
        expect(redis).to receive(:incr).exactly(6).times
        expect(redis).to receive(:sadd).with('email.types', 'shipment').exactly(1).times
        expect(redis).to receive(:sadd).with('years', '2015').exactly(1).times
        expect(redis).to receive(:sadd).with('year.months:2015', '05').exactly(1).times

        store = Store.new redis
        store.save Event.new data: { 'Event' => 'send', 'EmailType' => 'Shipment', 'Timestamp' => 1432820704}
      end
    end
  end
end
