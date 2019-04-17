require_relative '../../test_helper'
require_relative '../lib/frame_factory'
require_relative '../lib/frame_rules'
require_relative '../lib/frame'
require_relative '../lib/scorer'

describe FrameFactory do
  describe 'Tenpin variation' do
    before do
      @frame_rules = TenpinFrameRules.new
    end
    describe 'mixed rolls' do
      it 'returns the right kind of Frame' do
        frames = FrameFactory.create_frames(
          rolls: [3, 4, 5, 5, 10, 2],
          frame_rules: @frame_rules
        )
        assert_instance_of(OpenFrame, frames[0])
        assert_instance_of(SpareFrame, frames[1])
        assert_instance_of(StrikeFrame, frames[2])
        assert_instance_of(PendingFrame, frames[3])
      end

      it 'provides a scorer to each frame' do
        frames = FrameFactory.create_frames(
          rolls: [3, 4, 5, 5, 10, 2],
          frame_rules: @frame_rules
        )

        assert_instance_of(SimpleScorer, frames[0].scorer)
        assert_instance_of(SimpleScorer, frames[1].scorer)
        assert_instance_of(SimpleScorer, frames[2].scorer)
        assert_instance_of(SimpleScorer, frames[3].scorer)
      end

      it 'gives each frame the right rolls' do
        frames = FrameFactory.create_frames(rolls: [3, 4, 5, 5, 10, 2, 2, 1], frame_rules: @frame_rules)
        assert_equal([3, 4], frames[0].rolls)
        assert_equal([5, 5, 10], frames[1].rolls)
        assert_equal([10, 2, 2], frames[2].rolls)
        assert_equal([2, 2], frames[3].rolls)
        assert_equal([1], frames[4].rolls)
      end
    end

    describe 'all spare rolls' do
      it 'returns all spare frames' do
        frames = FrameFactory.create_frames(rolls: [3, 7, 5, 5, 1, 9], frame_rules: @frame_rules)
        assert_instance_of(SpareFrame, frames[0])
        assert_instance_of(SpareFrame, frames[1])
        assert_instance_of(SpareFrame, frames[2])
      end
    end
  end

  describe 'notap variation' do
    before do
      @frame_rules = NotapFrameRules.new
    end
    describe '#create_frames' do
      it 'creates spare frames with rolls add to 9' do
        frames = FrameFactory.create_frames(rolls: [8, 1], frame_rules: @frame_rules)

        assert_instance_of(SpareFrame, frames[0])
      end

      it 'creates spare frame when rolls add to 10' do
        frames = FrameFactory.create_frames(rolls: [8, 2], frame_rules: @frame_rules)

        assert_instance_of(SpareFrame, frames[0])
      end

      it 'creates strike frame when first roll is 9' do
        frames = FrameFactory.create_frames(rolls: [9], frame_rules: @frame_rules)

        assert_instance_of(StrikeFrame, frames[0])
      end

      it 'creates a strike frame when first roll is 10' do
        frames = FrameFactory.create_frames(rolls: [10], frame_rules: @frame_rules)

        assert_instance_of(StrikeFrame, frames[0])
      end
    end
  end

  describe 'duckpin variation' do
    before do
      @frame_rules = DuckpinFrameRules.new
    end
    describe 'strike and pending frame' do
      it 'returns the right frames' do
        frames = FrameFactory.create_frames(rolls: [10, 4, 4], frame_rules: @frame_rules)

        assert_instance_of(StrikeFrame, frames[0])
        assert_equal([10, 4, 4], frames[0].rolls)
        assert_instance_of(PendingFrame, frames[1])
        assert_equal([4, 4], frames[1].rolls)
      end
    end
  end

  describe 'lowball variation' do
    before do
      @frame_rules = LowBallFrameRules.new
    end

    it 'creates multiple strikes for multiple rolls of 0' do
      frames = FrameFactory.create_frames(
        rolls: [0, 0],
        frame_rules: @frame_rules
      )

      assert_instance_of(StrikeFrame, frames[0])
      assert_instance_of(StrikeFrame, frames[1])
    end

    it 'creates the appropriate frame instance' do
      frames = FrameFactory.create_frames(
        rolls: [0, 1, 0, 2, 3, 10, 8],
        frame_rules: @frame_rules
      )

      assert_instance_of(StrikeFrame, frames[0])
      assert_equal([0, 1, 0], frames[0].rolls)
      assert_instance_of(SpareFrame, frames[1])
      assert_equal([1, 0, 2], frames[1].rolls)
      assert_instance_of(OpenFrame, frames[2])
      assert_equal([2, 3], frames[2].rolls)
      assert_instance_of(OpenFrame, frames[3])
      assert_equal([10], frames[3].rolls)
      assert_instance_of(PendingFrame, frames[4])
      assert_equal([8], frames[4].rolls)
    end

    it 'provides a scorer to each frame it creates' do
      frames = FrameFactory.create_frames(
        rolls: [0, 1, 5, 4, 0, 7],
        frame_rules: @frame_rules
      )

      assert_instance_of(LowBallScorer, frames[0].scorer)
      assert_instance_of(LowBallScorer, frames[1].scorer)
      assert_instance_of(LowBallScorer, frames[2].scorer)
      assert_instance_of(LowBallScorer, frames[3].scorer)
    end
  end
end
