# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CronvRb::Crontab do
  describe '#running_every_minutes?' do
    let(:crontab) { described_class.new(line: '', schedule: nil, job: nil) }

    context 'when the schedule is running every minute using *' do
      let(:schedule) { CronvRb::Schedule.new(minutes: '*', hour: '*', day_of_month: '*', month: '*', day_of_week: '*', year: '*', schedule_alias: nil) }

      it 'should return true' do
        expect(crontab.running_every_minutes?(schedule)).to be true
      end
    end

    context 'when the schedule is running every minute using */1' do
      let(:schedule) { CronvRb::Schedule.new(minutes: '*/1', hour: '*', day_of_month: '*', month: '*', day_of_week: '*', year: '*', schedule_alias: nil) }

      it 'should return true' do
        expect(crontab.running_every_minutes?(schedule)).to be true
      end
    end

    context 'when the schedule is not running every minute' do
      let(:schedule) { CronvRb::Schedule.new(minutes: '0', hour: '0', day_of_month: '1', month: '1', day_of_week: '1', year: '2024', schedule_alias: nil) }

      it 'should return false' do
        expect(crontab.running_every_minutes?(schedule)).to be false
      end
    end

    context 'when only minutes is * but other fields are not' do
      let(:schedule) { CronvRb::Schedule.new(minutes: '*', hour: '0', day_of_month: '*', month: '*', day_of_week: '*', year: nil, schedule_alias: nil) }

      it 'should return false' do
        expect(crontab.running_every_minutes?(schedule)).to be false
      end
    end
  end

  describe '.parse' do
    context 'when the line is a valid crontab line' do
      let(:line) { '0 0 * * * /usr/bin/somecommand' }

      it 'should return a Crontab object' do
        crontab, extra = described_class.parse(line)
        expect(crontab).to be_a(CronvRb::Crontab)
        expect(crontab.line).to eq(line)
        expect(crontab.schedule.minutes).to eq('0')
        expect(crontab.schedule.hour).to eq('0')
        expect(crontab.schedule.day_of_month).to eq('*')
        expect(crontab.schedule.month).to eq('*')
        expect(crontab.schedule.day_of_week).to eq('*')
        expect(crontab.schedule.year).to be_nil
        expect(crontab.schedule.schedule_alias).to be_nil
        expect(crontab.job).to eq('/usr/bin/somecommand')
        expect(extra).to be_nil
      end
    end

    context 'when the line is an valid crontab line and command with arguments' do
      let(:line) { '0 0 * * * /usr/bin/somecommand arg1 arg2' }

      it 'should return a Crontab object' do
        crontab, extra = described_class.parse(line)
        expect(crontab.schedule.minutes).to eq('0')
        expect(crontab.schedule.hour).to eq('0')
        expect(crontab.schedule.day_of_month).to eq('*')
        expect(crontab.schedule.month).to eq('*')
        expect(crontab.schedule.day_of_week).to eq('*')
        expect(crontab.schedule.year).to be_nil
        expect(crontab.schedule.schedule_alias).to be_nil
        expect(crontab.job).to eq('/usr/bin/somecommand arg1 arg2')
        expect(extra).to be_nil
      end
    end

    context 'when the line is has @reboot label' do
      let(:line) { '@reboot /usr/bin/somecommand' }

      it 'should return a Extra object' do
        crontab, extra = described_class.parse(line)
        expect(crontab).to be_nil
        expect(extra).to be_a(CronvRb::Extra)
        expect(extra.line).to eq(line)
        expect(extra.label).to eq('@reboot')
        expect(extra.job).to eq('/usr/bin/somecommand')
      end
    end

    context 'when the line is has @hourly label' do
      let(:line) { '@hourly /usr/bin/somecommand' }

      it 'should return a Crontab object' do
        crontab, extra = described_class.parse(line)
        expect(crontab).to be_a(CronvRb::Crontab)
        expect(crontab.line).to eq(line)
        expect(crontab.schedule.schedule_alias).to eq('@hourly')
        expect(crontab.job).to eq('/usr/bin/somecommand')
        expect(extra).to be_nil
      end
    end
  end
end
