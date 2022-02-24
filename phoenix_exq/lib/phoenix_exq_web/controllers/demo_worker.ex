defmodule Demo.Worker do
  @second 1000

  defp worker_dashboard do
    port = PhoenixExqWeb.Endpoint.url() |> String.split(":") |> List.last()
    IO.puts("#{port} 작업을 시작합니다.")
    :timer.sleep(@second)
    IO.puts("#{port} 작업이 종료되었습니다.")
  end

  @spec perform(any) :: :ok
  def perform(port) do
    IO.puts("#{port} 로부터 작업이 들어왔습니다.")
    worker_dashboard
  end
end
