# frozen_string_literal: true

require 'logger'

class Logger
  class << self
    def info(message)
      info_logger.info(message)
    end

    def error(message)
      error_logger.error(message)
    end

    private

    def info_logger
      @info_logger ||= Logger.new($stdout)
    end

    def error_logger
      @error_logger ||= Logger.new($stderr)
    end
  end
end
