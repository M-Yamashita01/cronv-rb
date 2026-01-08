# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CronvRb::Template do
  describe '.render' do
    let(:now) { Time.new(2024, 11, 25, 13, 30, 0, '+00:00') }
    let(:option) { CronvRb::Option.new_cronv_option(now) }
    let(:visualizer) { CronvRb::Visualizer.new_visualizer(option) }

    subject { described_class.render(visualizer:) }

    context 'when no tasks added' do
      it 'renders basic html structure' do
        expect(subject).to include('<html>')
        expect(subject).to include(option.title) # "Cron Tasks"
        expect(subject).to include('Loading...') # 初期状態のプレースホルダー
      end
    end

    context 'when tasks added' do
      before do
        visualizer.add('0 10 * * * backup_job')
      end

      it 'renders task data in javascript' do
        # 生成されたJS内にジョブ名が含まれているか
        expect(subject).to include("tasks['backup_job']")
        expect(subject).to include('backup_job')
      end
    end
  end
end
