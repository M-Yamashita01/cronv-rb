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
      def parse(context = {}, line)
        parts = line.split(' ')
        schedule = nil
        job = []

        if parts[0].start_with?('@')
          if parts.length < 2
            # TODO: raise error
            return nil
          end

          if parts[0] == '@reboot'
            return Extra.new(
              line: line,
              label: parts[0],
              job: parts[1..].join(' ')
            )
          end

        else
          if parts.length < 5
            # TODO: メッセージの改善
            Logger.error("invalid crontab line: '#{line}'")
            return nil
          end

          schedule = Schedule.new(
            parts[0],
            parts[1],
            parts[2],
            parts[3],
            parts[4],
            nil,
            nil
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

    def running_every_minutes?(schedule)
      return true if schedule.minutes == '*' || schedule.minutes == '*/1'

      false
    end
  end
end
