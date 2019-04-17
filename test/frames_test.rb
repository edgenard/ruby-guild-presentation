require_relative '../../test_helper'
require_relative '../lib/frame'
require_relative '../lib/frame_rules'
require_relative '../lib/frames'
require_relative '../lib/scorer'

describe Frames do
  describe 'regular scoring' do
    before do
      @frames = Frames.new(frame_rules: TenpinFrameRules.new)
    end
    describe 'no scorable frames' do
      it 'returns no score yet' do
        @frames.roll(5)

        assert_equal('No score yet', @frames.score)
      end
    end

    describe 'one scorable frame' do
      it 'returns the right score' do
        @frames.roll(5)
        @frames.roll(3)

        assert_equal('8', @frames.score)
      end
    end

    describe 'on scorable one unscorable frame' do
      it 'returns score for scorable frame' do
        @frames.roll(5)
        @frames.roll(3)
        @frames.roll(6)

        assert_equal('8', @frames.score)
      end
    end

    describe 'only scorable frames' do
      it 'returns the score for all scorable frames' do
        20.times { @frames.roll(3) }

        assert_equal('60', @frames.score)
      end
    end
  end

  describe 'lowball scoring' do
    before do
      @frames = Frames.new(frame_rules: LowBallFrameRules.new)
    end

    describe 'one scorable frame' do
      it 'returns the right score' do
        @frames.roll(5)
        @frames.roll(0)
        @frames.roll(5)

        assert_equal('15', @frames.score)
      end
    end
  end

  describe 'rolls' do
    it 'keeps track of the rolls' do
      frames = Frames.new(frame_rules: TenpinFrameRules.new)
      frames.roll(5)
      frames.roll(5)
      frames.roll(5)

      assert_equal([5, 5, 5], frames.rolls)
    end
  end

  describe 'creating frames' do
    describe 'when a bonus threshold is provided' do
      it 'creates frames using rolls' do
        frame_factory = Minitest::Mock.new
        frames = Frames.new(
          frame_factory: frame_factory,
          frame_rules: TenpinFrameRules.new
        )
        frame_factory.expect(:create_frames, nil) do |rolls:, frame_rules:|
          rolls == [5] &&
            frame_rules.is_a?(FrameRules)
        end

        frames.roll(5)

        frame_factory.verify
      end
    end
  end
end
