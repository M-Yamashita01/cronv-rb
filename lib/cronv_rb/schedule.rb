# frozen_string_literal: true

module CronvRb
  class Schedule
    attr_reader :minutes, :hour, :day_of_month, :month, :day_of_week, :year

    # rubocop:disable Metrics/ParameterLists
    def initialize(minutes, hour, day_of_month, month, day_of_week, year, schedule_alias)
      @minutes = minutes
      @hour = hour
      @day_of_month = day_of_month
      @month = month
      @day_of_week = day_of_week
      @year = year
      @schedule_alias = schedule_alias
    end
    # rubocop:enable Metrics/ParameterLists

    def to_crontab
      "#{@minutes} #{@hour} #{@day_of_month} #{@month} #{@day_of_week} #{@year}"
    end
  end
end
