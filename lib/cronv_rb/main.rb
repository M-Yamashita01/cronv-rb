# frozen_string_literal: true

module CronvRb
  def self.main
    Option.new_cronv_option(Time.now)
  end
end
