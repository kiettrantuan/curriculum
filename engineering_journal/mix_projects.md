# Mix Projects

## Mix

Mix is a build tool that ships with Elixir that automates tasks for creating, compiling, and testing your application.

### Structure

- `lib/` folder contains the files for the project (`.ex`).
- `test/` folder contains test files for the project (`.exs`).
- `_build` folder contains compiled files (`.beam` - Erlang executable file).

- `mix.exs` project configure file. Defines 2 public & 1 private functions.
  - `project/0` returns pj name, version, dependencies (from private fn `deps/0`).
  - `application/0` returns config for manifest file.
- `.formatter.exs` code formatter config.

Example:

```yml
lib/
  greeting.ex # HelloWorld.Greeting - lv1 sub module
  hello_world.ex # HelloWorld - main module
  greeting/
    formal.ex # HelloWorld.Greeting.Formal - lv2 sub module
```

### Command

```shell
# Compile and Load project to iex shell
iex -S mix

# Compile
mix compile

# Run test
mix test

# Add & Update dependencies
mix deps.get
mix deps.update example_dep
mix deps.update --all

# Format code
mix format

# Check current environment whether: `:dev` (default), `:test`, `:prod`
# iex> Mix.env()
```

### Dependencies

List of curated dependencies: [Awesome Elixir](https://github.com/h4cc/awesome-elixir).

To install a dependency, include the name of the project and desired version in a tuple inside the `deps/0` function in `mix.exs`. Notice that `mix.exs` includes comments on installing a dependency using the project version or GitHub URL.

```exs
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:faker, "~> 0.17.0"}
    ]
  end
```

## ExUnit

A built-in test framework for Elixir.

```exs
ExUnit.start(auto_run: false)

defmodule ExampleTest do
  use ExUnit.Case

  test "truthy" do
    assert true
  end
end

ExUnit.run()
```

1. Start [ExUnit](https://hexdocs.pm/ex_unit/ExUnit.html) which is handled in `test_helpers.exs`.
2. Define a test module, generally named in format `ModuleNameTest`.
3. Next line, `use ExUnit.Case` for using macros from [ExUnit.Case](https://hexdocs.pm/ex_unit/ExUnit.Case.html) module, such as: [test/3](https://hexdocs.pm/ex_unit/ExUnit.Case.html#test/3), [assert/1](https://hexdocs.pm/ex_unit/ExUnit.Assertions.html#assert/1)...
   1. `test/3` defines a single test. Accepts the name of the test as a string, in this case `"truthy"`.
   2. `assert/1` makes a single assertion inside of the test. The test passes if it receives a truthy value and fails if it receives any falsy value.
   3. `describe/2` group tests.

A test can contain many assertions, and a test module can have many tests.

### Assertions

- [assert/1](https://hexdocs.pm/ex_unit/ExUnit.Assertions.html#assert/1) check if a value is truthy.
- [refute/1](https://hexdocs.pm/ex_unit/1.14.1/ExUnit.Assertions.html#refute/1) check if a value is falsy.
- [assert_raise/2](https://hexdocs.pm/ex_unit/1.14.1/ExUnit.Assertions.html#assert_raise/2) check if the code raises an error.

```exs
defmodule AssertionExampleTest do
  use ExUnit.Case

  test "practical assertions example" do
    # comparison operators
    assert 2 == 2.0
    assert 2.0 === 2.0
    assert 2 >= 2

    # match operator
    assert %{one: _} = %{one: 1, two: 2}
    assert [one: _, two: _] = [one: 1, two: 2]
    assert {_, _, _} = {1, 2, 3}
    assert [1 | _tail] = [1, 2, 3]

    # functions
    assert is_integer(2)
    assert is_map(%{})

    # text-based match operator
    assert "hello world" =~ "hello"
    assert "hello world" =~ ~r/\w+/
  end
end

defmodule OrganizedNumberTest do
  use ExUnit.Case

  describe "double/1" do
    test "1 -> 2" do
      assert OrganizedNumber.double(1) == 2
    end

    test "2 -> 4" do
      assert OrganizedNumber.double(2) == 4
    end
  end

  describe "triple/1" do
    test "1 -> 3" do
      assert OrganizedNumber.triple(1) == 3
    end

    test "2 -> 6" do
      assert OrganizedNumber.triple(2) == 6
    end
  end
end
```

### Test Tags

Use `@moduletag`, `@describetag`, `@tag` module attributes to tag tests. Then, we can configure ExUnit to exclude, include, or only run tests with specific tags using `ExUnit.configure/1`.

```exs
@tag :my_tag
test "example test" do
  assert false
end

# tests with tag `:skip` will be excluded by default
@tag :skip
test "example test" do
  assert false
end
```

Run tests by tag:

- By shell `mix` command.
- By configure in `test_helpers.exs`.

```shell
# run specific tests with flag `--only`, `--exclude`, `--include`
mix test --exclude my_tag
```

```exs
# `test_helpers.exs` configure
ExUnit.start()
ExUnit.configure(exclude: :my_tag)
```
