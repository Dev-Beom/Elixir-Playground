defmodule Duper.Results do
  @moduledoc """
  Results 서버는 엘릭서 맵 자료구조를 서버로 감싼 것
  처음 시작할 때는 빈 맵을 상태로 가짐
  맵의 Key는 파일의 해시, Value는 그 해시를 갖는 하나 이상의 파일 경로의 리스트
  
  Results 서버는 두개의 API를 제공한다.an
  """
  use GenServer

  @me __MODULE__

  # API
  def start_link(_) do
    GenServer.start_link(@me, :no_args, name: @me)
  end

  def add_hash_for(path, hash) do
    GenServer.cast(@me, {:add, path, hash})
  end

  def find_duplicates() do
    GenServer.call(@me, :find_duplicates)
  end

  # Server

  def init(:no_args) do
    {:ok, %{}}
  end

  @doc """
  맵에 해시-경로 쌍을 추가하기 위한 함수
  """
  def handle_cast({:add, path, hash}, results) do
    results = Map.update(results, hash, [path], fn existing -> [path | existing] end)
    {:noreply, results}
  end

  @doc """
  같은 해시에 경로가 여러 개인 항목(중복된 파일)을 조회하기 위한 하무
  """
  def handle_call(:find_duplicates, _from, results) do
    {:reply, hashes_with_more_than_one_path(results), results}
  end

  defp hashes_with_more_than_one_path(results) do
    results
    |> Stream.filter(fn {_hash, paths} -> length(paths) > 1 end)
    |> Enum.map(&elem(&1, 1))
  end
end
