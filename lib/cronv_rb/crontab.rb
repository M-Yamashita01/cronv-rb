# frozen_string_literal: true

module CronvRb
  class Crontab
    def running_every_minutes?(schedule)
      return true if schedule.minutes == '*' || schedule.minutes == '*/1'

      false
    end
  end
end
