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
      # next_time.to_s example : "2024-06-02 00:00:00 +0900"
      next_time = @fugit_cron.next_time(@start_time.to_s)
      @parsed_next_time = Time.new(next_time.to_s)

      while @parsed_next_time <= end_time
        array.push({ start: @parsed_next_time, end: @parsed_next_time + 60 })
        @parsed_next_time = @fugit_cron.next_time(@parsed_next_time.to_s)
      end

      array
    end
  end
end
