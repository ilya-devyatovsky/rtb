defmodule TimeoutBidder do
  use GenServer
  @behaviour Rtb.Backend

  # I don't care who the ad is for, I'm just going to take my sweet time and
  # maybe respond to the bid in.. I don't know... How does 200ms sound?
  def start(_args, pid) do
    GenServer.start(__MODULE__, pid, [])
  end

  def init(pid) do
    :erlang.send_after(200, self, :initialize)
    {:ok, pid}
  end

  def handle_info(:initialize, pid) do
    Rtb.Handler.bid(pid, 0.1, "timeout-bidder-ad-identifier-1")
    {:noreply, pid}
  end
end
