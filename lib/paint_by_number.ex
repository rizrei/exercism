defmodule PaintByNumber do
  @spec palette_bit_size(pos_integer) :: non_neg_integer
  def palette_bit_size(color_count), do: color_count |> :math.log2() |> ceil()

  def empty_picture, do: <<>>

  @spec test_picture :: <<_::8>>
  def test_picture, do: <<0::2, 1::2, 2::2, 3::2>>

  @spec prepend_pixel(bitstring, pos_integer, integer) :: bitstring
  def prepend_pixel(picture, color_count, pixel_color_index) do
    <<pixel_color_index::size(palette_bit_size(color_count)), picture::bitstring>>
  end

  @spec get_first_pixel(bitstring, pos_integer) :: nil | binary
  def get_first_pixel(<<>>, _), do: nil

  def get_first_pixel(picture, color_count) do
    name_size = palette_bit_size(color_count)
    <<value::size(name_size), _::bitstring>> = picture
    value
  end

  @spec drop_first_pixel(bitstring, pos_integer) :: bitstring
  def drop_first_pixel(<<>>, _), do: <<>>

  def drop_first_pixel(picture, color_count) do
    name_size = palette_bit_size(color_count)
    <<_::size(name_size), rest::bitstring>> = picture
    <<rest::bitstring>>
  end

  @spec concat_pictures(bitstring, bitstring) :: bitstring
  def concat_pictures(picture1, picture2), do: <<picture1::bitstring, picture2::bitstring>>
end
