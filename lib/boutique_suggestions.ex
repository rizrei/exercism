# credo:disable-for-this-file

defmodule BoutiqueSuggestions do
  def get_combinations(tops, bottoms, options \\ []) do
    max_price = options |> Keyword.get(:maximum_price, 100)

    for %{base_color: top_base_color, price: top_price} = top <- tops,
        %{base_color: bottom_base_color, price: bottom_price} = bottom <- bottoms,
        top_base_color !== bottom_base_color and top_price + bottom_price <= max_price,
        do: {top, bottom}
  end
end
