defmodule Ledger do
  @doc """
  Format the given entries given a currency and locale
  """
  @type currency :: :usd | :eur
  @type locale :: :en_US | :nl_NL
  @type entry :: %{amount_in_cents: integer(), date: Date.t(), description: String.t()}

  @separators %{
    en_US: %{thousands: ",", decimal: "."},
    nl_NL: %{thousands: ".", decimal: ","}
  }

  @headers %{
    en_US: "Date       | Description               | Change       \n",
    nl_NL: "Datum      | Omschrijving              | Verandering  \n"
  }

  @currency_symbols %{
    eur: "€",
    usd: "$"
  }

  @spec format_entries(currency(), locale(), [entry()]) :: String.t()
  def format_entries(_, locale, []), do: @headers[locale]

  def format_entries(currency, locale, entries) do
    entries =
      entries
      |> Enum.sort_by(&{&1.date, &1.description, &1.amount_in_cents})
      |> Enum.map_join("\n", fn entry -> format_entry(currency, locale, entry) end)

    @headers[locale] <> entries <> "\n"
  end

  defp format_entry(currency, locale, entry) do
    date = format_date(entry.date, locale)
    description = format_description(entry.description)
    amount = format_amount(currency, locale, entry.amount_in_cents)

    date <> "|" <> description <> " |" <> amount
  end

  defp format_description(description) do
    if String.length(description) > 26 do
      " " <> String.slice(description, 0, 22) <> "..."
    else
      " " <> String.pad_trailing(description, 25, " ")
    end
  end

  defp format_amount(currency, locale, amount_in_cents) do
    currency_symbol = @currency_symbols[currency]
    number = format_number(amount_in_cents, locale)

    formatted =
      case {amount_in_cents >= 0, locale} do
        {true, :en_US} -> "  #{currency_symbol}#{number} "
        {true, _} -> " #{currency_symbol} #{number} "
        {false, :en_US} -> " (#{currency_symbol}#{number})"
        {false, _} -> " #{currency_symbol} -#{number} "
      end

    String.pad_leading(formatted, 14, " ")
  end

  defp format_date(date, :en_US), do: Calendar.strftime(date, "%m/%d/%Y ")
  defp format_date(date, _), do: Calendar.strftime(date, "%d-%m-%Y ")

  defp format_number(amount, locale) do
    %{thousands: thousands, decimal: decimal} = @separators[locale]
    abs_amount = abs(amount)

    whole_dollars = div(abs_amount, 100)
    decimal_part = abs_amount |> rem(100) |> to_string() |> String.pad_leading(2, "0")
    whole_part = format_whole_part(whole_dollars, thousands)

    whole_part <> decimal <> decimal_part
  end

  defp format_whole_part(whole_dollars, _thousands) when whole_dollars < 1000 do
    to_string(whole_dollars)
  end

  defp format_whole_part(whole_dollars, thousands) do
    thousands_part = div(whole_dollars, 1000)
    remainder = rem(whole_dollars, 1000)
    to_string(thousands_part) <> thousands <> String.pad_leading(to_string(remainder), 3, "0")
  end
end
