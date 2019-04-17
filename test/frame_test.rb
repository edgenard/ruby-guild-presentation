require_relative '../../test_helper'
require_relative '../lib/frame'

class FakeScorer; end

describe PendingFrame do
  describe 'scorable' do
    it 'never scorable' do
      frame = PendingFrame.new([1], FakeScorer)
      assert_equal(false, frame.scorable?)
    end
  end
end

describe OpenFrame do
  describe 'scorable' do
    it 'is scorable' do
      frame = OpenFrame.new([2, 4], FakeScorer)
      assert_equal(true, frame.scorable?)
    end
  end
end

describe SpareFrame do
  describe 'without bonus roll' do
    describe 'scorable' do
      it 'is not scorable' do
        frame = SpareFrame.new([6, 4], FakeScorer)
        assert_equal(false, frame.scorable?)
      end
    end
  end

  describe 'with bonus roll' do
    describe 'scorable' do
      it 'is scorable' do
        frame = SpareFrame.new([6, 4, 5], FakeScorer)
        assert_equal(true, frame.scorable?)
      end
    end
  end
end

describe StrikeFrame do
  describe 'without bonus rolls' do
    describe 'scorable' do
      it 'is not scorable' do
        frame = StrikeFrame.new([10, 4], FakeScorer)
        assert_equal(false, frame.scorable?)
      end
    end
  end

  describe 'with 2 bonus rolls' do
    describe 'scorable' do
      it 'is not scorable' do
        frame = StrikeFrame.new([10, 4, 3], FakeScorer)
        assert_equal(true, frame.scorable?)
      end
    end
  end
end
