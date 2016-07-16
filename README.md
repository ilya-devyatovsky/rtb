# Rtb

[![Build Status](https://travis-ci.org/keichan34/rtb.svg?branch=master)](https://travis-ci.org/keichan34/rtb)

A quick module to help with your Real-Time Bidding needs.

## Overview

`Rtb` brokers a bidding session by sending requests in parallel to multiple
backends and chooses the highest bid in a specific timeout (default 50ms).

## Usage

```elixir
iex> Rtb.start_bidding([RichBidder, CheapBidder], %{user_id: "some user identifier", other_data: "hello"})
{:ok, 999, "rich-bidder-ad-identifier-1"}

iex> Rtb.start_bidding([CheapBidder, TimeoutBidder], %{user_id: "anybody"})
{:ok, 0.0001, "cheap-bidder-ad-identifier-1"}

iex> Rtb.start_bidding([TimeoutBidder], %{user_id: "blah blah"})
{:error, :unsold}
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add rtb to your list of dependencies in `mix.exs`:

        def deps do
          [{:rtb, "~> 0.0.1"}]
        end

  2. Ensure rtb is started before your application:

        def application do
          [applications: [:rtb]]
        end
