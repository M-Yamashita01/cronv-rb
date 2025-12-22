# frozen_string_literal: true

module CronvRb
  class Extra
    attr_reader :line, :label, :job

    def initialize(line:, label:, job:)
      @line = line
      @label = label
      @job = job
    end
  end

  class Crontab
    attr_reader :line, :schedule, :job

    def initialize(line:, schedule:, job:)
      @line = line
      @schedule = schedule
      @job = job
    end

    class << self
      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Lint/UnusedMethodArgument
      # rubocop:disable Style/OptionalArguments
      def parse(context = {}, line)
        parts = line.split(' ')
        schedule = nil
        job = []

        if parts[0].start_with?('@')
          if parts.length < 2
            Logger.error("invalid crontab line: '#{line}'")
            return nil
          end

          if parts[0] == '@reboot'
            return Extra.new(
              line: line,
              label: parts[0],
              job: parts[1..].join(' ')
            )
          end

          schedule = Schedule.new(
            minutes: nil,
            hour: nil,
            day_of_month: nil,
            month: nil,
            day_of_week: nil,
            year: nil,
            schedule_alias: parts[0]
          )

          return Crontab.new(
            line: line,
            schedule: schedule,
            job: parts[1..].join(' ')
          )
        else
          if parts.length < 5
            Logger.error("invalid crontab line: '#{line}'")
            return nil
          end

          schedule = Schedule.new(
            minutes: parts[0],
            hour: parts[1],
            day_of_month: parts[2],
            month: parts[3],
            day_of_week: parts[4],
            year: nil,
            schedule_alias: nil
          )

          job = parts[5..].join(' ')
        end

        Crontab.new(
          line: line,
          schedule: schedule,
          job: job
        )
      end
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Lint/UnusedMethodArgument
    # rubocop:enable Style/OptionalArguments

    def running_every_minutes?(schedule)
      return true if schedule.minutes == '*' || schedule.minutes == '*/1'

      false
    end
  end
end
