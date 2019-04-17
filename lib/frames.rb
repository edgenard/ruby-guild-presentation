require_relative './frame_factory'

class Frames
  attr_reader :rolls, :frame_factory, :frame_rules
  MAXIMUM_FRAMES_PER_GAME = 10
  def initialize(frame_factory: FrameFactory, frame_rules:)
    @frames = []
    @rolls = []
    @frame_factory = frame_factory
    @frame_rules = frame_rules
  end

  def roll(pins_dropped)
    rolls << pins_dropped
    @frames = frame_factory.create_frames(
      rolls: rolls,
      frame_rules: frame_rules
    )
  end

  def score
    if @frames.any?(&:scorable?)
      @frames.reduce(0) do |tally, frame|
        tally += frame.score if frame.score
        tally
      end.to_s
    else
      'No score yet'
    end
  end

  def completed?
    @frames.select(&:scorable?).length == MAXIMUM_FRAMES_PER_GAME
  end
end
