# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CronvRb::Crontab do
  describe '#running_every_minutes?' do
    let(:crontab) { described_class.new(line: '', schedule: nil, job: nil) }

    context 'when the schedule is running every minute using *' do
      let(:schedule) { CronvRb::Schedule.new('*', '*', '*', '*', '*', '*', nil) }

      it 'should return true' do
        expect(crontab.running_every_minutes?(schedule)).to be true
      end
    end

    context 'when the schedule is running every minute using */1' do
      let(:schedule) { CronvRb::Schedule.new('*/1', '*', '*', '*', '*', '*', nil) }

      it 'should return true' do
        expect(crontab.running_every_minutes?(schedule)).to be true
      end
    end

    context 'when the schedule is not running every minute' do
      let(:schedule) { CronvRb::Schedule.new('0', '0', '1', '1', '1', '2024', nil) }

      it 'should return false' do
        expect(crontab.running_every_minutes?(schedule)).to be false
      end
    end
  end

  describe '.parse' do
    context 'when the line is a valid crontab line' do
      let(:line) { '0 0 * * * /usr/bin/somecommand' }

      it 'should return a Crontab object' do
        crontab = described_class.parse(line)
        expect(crontab).to be_a(CronvRb::Crontab)
        expect(crontab.line).to eq(line)
        expect(crontab.schedule.minutes).to eq('0')
        expect(crontab.schedule.hour).to eq('0')
        expect(crontab.schedule.day_of_month).to eq('*')
        expect(crontab.schedule.month).to eq('*')
        expect(crontab.schedule.day_of_week).to eq('*')
        expect(crontab.schedule.year).to be_nil
        # expect(crontab.schedule.schedule_alias).to be_nil
        expect(crontab.job).to eq('/usr/bin/somecommand')
      end
    end

    context 'when the line is an valid crontab line and command with arguments' do
      let(:line) { '0 0 * * * /usr/bin/somecommand arg1 arg2' }

      it 'should return a Crontab object' do
        crontab = described_class.parse(line)
        expect(crontab.schedule.minutes).to eq('0')
        expect(crontab.schedule.hour).to eq('0')
        expect(crontab.schedule.day_of_month).to eq('*')
        expect(crontab.schedule.month).to eq('*')
        expect(crontab.schedule.day_of_week).to eq('*')
        expect(crontab.schedule.year).to be_nil
        # expect(crontab.schedule.schedule_alias).to be_nil
        expect(crontab.job).to eq('/usr/bin/somecommand arg1 arg2')
      end
    end
  end
end
