defmodule AffineCipher do
  @typedoc """
  A type for the encryption key
  """
  @type key() :: %{a: integer(), b: integer()}

  @m 26

  @doc """
  Encode an encrypted message using a key
  """

  @spec encode(key(), String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def encode(%{a: a, b: b}, message) do
    if coprime?(a, @m) do
      message
      |> String.downcase()
      |> String.to_charlist()
      |> Enum.filter(&(&1 in ?a..?z or &1 in ?0..?9))
      |> Enum.map(fn
        char when char in ?0..?9 -> char
        char -> Integer.mod(a * (char - ?a) + b, @m) + ?a
      end)
      |> Enum.chunk_every(5)
      |> Enum.map_join(" ", &to_string/1)
      |> then(&{:ok, &1})
    else
      {:error, "a and m must be coprime."}
    end
  end

  @doc """
  Decode an encrypted message using a key
  """
  @spec decode(key(), String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def decode(%{a: a, b: b}, encrypted) do
    if coprime?(a, @m) do
      mmi = Enum.find(1..(@m - 1), &(Integer.mod(a * &1, @m) == 1))

      encrypted
      |> String.to_charlist()
      |> Enum.reject(&(&1 == ?\s))
      |> Enum.map(fn
        char when char in ?0..?9 -> char
        char -> Integer.mod(mmi * (char - ?a - b), @m) + ?a
      end)
      |> to_string()
      |> then(&{:ok, &1})
    else
      {:error, "a and m must be coprime."}
    end
  end

  defp coprime?(v1, v2), do: Integer.gcd(v1, v2) == 1
end
