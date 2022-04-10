defmodule Duper.PathFinder do
  @moduledoc """
  파일 시스템에 있는 모든 파일의 경로를 한 번에 하나씩 반환하는 서버.
  """
  use GenServer

  @me PathFinder

  def start_link(root) do
    GenServer.start_link(__MODULE__, root, name: @me)
  end

  def next_path() do
    GenServer.call(@me, :next_path)
  end

  def init(path) do
    DirWalker.start_link(path)
  end

  @doc """
  파일 시스탬 내 모든 파일의 경로를 하나씩 반환하는 함수
  """
  def hanlde_call(:next_path, _from, dir_walker) do
    path =
      case DirWalker.next(dir_walker) do
        [path] -> path
        other -> other
      end

    {:reply, path, dir_walker}
  end
end
