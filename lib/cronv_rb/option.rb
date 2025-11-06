# frozen_string_literal: true

module CronvRb
  class Option
    OPT_DATE_FORMAT = '%Y/%m/%d'
    OPT_TIME_FORMAT = '%H:%M'
    OPT_DEFAULT_DURATION = '6h'
    OPT_DEFAULT_OUTPUT_PATH = './crontab.html'
    OPT_DEFAULT_TITLE = 'Cron Tasks'
    OPT_DEFAULT_WIDTH = 100

    def to_from_time
      parsed = Time.strptime("#{@from_date} #{@from_time}", "#{OPT_DATE_FORMAT} #{OPT_TIME_FORMAT}")
      Time.utc(parsed.year, parsed.month, parsed.day, parsed.hour, parsed.min, 0)
    rescue ArgumentError => e
      raise ArgumentError, "invalid date/time format: '#{@from_date} #{@from_time}', #{e.message}"
    end

    def to_duration_minutes
      if @duration.length < 2
        Logger.error("invalid duration format: #{duration}")
        return 0
      end

      duration_i = @duration.chop.to_i
      unit = @duration.chars.last

      case unit
      when 'd'
        duration_i * 24 * 60
      when 'h'
        duration_i * 60
      when 'm'
        duration_i
      else
        Logger.error("invalid duration format: #{@duration}, '#{unit}' is not in d/h/m")
        0
      end
    end

    def self.new_cronv_option(now)
      utc_now = now.utc
      new(utc_now.strftime(OPT_DATE_FORMAT), utc_now.strftime(OPT_TIME_FORMAT))
    end

    private

    def initialize(from_date, from_time)
      @output_file_path = OPT_DEFAULT_OUTPUT_PATH
      @duration = OPT_DEFAULT_DURATION
      @from_date = from_date
      @from_time = from_time
      @title = OPT_DEFAULT_TITLE
      @width = OPT_DEFAULT_WIDTH
    end
  end
end
