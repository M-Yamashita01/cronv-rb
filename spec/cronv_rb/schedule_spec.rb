# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CronvRb::Schedule do
  describe '#to_crontab' do
    context 'when a cron job runs only on specified day' do
      let(:schedule) { CronvRb::Schedule.new(minutes: '01', hour: '04', day_of_month: '1', month: '1', day_of_week: '1', year: '2024', schedule_alias: nil) }

      it 'should return formatted crontab' do
        expect(schedule.to_crontab).to eq('01 04 1 1 1 2024')
      end
    end

    context 'when a cron job runs on specified days' do
      let(:schedule) { CronvRb::Schedule.new(minutes: '01,31', hour: '04,05', day_of_month: '1-15', month: '1,6', day_of_week: '1', year: '2024', schedule_alias: nil) }

      it 'should return formatted crontab' do
        expect(schedule.to_crontab).to eq('01,31 04,05 1-15 1,6 1 2024')
      end
    end

    context 'when the schedule uses an @alias' do
      %w[@hourly @daily @weekly @monthly @yearly].each do |schedule_alias|
        it "should return the alias '#{schedule_alias}' as-is" do
          schedule = CronvRb::Schedule.new(minutes: nil, hour: nil, day_of_month: nil, month: nil, day_of_week: nil, year: nil, schedule_alias: schedule_alias)
          expect(schedule.to_crontab).to eq(schedule_alias)
        end
      end
    end
  end
end
