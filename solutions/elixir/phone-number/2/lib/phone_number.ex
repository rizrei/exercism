defmodule PhoneNumber do
  @doc """
  Remove formatting from a phone number if the given number is valid. Return an error otherwise.
  """

  @spec clean(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def clean(raw) do
    str =
      raw
      |> String.replace(~w(\( \) - . +), "")
      |> String.replace(~r/\s+/, "")

    with {:ok, str} <- check_digits(str),
         {:ok, str, length} <- check_length(str),
         {:ok, str} <- check_country_code(str, length),
         {:ok, str} <- check_area_code(str) do
      check_exchange_code(str)
    end
  end

  defp check_digits(str) do
    if String.match?(str, ~r/^\d+$/), do: {:ok, str}, else: {:error, "must contain digits only"}
  end

  defp check_length(str) do
    len = String.length(str)

    cond do
      len > 11 -> {:error, "must not be greater than 11 digits"}
      len < 10 -> {:error, "must not be fewer than 10 digits"}
      true -> {:ok, str, len}
    end
  end

  defp check_country_code("1" <> rest, 11), do: {:ok, rest}
  defp check_country_code(_, 11), do: {:error, "11 digits must start with 1"}
  defp check_country_code(str, _), do: {:ok, str}

  defp check_area_code(str), do: check_code(str, 0, "area code")
  defp check_exchange_code(str), do: check_code(str, 3, "exchange code")

  defp check_code(str, idx, error) do
    case String.at(str, idx) do
      "0" -> {:error, "#{error} cannot start with zero"}
      "1" -> {:error, "#{error} cannot start with one"}
      _ -> {:ok, str}
    end
  end
end
