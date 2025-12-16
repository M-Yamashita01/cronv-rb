# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CronvRb::Visualizer do
  describe '.new_visualizer' do
    let(:now) { Time.new(2024, 11, 25, 13, 30, 0, '+09:00') }

    it 'should return visualizer instance' do
      option = CronvRb::Option.new_cronv_option(now)
      visualizer = CronvRb::Visualizer.new_visualizer(option)

      time_from = visualizer.instance_variable_get(:@time_from)
      time_to = visualizer.instance_variable_get(:@time_to)

      expect(time_from).to be_a(Time)
      expect(time_from).to eq(Time.utc(2024, 11, 25, 4, 30, 0))
      expect(time_to).to be_a(Time)
      expect(time_to).to eq(Time.utc(2024, 11, 25, 10, 30, 0))
    end
  end
end
