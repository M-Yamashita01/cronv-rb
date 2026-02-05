# frozen_string_literal: true

require 'optparse'

module CronvRb
  # rubocop:disable Metrics/AbcSize
  def self.main
    option = Option.new_cronv_option(Time.now)

    OptionParser.new do |opt|
      opt.on('-o', '--output PATH', 'path to .html file to output') { |v| option.output_file_path = v }
      opt.on('-d', '--duration DURATION', 'duration to visualize in N{suffix} style. e.g.) 1d(day)/1h(hour)/1m(minute)') { |v| option.duration = v }
      opt.on('--from-date DATE', "start date in the format '#{Option::OPT_DATE_FORMAT}' to visualize") { |v| option.from_date = v }
      opt.on('--from-time TIME', "start time in the format '#{Option::OPT_TIME_FORMAT}' to visualize") { |v| option.from_time = v }
      opt.on('-t', '--title TITLE', 'title/label of output') { |v| option.title = v }
      opt.on('-w', '--width WIDTH', 'Table width of output') { |v| option.width = v.to_i }
    end.parse!

    visualizer = Visualizer.new_visualizer(option)

    $stdin.each_line do |line|
      visualizer.add(line)
    end

    path = visualizer.dump
    puts "[#{option.title}] #{visualizer.records.size} tasks."
    puts "[#{option.title}] '#{path}' generated."
  end
  # rubocop:enable Metrics/AbcSize
end
