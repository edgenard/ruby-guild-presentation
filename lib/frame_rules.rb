class FrameRules
  attr_accessor :rolls
  MAX_NUMBER_OF_PINS = 10

  def pending_frame?
    rolls.length < rolls_to_complete_open_frame && !strike_frame?
  end

  def strike_frame?
    strike_value?(rolls.first)
  end

  def spare_frame?
    spare_value?(rolls.first(rolls_to_complete_spare_frame))
  end

  def open_frame?
    !spare_value?(rolls.first(rolls_to_complete_open_frame))
  end

  def scorer
    SimpleScorer.new
  end

  def pins_required_for_strike_or_spare
    MAX_NUMBER_OF_PINS
  end

  def rolls_to_score_strike_frame
    3
  end

  def rolls_to_complete_strike_frame
    1
  end

  def rolls_to_score_spare_frame
    3
  end

  def rolls_to_complete_spare_frame
    2
  end

  def rolls_to_complete_open_frame
    2
  end
end

class TenpinFrameRules < FrameRules
  def strike_value?(roll)
    roll == pins_required_for_strike_or_spare
  end

  def spare_value?(rolls)
    rolls.sum == pins_required_for_strike_or_spare
  end
end

class DuckpinFrameRules < FrameRules
  def rolls_to_complete_open_frame
    3
  end

  def strike_value?(roll)
    roll == pins_required_for_strike_or_spare
  end

  def spare_value?(rolls)
    rolls.sum == pins_required_for_strike_or_spare
  end
end

class NotapFrameRules < FrameRules
  def strike_value?(roll)
    roll >= pins_required_for_strike_or_spare
  end

  def spare_value?(rolls)
    rolls.sum >= pins_required_for_strike_or_spare
  end

  def pins_required_for_strike_or_spare
    9
  end
end

class LowBallFrameRules < FrameRules
  def rolls_to_complete_open_frame
    if rolls.first == MAX_NUMBER_OF_PINS
      1
    else
      2
    end
  end

  def strike_value?(roll)
    roll == pins_required_for_strike_or_spare
  end

  def spare_value?(rolls)
    rolls[1] == pins_required_for_strike_or_spare
  end

  def pins_required_for_strike_or_spare
    0
  end

  def scorer
    LowBallScorer.new
  end
end
