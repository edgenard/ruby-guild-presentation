class FrameFactory
  def self.create_frames(rolls:, frame_rules:)
    return [] if rolls.empty?

    frame_rules.rolls = rolls
    if frame_rules.pending_frame?
      [PendingFrame.new(rolls, frame_rules.scorer)]
    elsif frame_rules.strike_frame?
      [
        StrikeFrame.new(
          rolls.take(frame_rules.rolls_to_score_strike_frame),
          frame_rules.scorer
        )
      ] +
        create_frames(
          rolls: rolls.drop(frame_rules.rolls_to_complete_strike_frame),
          frame_rules: frame_rules
        )
    elsif frame_rules.spare_frame?
      [
        SpareFrame.new(
          rolls.take(frame_rules.rolls_to_score_spare_frame),
          frame_rules.scorer
        )
      ] +
        create_frames(
          rolls: rolls.drop(frame_rules.rolls_to_complete_spare_frame),
          frame_rules: frame_rules
        )
    elsif frame_rules.open_frame?
      [
        OpenFrame.new(
          rolls.take(frame_rules.rolls_to_complete_open_frame),
          frame_rules.scorer
        )
      ] +
        create_frames(
          rolls: rolls.drop(frame_rules.rolls_to_complete_open_frame),
          frame_rules: frame_rules
        )
    end
  end
end
