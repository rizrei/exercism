defmodule Atbash do
  @doc """
  Encode a given plaintext to the corresponding ciphertext

  ## Examples

  iex> Atbash.encode("completely insecure")
  "xlnko vgvob rmhvx fiv"
  """

  @cipher Map.new(Enum.zip(?a..?z, ?z..?a))

  @spec encode(String.t()) :: String.t()
  def encode(plaintext) do
    plaintext
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9]/, "")
    |> String.replace(~r/./, &apply_cipher/1)
    |> String.replace(~r/.{5}/, &"#{&1} ")
    |> String.trim_trailing()
  end

  defp apply_cipher(<<char>>) do
    <<Map.get(@cipher, char, char)>>
  end

  @spec decode(String.t()) :: String.t()
  def decode(cipher) do
    cipher
    |> String.replace(" ", "")
    |> String.replace(~r/./, &apply_cipher/1)
  end
end
