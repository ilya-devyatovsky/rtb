defmodule Rtb.Backend do
  @moduledoc """
  The behaviour a Backend should adhere to.

  The pid that start/2 receives is the pid of the Handler. When the Backend
  is ready to submit a bid, it will call Rtb.Handler.bid/3 using this pid.
  """

  @type args :: %{}
  @callback start(args, pid) :: {:ok, pid} | :error
end
