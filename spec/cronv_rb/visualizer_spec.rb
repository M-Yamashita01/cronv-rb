# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CronvRb::Visualizer do
  describe '.new_visualizer' do
    let(:now) { Time.new(2024, 11, 25, 13, 30, 0, '+09:00') }

    it 'should return visualizer instance' do
      option = CronvRb::Option.new_cronv_option(now)
      visualizer = CronvRb::Visualizer.new_visualizer(option)

      expect(visualizer.instance_variable_get(:@time_from).to_s).to eq('2024-11-25 04:30:00 +0000')
      expect(visualizer.instance_variable_get(:@time_to).to_s).to eq('2024-11-25 10:30:00 +0000')
    end
  end
end
