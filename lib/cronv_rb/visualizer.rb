# frozen_string_literal: true

require 'logger'
require 'time'

module CronvRb
  class Visualizer
    attr_reader :option, :time_from, :time_to, :duration_minutes, :records, :extras

    class << self
      def new_visualizer(option)
        time_from = option.to_from_time
        duration_minutes = option.to_duration_minutes
        time_to = time_from + duration_minutes * 60

        new(option, time_from, time_to, duration_minutes)
      end
    end

    def add(line)
      trimmed = line.strip

      return [false, nil] if trimmed.empty? || trimmed.start_with?('#')

      record, extra = Record.new_record(line: trimmed, start_time: @time_from, duration_minutes: @duration_minutes)

      @records.push(record) unless record.nil?
      @extras.push(extra) unless extra.nil?

      [true, nil]
    end

    private

    def initialize(option, time_from, time_to, duration_minutes)
      @option = option
      @time_from = time_from
      @time_to = time_to
      @duration_minutes = duration_minutes
      @records = []
      @extras = []
    end
  end
end
