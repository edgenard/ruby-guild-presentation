class SimpleScorer
  def score(rolls)
    rolls.reduce(:+)
  end
end

class LowBallScorer
  def score(rolls)
    rolls.map { |roll| roll.zero? ? 10 - rolls.first : roll }.reduce(:+)
  end
end
