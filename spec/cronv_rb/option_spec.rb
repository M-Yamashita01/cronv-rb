# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CronvRb::Option do
  describe '#to_from_time' do
    context 'with valid date and time' do
      it 'returns parsed Time object in UTC' do
        now = Time.new(2016, 11, 8, 1, 30, 0, 0)
        option = CronvRb::Option.new_cronv_option(now)

        result = option.to_from_time

        expect(result).to be_a(Time)
        expect(result).to eq(Time.utc(2016, 11, 8, 1, 30, 0))
      end
    end
  end

  describe '#to_duration_minutes' do
    let(:now) { Time.new(2024, 11, 25, 13, 30, 0, '+09:00') } # => 2008-06-21 13:30:00 +0900

    it 'should return 360 minutes' do
      option = CronvRb::Option.new_cronv_option(now)
      expect(option.to_duration_minutes).to eq(360)
    end
  end
end
