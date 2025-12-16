# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CronvRb::Option do
  describe '#to_from_time' do
    let(:now) { Time.new(2016, 11, 8, 1, 30, 0, 0) }
    let(:option) { CronvRb::Option.new_cronv_option(now) }

    it 'returns parsed Time object in UTC' do
      result = option.to_from_time
      expect(result).to be_a(Time)
      expect(result).to eq(Time.utc(2016, 11, 8, 1, 30, 0))
    end
  end

  describe '#to_duration_minutes' do
    let(:now) { Time.new(2024, 11, 25, 13, 30, 0, '+09:00') }
    let(:option) { CronvRb::Option.new_cronv_option(now) }

    context 'with valid duration' do
      it 'returns correct minutes for 1m, 2h, 3d' do
        option.instance_variable_set(:@duration, '1m')
        expect(option.to_duration_minutes).to eq(1.0)
        option.instance_variable_set(:@duration, '2h')
        expect(option.to_duration_minutes).to eq(120.0)
        option.instance_variable_set(:@duration, '3d')
        expect(option.to_duration_minutes).to eq(4320.0)
      end
    end

    context 'with invalid duration' do
      it 'raises error for invalid formats' do
        option.instance_variable_set(:@duration, 'I')
        expect { option.to_duration_minutes }.to raise_error(ArgumentError, "invalid duration format: 'I'")
        option.instance_variable_set(:@duration, 'INVALID')
        expect { option.to_duration_minutes }.to raise_error(ArgumentError, /invalid duration format: 'INVALID'/)
        option.instance_variable_set(:@duration, '1F')
        expect { option.to_duration_minutes }.to raise_error(ArgumentError, "invalid duration format: '1F', 'F' is not in d/h/m")
      end
    end
  end
end
