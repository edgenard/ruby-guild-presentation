require_relative './frames'
require_relative './frame_rules'
require_relative './frame'
require_relative './scorer'

class BowlingGame
  attr_reader :frames

  def initialize(game_variation: TenpinFrameRules.new)
    @frames = Frames.new(frame_rules: game_variation)
  end

  def roll(pins_dropped)
    frames.roll(pins_dropped) unless frames.completed?
  end

  def tally
    frames.score
  end
end
