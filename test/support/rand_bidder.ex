defmodule RandBidder do
  use GenServer
  @behaviour Rtb.Backend

  # I don't care who the ad is for, I'm just going to bid random amounts in
  # random amounts of latency.
  def start(_args, pid) do
    GenServer.start(__MODULE__, pid, [])
  end

  def init(pid) do
    rand_state = :rand.seed_s(:exsplus)
    {latency, rand_state} = :rand.uniform_s(20, rand_state)
    :erlang.send_after(10 + (latency - 10), self, :initialize)
    {:ok, {pid, rand_state}}
  end

  def handle_info(:initialize, {pid, rand_state}) do
    {bid_amt, rand_state} = :rand.uniform_s(20, rand_state)
    Rtb.Handler.bid(pid, bid_amt, "rand-bidder-ad-identifier-#{bid_amt}")
    {:noreply, {pid, rand_state}}
  end
end
