# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CronvRb::Schedule do
  describe '#to_crontab' do
    context 'when a cron job runs only on specified day' do
      let(:schedule) { CronvRb::Schedule.new('01', '04', '1', '1', '1', '2024', nil) }

      it 'should return formatted crontab' do
        expect(schedule.to_crontab).to eq('01 04 1 1 1 2024')
      end
    end

    context 'when a cron job runs on specified days' do
      let(:schedule) { CronvRb::Schedule.new('01,31', '04,05', '1-15', '1,6', '1', '2024', nil) }

      it 'should return formatted crontab' do
        expect(schedule.to_crontab).to eq('01,31 04,05 1-15 1,6 1 2024')
      end
    end
  end
end
