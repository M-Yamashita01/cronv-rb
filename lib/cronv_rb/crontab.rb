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
      # return [crontab, extra]
      def parse(context = {}, line)
        parts = line.split
        schedule = nil
        job = []

        if parts[0].start_with?('@')
          raise ArgumentError, "invalid crontab line: '#{line}'" if parts.length < 2

          if parts[0] == '@reboot'
            return [nil,
                    Extra.new(
                      line: line,
                      label: parts[0],
                      job: parts[1..].join(' ')
                    )]
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

          return [Crontab.new(
            line: line,
            schedule: schedule,
            job: parts[1..].join(' ')
          ), nil]
        else
          raise ArgumentError, "invalid crontab line: '#{line}'" if parts.length < 5

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

        [Crontab.new(
          line: line,
          schedule: schedule,
          job: job
        ), nil]
      end
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Lint/UnusedMethodArgument
    # rubocop:enable Style/OptionalArguments

    def running_every_minutes?(schedule)
      fields = schedule.to_crontab.split
      fields.each_with_index.all? do |field, i|
        if i.zero?
          %w[* */1].include?(field)
        else
          field == '*'
        end
      end
    end
  end
end
