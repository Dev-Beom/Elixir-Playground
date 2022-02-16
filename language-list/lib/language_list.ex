defmodule LanguageList do
  @keyword "Elixir"

  def new(), do: []

  def add(list, language), do: [language | list]

  def remove(list), do: tl(list)

  def first(list), do: hd(list)

  def count(list), do: length(list)

  def exciting_list?(list), do: @keyword in list
end
