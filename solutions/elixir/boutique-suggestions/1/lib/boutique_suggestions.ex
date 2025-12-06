defmodule BoutiqueSuggestions do
  def get_combinations(tops, bottoms, options \\ []) do
    for %{base_color: top_base_color, price: top_price} = top <- tops,
        %{base_color: bottom_base_color, price: bottom_price} = bottom <- bottoms,
        top_base_color !== bottom_base_color and
          top_price + bottom_price <= options |> Keyword.get(:maximum_price, 100),
        do: {top, bottom}
  end
end
