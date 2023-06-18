defmodule NameBadge do
  @spec print(pos_integer | nil, binary, binary | nil) :: binary
  def print(id, name, department) do
    "#{print_id(id)}#{name} - #{print_department(department)}"
  end

  @spec print_id(binary | nil) :: binary
  defp print_id(id), do: if(id, do: "[#{id}] - ", else: "")
  @spec print_department(binary | nil) :: binary
  defp print_department(department),
    do: if(department, do: String.upcase(department), else: "OWNER")
end
