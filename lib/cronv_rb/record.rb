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
      @start_time = start_time
      @duration_minutes = duration_minutes
    end
  end
end
