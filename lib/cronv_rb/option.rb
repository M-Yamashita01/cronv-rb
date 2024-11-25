module CronvRb
  class Option
    OPT_DATE_FORMAT = '%Y/%m/%d'.freeze
    OPT_TIME_FORMAT = '%H:%M'.freeze
    OPT_DEFAULT_DURATION = '6h'.freeze
    OPT_DEFAULT_OUTPUT_PATH = './crontab.html'.freeze
    OPT_DEFAULT_TITLE = 'Cron Tasks'.freeze
    OPT_DEFAULT_WIDTH = 100

    def to_from_time
      "#{@from_date} #{@from_time}"
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
