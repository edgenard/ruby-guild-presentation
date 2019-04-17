class Frame
  attr_reader :rolls, :scorer

  def initialize(rolls, scorer)
    @rolls = rolls
    @scorer = scorer
  end

  def score
    scorer.score(rolls) if scorable?
  end
end

class PendingFrame < Frame
  def scorable?
    false
  end
end

class OpenFrame < Frame
  def scorable?
    true
  end
end

class SpareFrame < Frame
  def scorable?
    @rolls.count == 3
  end
end

class StrikeFrame < Frame
  def scorable?
    @rolls.count == 3
  end
end
