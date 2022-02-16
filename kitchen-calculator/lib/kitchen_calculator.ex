defmodule KitchenCalculator do
  @ratios %{
    milliliter: 1,
    cup: 240,
    fluid_ounce: 30,
    teaspoon: 5,
    tablespoon: 15
  }

  def get_volume(volume_pair) do
    {_, value} = volume_pair
    value
  end

  def to_milliliter(volume_pair) do
    {type, value} = volume_pair

    case type do
      :cup -> {:milliliter, value * 240}
      :fluid_ounce -> {:milliliter, value * 30}
      :teaspoon -> {:milliliter, value * 5}
      :tablespoon -> {:milliliter, value * 15}
      _ -> volume_pair
    end
  end

  def from_milliliter(volume_pair, unit) do
    value = get_volume(volume_pair)

    case unit do
      :cup -> {unit, value / 240}
      :fluid_ounce -> {unit, value / 30}
      :teaspoon -> {unit, value / 5}
      :tablespoon -> {unit, value / 15}
      _ -> {unit, value}
    end
  end

  def convert(volume_pair, unit) do
    to_milliliter(volume_pair)
    |> from_milliliter(unit)
  end
end
