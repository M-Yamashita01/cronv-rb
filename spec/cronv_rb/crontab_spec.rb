# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CronvRb::Crontab do
  describe '#running_every_minutes?' do
    context 'when the schedule is running every minute using *' do
      let(:schedule) { CronvRb::Schedule.new('*', '*', '*', '*', '*', '*', nil) }

      it 'should return true' do
        expect(described_class.new.running_every_minutes?(schedule)).to be true
      end
    end

    context 'when the schedule is running every minute using */1' do
      let(:schedule) { CronvRb::Schedule.new('*/1', '*', '*', '*', '*', '*', nil) }

      it 'should return true' do
        expect(described_class.new.running_every_minutes?(schedule)).to be true
      end
    end

    context 'when the schedule is not running every minute' do
      let(:schedule) { CronvRb::Schedule.new('0', '0', '1', '1', '1', '2024', nil) }

      it 'should return false' do
        expect(described_class.new.running_every_minutes?(schedule)).to be false
      end
    end
  end
end
