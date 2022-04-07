defmodule Duper.Results do
  use GenServer

  @me __MODULE__

  # API
  def start_line(_) do
    GenServer.start_link(@me, :no_args, name: @me)
  end

  def add_hash_for(path, hash) do
    GenServer.cast(@me, {:add, path, hash})
  end

  def find_duplicates do
    GenServer.call(@me, :find_duplicates)
  end

  # 서버
  def init(:no_args) do
    {:ok, %{}}
  end

  def handle_case
end
