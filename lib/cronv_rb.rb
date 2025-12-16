# frozen_string_literal: true

Dir[File.join(__dir__, 'cronv_rb', '*.rb')].each do |file|
  require "cronv_rb/#{File.basename(file, '.rb')}"
end

ENV['TZ'] = 'UTC'

module CronvRb
  class Error < StandardError; end
  # Your code goes here...
end
