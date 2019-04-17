require_relative '../../test_helper'
require_relative '../lib/bowling'

describe BowlingGame do
  describe '#tally' do
    before do
      @game = BowlingGame.new
    end
    describe 'standard game tally' do
      describe 'complete frame' do
        describe 'open frame' do
          it 'returns right tally' do
            2.times { @game.roll(4) }

            assert_equal('8', @game.tally)
          end
        end
        describe 'spare frame' do
          it 'returns the right tally' do
            3.times { @game.roll(5) }

            assert_equal('15', @game.tally)
          end
        end

        describe 'strike' do
          it 'returns the right tally' do
            @game.roll(10)
            2.times { @game.roll 4 }

            assert_equal('26', @game.tally)
          end
        end
      end

      describe 'incomplete frame' do
        it 'returns no score message' do
          2.times { @game.roll(5) }

          assert_equal('No score yet', @game.tally)
        end
      end

      describe 'complete game' do
        describe 'no spares or strikes' do
          it 'returns the right tally' do
            20.times { @game.roll(4) }
            assert_equal('80', @game.tally)
          end
        end

        describe 'extra rolls' do
          it 'stops updating tally' do
            20.times { @game.roll(4) }
            assert_equal('80', @game.tally)
            @game.roll(4)
            @game.roll(4)
            assert_equal('80', @game.tally)
          end
        end

        describe 'all spare game' do
          it 'returns the right tally' do
            10.times { @game.roll(9); @game.roll(1) }
            @game.roll(9)
            assert_equal('190', @game.tally)
          end
        end

        describe 'perfect game' do
          it 'returns 300' do
            12.times { @game.roll(10) }
            assert_equal('300', @game.tally)
          end
        end
      end
    end

    describe 'notap game tally' do
      before do
        @game = BowlingGame.new(game_variation: NotapFrameRules.new)
      end
      describe 'incomplete frame' do
        it 'returns no score message' do
          @game.roll(5)
          @game.roll(4)

          assert_equal('No score yet', @game.tally)
        end
      end

      describe 'open frame' do
        it 'returns right tally' do
          2.times { @game.roll(4) }

          assert_equal('8', @game.tally)
        end
      end

      describe 'spare frame' do
        it 'returns the right tally' do
          @game.roll(5)
          @game.roll(4)
          @game.roll(3)

          assert_equal('12', @game.tally)
        end
      end

      describe 'strike' do
        it 'returns the right tally' do
          @game.roll(9)
          2.times { @game.roll 4 }

          assert_equal('25', @game.tally)
        end
      end
    end
  end

  describe 'duckpin game tally' do
    before do
      @game = BowlingGame.new(game_variation: DuckpinFrameRules.new)
    end

    describe 'incomplete frame' do
      it 'returns no score message' do
        @game.roll(5)
        @game.roll(4)

        assert_equal('No score yet', @game.tally)
      end
    end

    describe 'open frame' do
      it 'returns right tally' do
        3.times { @game.roll(2) }

        assert_equal('6', @game.tally)
      end
    end

    describe 'spare frame' do
      it 'returns the right tally' do
        @game.roll(5)
        @game.roll(5)
        @game.roll(3)

        assert_equal('13', @game.tally)
      end
    end

    describe 'strike' do
      it 'returns the right tally' do
        @game.roll(10)
        2.times { @game.roll 4 }

        assert_equal('18', @game.tally)
      end
    end
  end

  describe 'lowball game tally' do
    before do
      @game = BowlingGame.new(game_variation: LowBallFrameRules.new)
    end
    describe 'complete game' do
      describe 'no spares or strikes' do
        it 'returns the right tally' do
          20.times { @game.roll(4) }
          assert_equal('80', @game.tally)
        end
      end

      describe 'extra rolls' do
        it 'stops updating tally' do
          20.times { @game.roll(4) }
          assert_equal('80', @game.tally)
          @game.roll(4)
          @game.roll(4)
          assert_equal('80', @game.tally)
        end
      end

      describe 'all spare game' do
        it 'returns the right tally' do
          10.times { @game.roll(1); @game.roll(0) }
          @game.roll(3)
          assert_equal('112', @game.tally)
        end
      end

      describe 'perfect game' do
        it 'returns a tally of 20' do
          20.times { @game.roll(1) }
          assert_equal('20', @game.tally)
        end
      end

      describe 'all strike game' do
        it 'returns a tally of 300' do
          12.times { @game.roll(0) }
          assert_equal('300', @game.tally)
        end
      end
    end
  end
end
