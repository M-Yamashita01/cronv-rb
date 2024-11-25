require 'spec_helper'

RSpec.describe CronvRb::Option do
  describe '#to_from_time' do
    let(:now) { Time.new(2024, 11, 25, 13, 30, 0, '+09:00') } # => 2008-06-21 13:30:00 +0900

    it 'should return formatted from date and time' do
      option = CronvRb::Option.new_cronv_option(now)
      expect(option.to_from_time).to eq('2024/11/25 04:30')
    end
  end
end
