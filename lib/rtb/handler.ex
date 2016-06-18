defmodule Rtb.Handler do
  use GenServer

  @default_timeout 50

  def start_link(backends, args, caller) do
    GenServer.start_link(__MODULE__, [backends, args, caller], [])
  end

  def bid(pid, amount, id) do
    Process.alive?(pid) && GenServer.call(pid, {:bid, amount, id}) || :error
  end

  def init([backends, args, caller]) do
    timeout = Map.get(args, :timeout, @default_timeout)
    :erlang.send_after(timeout, self, :timeout)

    backend_pids = for backend <- backends do
      case backend.start(args, self) do
        {:ok, pid} ->
          pid
        :error ->
          nil
      end
    end
    |> Enum.reject(&is_nil/1)

    state = %{
      caller: caller,
      backend_pids: backend_pids,
      backend_count: length(backend_pids),
      bids: []
    }

    {:ok, state}
  end

  def handle_info(:timeout, %{caller: caller} = state) do
    for pid <- state.backend_pids do
      Process.exit(pid, :timeout)
    end

    winning_bid = Enum.reduce(state.bids, {:neg_inf, :unsold}, fn
      (bid, {:neg_inf, _}) -> bid
      ({amount, _} = bid, {highest_amount, _}) when amount > highest_amount ->
        bid
      ({amount, _}, {highest_amount, _} = bid) when amount <= highest_amount ->
        bid
    end)

    send(caller, {:finished, winning_bid})
    {:stop, :shutdown, state}
  end

  def handle_call({:bid, amount, id}, _, state) do
    state = update_in(state.bids, &[{amount, id} | &1])
    if state.backend_count <= length(state.bids) do
      send(self, :timeout)
    end
    {:reply, :ok, state}
  end
end
