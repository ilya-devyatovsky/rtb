defmodule RtbBench do
  use Benchfella

  setup_all do
    Application.ensure_all_started(:rtb)
    {:ok, []}
  end

  bench "worst-case scenario (timeout)" do
    Rtb.start_bidding([TimeoutBidder], %{user_id: "blah blah"})
    :ok
  end

  bench "best-case scenario (zero latency, 1 backend)" do
    Rtb.start_bidding([RichBidder], %{user_id: "blah blah"})
    :ok
  end

  bench "best-case scenario (zero latency, 5 backends)" do
    Rtb.start_bidding([RichBidder, RichBidder, RichBidder, RichBidder, RichBidder], %{user_id: "blah blah"})
    :ok
  end

  bench "real-world conditions (random)" do
    Rtb.start_bidding([RandBidder, RandBidder, RandBidder, RandBidder, RandBidder], %{user_id: "blah blah"})
    :ok
  end
end
