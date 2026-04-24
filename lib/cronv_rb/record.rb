# frozen_string_literal: true

require 'fugit'

module CronvRb
  class Record
    class << self
      def new_record(line:, start_time:, duration_minutes:, context: {})
        crontab, extra = Crontab.parse(context, line)

        return nil, extra if crontab.nil?

        fugit_cron = Fugit.parse_cron(crontab.schedule.to_crontab)

        new(crontab:, fugit_cron:, start_time:, duration_minutes:)
      end
    end

    attr_reader :crontab, :fugit_cron, :start_time, :duration_minutes

    def initialize(crontab:, fugit_cron:, start_time:, duration_minutes:)
      @crontab = crontab
      @fugit_cron = fugit_cron
      # start_time class Time
      @start_time = start_time
      # duration_minutes class Integer
      @duration_minutes = duration_minutes
    end

    Exec = Struct.new(:start, :end)

    def iter
      array = []

      end_time = @start_time + (@duration_minutes * 60)
      return array if @fugit_cron.nil?

      # next_time is an EtOrbi::EoTime; use .to_t (converts to plain Ruby Time)
      # for comparison to avoid timezone label mismatches ("Z" vs "UTC") that
      # cause string comparison to fail for executions at the exact end boundary.
      @next_time = @fugit_cron.next_time(@start_time.to_s)

      while @next_time.to_t <= end_time
        array.push({ start: @next_time.to_s, end: (@next_time + 60).to_s })
        @next_time = @fugit_cron.next_time(@next_time.to_s)
      end

      array
    end
  end
end
