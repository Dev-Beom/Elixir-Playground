defmodule Lasagna do
  @oven_time 40
  @preparation_time 2
  @alarm_msg "Ding!"

  def expected_minutes_in_oven, do: @oven_time
  def remaining_minutes_in_oven(time), do: expected_minutes_in_oven() - time
  def preparation_time_in_minutes(layer), do: layer * @preparation_time
  def total_time_in_minutes(layer, time), do: preparation_time_in_minutes(layer) + time
  def alarm, do: @alarm_msg
end
