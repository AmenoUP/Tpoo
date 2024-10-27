defmodule TpooWeb.ClockJSON do
  alias Tpoo.Accounts.Clock

  @doc """
  Renders a list of clocks.
  """
  def index(%{clocks: clocks}) do
    %{data: for(clock <- clocks, do: data(clock))}
  end

  @doc """
  Renders a single clock.
  """
  def show(%{clock: clock}) do
    %{data: data(clock)}
  end

  def show_clocks(%{clocks: clocks}) do
    %{
      clocks: Enum.map(clocks, fn clock ->
        %{
          id: clock.id,
          time: clock.time,
          status: clock.status
        }
      end)
    }
  end

  defp data(%Clock{} = clock) do
    %{
      id: clock.id,
      time: clock.time,
      status: clock.status
    }
  end
end