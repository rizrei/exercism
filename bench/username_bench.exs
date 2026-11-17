test_fun = fn m, f, args -> Enum.each(1..10_000, fn _ -> apply(m, f, args) end) end
# test_fun = fn m, f, args -> apply(m, f, args) end

tests = %{
    "Username.V1" => fn input -> test_fun.(Username, :sanitize, input) end,
    "Username.V2" => fn input -> test_fun.(Username.V2, :sanitize, input) end,
    "Username.V3" => fn input -> test_fun.(Username.V3, :sanitize, input) end,
    "Username.V4" => fn input -> test_fun.(Username.V4, :sanitize, input) end,
    "Username.V5" => fn input -> test_fun.(Username.V5, :sanitize, input) end,
}

inputs = %{
  "case1" => [~c"köhler_jäger42"],
  "case2" => [~c"köhler_jägenqjrkgkrgwbnvkänvbhowbärvbwpbrpvähwbvлоиаäципцмцложиr42"]
}

Benchee.run(
  tests,
  warmup: 1,
  time: 5,
  memory_time: 2,
  reduction_time: 2,
  formatters: [{Benchee.Formatters.Console, extended_statistics: true}],
  inputs: inputs
)
