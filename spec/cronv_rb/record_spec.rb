# frozen_string_literal: true

require 'spec_helper'
RSpec.describe CronvRb::Record do
  describe '.new_record' do
    it 'should return a Record object' do
      record = described_class.new_record(line: '0 0 * * * /usr/bin/somecommand', start_time: Time.now, duration_minutes: 60)
      expect(record).to be_a(CronvRb::Record)
      expect(record.crontab).to be_a(CronvRb::Crontab)
      expect(record.crontab.line).to eq('0 0 * * * /usr/bin/somecommand')
      expect(record.fugit_cron).to be_a(Fugit::Cron)
      expect(record.start_time).to be_a(Time)
      expect(record.duration_minutes).to eq(60)
    end
  end

  describe '#iter' do
    # TODO: 異常系やサイズが0の場合のテストをすること
    context 'when the cron schedule is running every 5 minutes' do
      it 'should return an Enumerator with 11 elements' do
        record = described_class.new_record(
          line: '*/5 0 * * * /usr/bin/somecommand',
          start_time: Time.new('2025-12-25 00:00:00'),
          duration_minutes: 60
        )
        array = record.iter
        expect(array.size).to eq 11

        first_cron_schedule = array.first
        expect(first_cron_schedule[:start].to_s).to eq '2025-12-25 00:05:00 +0000'
        expect(first_cron_schedule[:end].to_s).to eq '2025-12-25 00:06:00 +0000'

        last_cron_schedule = array.last
        expect(last_cron_schedule[:start].to_s).to eq '2025-12-25 00:55:00 +0000'
        expect(last_cron_schedule[:end].to_s).to eq '2025-12-25 00:56:00 +0000'
      end
    end

    context 'when the cron schedule fires exactly at the end time boundary' do
      it 'should include the execution at the end time boundary' do
        record = described_class.new_record(
          line: '0 0 * * * /usr/bin/somecommand',
          start_time: Time.utc(2025, 1, 1, 0, 0, 0),
          duration_minutes: 24 * 60
        )
        array = record.iter
        # Midnight on 2025-01-02 falls exactly on the end boundary and must be included
        expect(array.last[:start]).to include('2025-01-02 00:00:00')
      end
    end

    context 'when the current time and the specified duration are not a cron schedule' do
      it 'should return an Enumerator with 0 element' do
        record = described_class.new_record(
          line: '0 * * * * /usr/bin/somecommand',
          start_time: Time.new('2025-12-25 00:01:00'),
          duration_minutes: 10
        )
        array = record.iter
        expect(array.size).to eq 0
      end
    end
  end
end
