defmodule Tpoo.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Tpoo.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        username: "some username"
      })
      |> Tpoo.Accounts.create_user()

    user
  end

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~U[2024-10-07 10:36:00Z]
      })
      |> Tpoo.Accounts.create_clock()

    clock
  end

  @doc """
  Generate a workingtime.
  """
  def workingtime_fixture(attrs \\ %{}) do
    {:ok, workingtime} =
      attrs
      |> Enum.into(%{
        end: ~U[2024-10-07 10:39:00Z],
        start: ~U[2024-10-07 10:39:00Z]
      })
      |> Tpoo.Accounts.create_workingtime()

    workingtime
  end
end
