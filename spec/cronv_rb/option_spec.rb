# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CronvRb::Option do
  describe '#to_from_time' do
    context 'with valid date and time' do
      it 'should return Time object in UTC' do
        now = Time.new(2016, 11, 8, 1, 30, 0, 0)
        option = CronvRb::Option.new_cronv_option(now)
        result = option.to_from_time

        expect(result).to be_a(Time)
        expect(result.year).to eq(2016)
        expect(result.month).to eq(11)
        expect(result.day).to eq(8)
        expect(result.hour).to eq(1)
        expect(result.min).to eq(30)
        expect(result.utc?).to be true
      end

      it 'should parse date and time correctly' do
        # Go版のテストケースを参考に
        now = Time.new(2016, 11, 8, 1, 30, 0, 0)
        option = CronvRb::Option.new_cronv_option(now)
        result = option.to_from_time

        expected = Time.new(2016, 11, 8, 1, 30, 0, 0).utc
        expect(result).to eq(expected)
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
