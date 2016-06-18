defmodule Rtb do
  @moduledoc """
  A quick module to help with your Real-Time Bidding needs.

  Usage is easy:

      iex> Rtb.start_bidding([RichBidder, CheapBidder], %{user_id: "some user identifier", other_data: "hello"})
      {:ok, 999, "rich-bidder-ad-identifier-1"}

      iex> Rtb.start_bidding([CheapBidder, TimeoutBidder], %{user_id: "anybody"})
      {:ok, 0.0001, "cheap-bidder-ad-identifier-1"}

      iex> Rtb.start_bidding([TimeoutBidder], %{user_id: "blah blah"})
      {:error, :unsold}
  """

  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(Rtb.Worker, [arg1, arg2, arg3]),
      supervisor(Rtb.HandlerSupervisor, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Rtb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def start_bidding(backend_mods, backend_args) do
    {:ok, _} = Rtb.HandlerSupervisor.handle_connection(backend_mods, backend_args)
    receive do
      {:finished, {_, :unsold}} ->
        {:error, :unsold}
      {:finished, {amount, id}} ->
        {:ok, amount, id}
      _ = other -> other
    after
      1_000 -> {:error, :timeout}
    end
  end
end
