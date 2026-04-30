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

  describe '#add' do
    let(:now) { Time.new(2024, 11, 25, 13, 30, 0, '+09:00') }

    context 'when the line is a valid cron schedule' do
      it 'should add a record' do
        option = CronvRb::Option.new_cronv_option(now)
        visualizer = CronvRb::Visualizer.new_visualizer(option)
        visualizer.add('0 0 * * * /usr/bin/somecommand')
        expect(visualizer.records.size).to eq(1)
      end

      it 'should add an extra' do
        option = CronvRb::Option.new_cronv_option(now)
        visualizer = CronvRb::Visualizer.new_visualizer(option)
        visualizer.add('@reboot /usr/bin/somecommand')
        expect(visualizer.extras.size).to eq(1)
      end
    end

    context 'when the line is empty' do
      it 'should not add a record' do
        option = CronvRb::Option.new_cronv_option(now)
        visualizer = CronvRb::Visualizer.new_visualizer(option)
        visualizer.add('')
        expect(visualizer.records.size).to eq(0)
      end
    end

    context 'when the line starts with #' do
      it 'should not add a record' do
        option = CronvRb::Option.new_cronv_option(now)
        visualizer = CronvRb::Visualizer.new_visualizer(option)
        visualizer.add('# This is a comment')
        expect(visualizer.records.size).to eq(0)
      end
    end

    context 'when the line is an invalid crontab entry' do
      it 'should skip the line without crashing' do
        option = CronvRb::Option.new_cronv_option(now)
        visualizer = CronvRb::Visualizer.new_visualizer(option)
        result = visualizer.add('MAILTO=admin@example.com')
        expect(result).to eq([false, nil])
        expect(visualizer.records.size).to eq(0)
        expect(visualizer.extras.size).to eq(0)
      end
    end

    context 'when the line has too few fields' do
      it 'should skip the line without crashing' do
        option = CronvRb::Option.new_cronv_option(now)
        visualizer = CronvRb::Visualizer.new_visualizer(option)
        result = visualizer.add('invalid line')
        expect(result).to eq([false, nil])
        expect(visualizer.records.size).to eq(0)
      end
    end
  end
end
