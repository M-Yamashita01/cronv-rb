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
end
