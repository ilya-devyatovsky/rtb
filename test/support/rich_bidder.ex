defmodule RichBidder do
  use GenServer
  @behaviour Rtb.Backend

  # I don't care who the ad is for, I'm just going to bid insane amounts of
  # money for any request I get.
  def start(_args, pid) do
    GenServer.start(__MODULE__, pid, [])
  end

  def init(pid) do
    send(self, :initialize)
    {:ok, pid}
  end

  def handle_info(:initialize, pid) do
    Rtb.Handler.bid(pid, 999, "rich-bidder-ad-identifier-1")
    {:noreply, pid}
  end
end
