defmodule NucleotideCount do
  @moduledoc """
  NucleotideCount
  """

  @type adenine() :: ?A
  @type cytosine() :: ?C
  @type guanine() :: ?G
  @type thymine() :: ?T
  @type nucleotide() :: adenine() | cytosine() | guanine() | thymine()
  @type dna() :: [nucleotide()]
  @type histogram() :: %{
          adenine() => non_neg_integer(),
          cytosine() => non_neg_integer(),
          guanine() => non_neg_integer(),
          thymine() => non_neg_integer()
        }

  @nucleotides [?A, ?C, ?G, ?T]

  @doc """
  Counts individual nucleotides in a DNA strand.

  ## Examples

  iex> NucleotideCount.count('AATAA', ?A)
  4

  iex> NucleotideCount.count('AATAA', ?T)
  1
  """
  @spec count([nucleotide()], nucleotide()) :: non_neg_integer()
  def count(strand, nucleotide), do: Enum.count(strand, &(&1 == nucleotide))

  @doc """
  Returns a summary of counts by nucleotide.

  ## Examples

  iex> NucleotideCount.histogram('AATAA')
  %{?A => 4, ?T => 1, ?C => 0, ?G => 0}
  """
  @spec histogram([nucleotide()]) :: histogram()
  def histogram(strand), do: Map.new(@nucleotides, &{&1, count(strand, &1)})
end
