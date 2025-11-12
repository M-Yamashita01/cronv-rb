# frozen_string_literal: true

require 'logger'
require 'time'

module CronvRb
  class Visualizer
    class << self
      def new_visualizer(option)
        time_from = option.to_from_time
        duration_minutes = option.to_duration_minutes
        time_to = time_from + duration_minutes * 60

        new(option, time_from, time_to, duration_minutes)
      end
    end

    private

    def initialize(option, time_from, time_to, duration_minutes)
      @option = option
      @time_from = time_from
      @time_to = time_to
      @duration_minutes = duration_minutes
    end
  end
end
