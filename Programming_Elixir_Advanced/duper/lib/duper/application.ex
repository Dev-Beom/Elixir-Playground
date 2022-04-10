defmodule Duper.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Duper.Results,
      # 탐색할 디렉터리 트리의 최상위 경로를 파라미터로 전달해야 하기 때문에 "."
      {Duper.PathFinder, "."}
      Duper.WorkerSupervisor,
      {Duper.Gatherer, 1},
    ]

    opts = [strategy: :one_for_all, name: Duper.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
