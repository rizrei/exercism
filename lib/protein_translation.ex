defmodule ProteinTranslation do
  @moduledoc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: {:ok, list(String.t())} | {:error, String.t()}
  def of_rna(rna), do: rna |> do_of_rna([])

  defp do_of_rna(<<>>, acc), do: {:ok, Enum.reverse(acc)}

  defp do_of_rna(<<codon::binary-size(3), t::binary>>, acc) do
    case of_codon(codon) do
      {:ok, "STOP"} -> do_of_rna(<<>>, acc)
      {:ok, protein} -> do_of_rna(t, [protein | acc])
      _ -> {:error, "invalid RNA"}
    end
  end

  defp do_of_rna(_, _), do: {:error, "invalid RNA"}

  @moduledoc """
  Given a codon, return the corresponding protein

  UGU -> Cysteine
  UGC -> Cysteine
  UUA -> Leucine
  UUG -> Leucine
  AUG -> Methionine
  UUU -> Phenylalanine
  UUC -> Phenylalanine
  UCU -> Serine
  UCC -> Serine
  UCA -> Serine
  UCG -> Serine
  UGG -> Tryptophan
  UAU -> Tyrosine
  UAC -> Tyrosine
  UAA -> STOP
  UAG -> STOP
  UGA -> STOP
  """

  @codons %{
    "UGU" => "Cysteine",
    "UGC" => "Cysteine",
    "UUA" => "Leucine",
    "UUG" => "Leucine",
    "AUG" => "Methionine",
    "UUU" => "Phenylalanine",
    "UUC" => "Phenylalanine",
    "UCU" => "Serine",
    "UCC" => "Serine",
    "UCA" => "Serine",
    "UCG" => "Serine",
    "UGG" => "Tryptophan",
    "UAU" => "Tyrosine",
    "UAC" => "Tyrosine",
    "UAA" => "STOP",
    "UAG" => "STOP",
    "UGA" => "STOP"
  }

  @spec of_codon(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def of_codon(codon) when is_map_key(@codons, codon), do: {:ok, @codons[codon]}
  def of_codon(_), do: {:error, "invalid codon"}
end
