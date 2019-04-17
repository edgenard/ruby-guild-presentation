require_relative '../../test_helper'
require_relative '../lib/scorer'

describe SimpleScorer do
  describe '#score' do
    it 'returns the sum of all of the rolls' do
      scorer = SimpleScorer.new

      assert_equal(20, scorer.score([3, 5, 9, 0, 1, 2]))
    end
  end
end

describe LowBallScorer do
  before do
    @scorer = LowBallScorer.new
  end

  describe '#score' do
    describe 'for a strike' do
      it 'returns the right score' do
        assert_equal(12, @scorer.score([0, 1, 1]))
      end
    end

    describe 'for a spare' do
      it 'returns the right score' do
        assert_equal(11, @scorer.score([1, 0, 1]))
      end
    end

    describe 'for an open frame' do
      it 'returns the sum of the rolls' do
        assert_equal(2, @scorer.score([1, 1]))
      end
    end
  end
end
