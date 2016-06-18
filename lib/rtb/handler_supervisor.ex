defmodule Rtb.HandlerSupervisor do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def handle_connection(backend_mods, backend_args) do
    Supervisor.start_child(__MODULE__, [backend_mods, backend_args, self])
  end

  def init([]) do
    children = [
      worker(Rtb.Handler, [], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
