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
