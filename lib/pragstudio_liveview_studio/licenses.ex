defmodule PragstudioLiveviewStudio.Licenses do
  @moduledoc """
  Documentation for `PragstudioLiveviewStudio.Licenses`.
  """

  def calculate(seats) do
    if seats <= 5 do
      seats * 20.0
    else
      100 + (seats - 5) * 15.0
    end
  end
end
