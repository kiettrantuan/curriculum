# A React Developer's Journal on Learning Elixir

Elixir is a functional programming language.

## Course Tools

### Github Collab

OSS stands for Open Source Software.

A OSS Contributor can contribute in many forms, such as writing code, fixing bugs, improving documentation, or even participating in discussions.

## Basics

### Strings

- Concatenation: `<>`
- Multi lines:

```exs
string = """
line 1
line 2
"""
```

- Interpolation: `#{value}`
- Escaping: `\`

### Comparison Operators

```exs
# return false as type difference: float vs integer
1.0 === 1
```

You can compare different data types to each other in the following [Sorting Order](https://hexdocs.pm/elixir/1.12.3/operators.html#term-ordering).

```txt
number < atom < reference < function < port < pid < tuple < map < list < bitstring 
```

## Data Structures And Intro To Pattern Matching

### Atoms

Named constants. Their name is their value

Defined using a colon `:` and a series of letters, digits, and certain valid symbols.

```exs
:success
:error

# special atoms (:nil === nil)
nil
false
true
```

Atoms are stored in an atom table and can be referenced by a key. This makes it way faster (than string comparison) to check if two atoms are equal.

Convention: lowercase separated by underscores.

### Tuples

Fixed size containers for multiple elements. Can contain any data type.

Defined using curly brackets `{}`.

```exs
{}
{0, "string", :atoms}
{:success, "Well done!"}
{:error, "**Too** bad!"}
```

### Lists

Defined using square brackets `[]`.

```exs
[0, "string", :atoms]
```

Actually Linked Lists where every element is a Cons Cells with Head and Tail: `[head | tail]`

```exs
[2, 3] 
# is syntax sugar for
[2 | [3 | []]]
```

Lists can be added or subtracted using `++` and `--`. This operation occurs from `right to left`. Should use brackets avoid unintuitive code.

```exs
[0] ++ [1]
# => [0, 1]
[0, 1, 2, 3, 2, 1, 0] ++ [0, 2, 3]
# remove the leftmost elements first
# => [1, 2, 1, 0]
[0, 1, 2] -- [0, 1] -- [2]
# right to left:
# [0, 1] -- [2] == [0, 1]
# [0, 1, 2] -- [0, 1] => [2]
([0, 1, 2] -- [0, 1]) -- [2]
# => []
```

#### Keyword Lists

Keyword List is ordered vs. Map unordered.

Keys DO NOT have to be unique

Performant for small amounts of data, but not for large amounts of data compare to maps.

```exs
[artist1: "song 1", artist2: "song 2", artist3: "song 3", artist4: "song 4", artist5: "song 5"]
```

Actually a list of tuples with each first elements is atom.

```exs
[key: "value"] === [{:key, "value"}]
```

Keyword list syntax must come at the end of a list, or it'll cause a SyntaxError.

Access values using their atom key with square bracket.

```exs
keyword_list = [key: "value"]
keyword_list[:key] === "value"
```

### Maps

Defined using `%{}`. A key-value pair in map separated by an arrow `=>`.

Key must be unique (different from keyword list) and it can be any elixir term.

```exs
%{:key => "value"}

%{"key" => "value"}

%{1 => "value"}

%{[1, 2, 3] => "value"}
```

Atom keys only Map can be write like keyword list.

```exs
%{key1: "value", key2: "value"}
```

Access values using their key with square bracket (or dot - only valid for atom keys).

```exs
# Will break if key does not exist in map
%{key1: %{key2: %{key3: "value"}}}.key1.key2.key3 === "value"
# Will NOT break even key does not exist in map
%{1 => %{2 => %{3 => "value"}}}[1][2][3] === "value"
%{1 => %{2 => %{3 => "value"}}}[1][2][4] === nil
```

Can update Existing keys values using syntax `%{initial_map | updated_values}`.

## Pattern Matching

`=` sign is the `match operator` because it uses pattern matching to bind variables.

Ignored variables are led by an underscore `_`

#### Tuple

```exs
{1, 2, 3} = {1, 2, 3}
my_tuple = {1, 2, 3}
{one, _two, three} = {1, 2, 3}
```

#### List

```exs
[first] = [1]
[first] = [1, 2, 3]
# raise error
[head | tail] = [1, 2, 3]
# head = 1, tail = [2, 3]
[first, second | rest] = [1, 2, 3, 4, 5,6]
# fist = 1, second = 2, rest = [3, 4, 5, 6]
```

#### Keyword List

```exs
[hello: my_variable] = [hello: "world"]
my_variable === "world"

[{k, v}] = [key: "value"]
k === :key
v === "value"
```

#### Map

Unlike List, Map don't have to match on every key-value pair and can NOT be pattern match the key.

```exs
%{one: one} = %{one: 1, two: 2}
one === 1
%{hello => world} = %{"hello" => "world"}
# Raise error as key must be literals
```

#### Range

```exs
start..finish//step = 1..10//2

start === 1
finish === 10
step === 2
```

## Control Flow And Abstraction

### Functions

```exs
# Create
# Multiline fn return last line

fn_wo_input = fn -> 3 + 3 end

fn_w_input = fn fn_input -> 
    first = fn_input + 3
    first + 3
end

fn_short_syntax = &(&1 * (&2 + 3))

# Execute

fn_wo_input.() === 6

fn_w_input.(3) === 9

fn_short_syntax.(3, 1) === 12

# Callback fn

call_with_2 = fn callback -> callback.(2) end

call_with_2.(fn int -> int + 3 end) === 5
```

Arity of the function is the number of parameters function accepts.

Elixir's functions display as `function_name/arity` thus a function named add_two with two parameters is called add_two/2.

#### Pipe Operator

`|>` for chaining functions. Pipe operator allows you to take the output of one function and pass it in as an argument for the input of another function.

```exs
# Instead of
four.(three.(two.(one.(1), 2)))
# or
a = one.(1)
b = two.(a, 2)
c = three.(b)
d = four.(c)
# Use Pipe operator

one.(1) |> two.(2) |> three.() |> four.()

1 |> one.() |> two.(2) |> three.() |> four.()
```

### Control Flow

Common statements: `if` , `cond` , `case`

#### If (2 paths)

```exs
weather == :hot

if weather == :cold do
  "coat"
else
  "t-shirt"
end

# Not recommend
weather = :sunny

recommendation = "t-shirt"
recommendation = if weather == :snowing, do: "thick coat", else: recommendation
recommendation = if weather == :raining, do: "raincoat", else: recommendation
recommendation = if weather == :foggy, do: "something bright", else: recommendation

recommendation === "t-shirt"
```

We can use `unless` which is `if` reverse.

```exs
eat = true

unless eat do
  "Hungry"
else
  "Not hungry"
end === "Not hungry"
```

#### Case (Pattern matching)

```exs
weather = :sunny

case weather do
  :sunny -> "t-shirt"
  :snowing -> "thick coat"
  :raining -> "raincoat"
  :foggy -> "something bright"
  _ -> "default"
end
```

Case does pattern matching left and right of `->` until match; No cases match will raise Error.

```exs
case {:exactly, :equal} do
  {:not_exactly, :equal} -> "non-matching case"
  {:exactly, :equal} -> "matching case"
end === "matching case"

# Use variable to match anything (skip pattern matching for that value | common use as default case)

case {:exactly, :equal} do
  {_mostly, :equal} -> "matching case"
  {:exactly, :equal} -> "exactly equal case"
end === "matching case"
```

#### Cond (Condition)

Return right value of first accepted truthy on the left of `->`. Will raise Error if no condition met.

```exs
temperature = 6

cond do
  temperature == 21 -> "t-shirt"
  temperature >= 16 and temperature <= 20 -> "heavy shirt"
  temperature >= 11 and temperature <= 15 -> "light coat"
  temperature >= 6 and temperature <= 10 -> "coat"
  temperature == 6 -> "coat2"
  temperature <= 5 -> "thick coat"
  # Use true for default
  true -> default
end ===  "coat"
```

## Modules And Structs

### Modules

Can be refer as a "bag of functions".

Define a Module using `defmodule`. Define a Function inside Module using `def` or `defp` for private function.

```exs
# define module

defmodule ModuleName do
  def function_name do
    "return value"
  end
end

defmodule ModuleName2 do
  def function_name(input \\ "default input value") do
    input
  end
  
  defp private_fn(input) do
    input
  end
end

# call function

ModuleName.function_name() === "return value"

ModuleName2.function_name() === "default input value"
ModuleName2.function_name(2) === 2

# Following call raise error as private_fn is undefined outside it's module
# ModuleName2.private_fn(2)
```

Callback function passed to Module's function must be:

- Explicitly provided the `functions arity` using the capture operator `&`.
- OR wrap in an anonymous function.

```exs
defmodule HigherOrder do
  def higher_order_function(callback) do
    callback.()
  end
end

defmodule Callback do
  def callback_function do
    "I was called!"
  end
end

# Arity + Capture operator (&)
HigherOrder.higher_order_function(&Callback.callback_function/0)

# Wrap in anonymous function
HigherOrder.higher_order_function(fn -> Callback.callback_function() end)
```

#### SubModules

Defined by separate module names with a period `.` OR nested `defmodule`.

```exs
defmodule Languages.English do
  def greeting do
    "Hello"
  end
end

Languages.English.greeting() === "Hello"

defmodule NestedLanguages do
  defmodule English do
    def greeting do
      "Hello"
    end
  end
end

NestedLanguages.English.greeting() === Languages.English.greeting()
```

#### Attributes

Define a compile-time module attribute using `@`.

```exs
defmodule Hero do
  @name "Spider-Man"
  @nemesis "Green Goblin"

  def introduce do
    "Hello, my name is #{@name}!"
  end

  def catchphrase do
    "I'm your friendly neighborhood #{@name}!"
  end

  def defeat do
    "I #{@name} will defeat you #{@nemesis}!"
  end
end
```

#### Module Scope

Should Read `Module Scope` section in docs, it's pretty important. Below just some short definition.

```exs
top_scope = "top_scope"

defmodule ModuleScope2 do
  # `ModuleScope2` can NOT access `top_scope`
  module_scope_err = top_scope

  # This fine
  module_scope = "module_scope"
  IO.inspect(module_scope)

  def function_scope do
    # `function_scope` can NOT access `module_scope`
    fn_scope_err = module_scope

    # This fine
    function_scope = "function scope"
    IO.inspect(module_scope)
  end
end
```

#### Multiple Function Clauses

```exs
defmodule MultipleFunctionClauses do
  def my_function do
    "arity is 0"
  end

  def my_function(_param1) do
    "arity is 1"
  end

  def my_function(_param1, _param2) do
    "arity is 2"
  end
end

MultipleFunctionClauses.my_function() === "arity is 0"
MultipleFunctionClauses.my_function(1) === "arity is 1"
MultipleFunctionClauses.my_function(2) === "arity is 2"
```

Default input

```exs
defmodule MultipleDefaultArgs do
  def all_defaults(param1 \\ "default argument 1", param2 \\ "default argument 2") do
    binding()
  end

  def some_defaults(param1 \\ "default arg 1", param2) do
    binding()
  end
end

MultipleDefaultArgs.all_defaults() === [param1: "default argument 1", param2: "default argument 2"]

MultipleDefaultArgs.some_defaults("overridden argument") === [param1: "default arg 1", param2: "overridden argument"]
```

We can document modules using `@doc` and `@moduledoc` module attributes with a multiline string `"""`. You can add `iex>` in doc for IEx Shell which will be run automatically in Livebook.

- `@moduledoc` should describe the module at a high level.
- `@doc` should document a single function in the module.

```exs
defmodule DoctestExample do
  @moduledoc """
  DoctestExample

  Explains doctests with examples
  """

  @doc """
  Returns a personalized greeting for one person.

  ## Examples

    iex> DoctestExample.hello()
    "Hello Jon!"

    iex> DoctestExample.hello("Bill")
    "Hello Bill!"
  """
  def hello(name \\ "Jon") do
    "Hello #{name}!"
  end
end
```

### Structs

Defined using `defstruct`.

Struct is simply a short word for structure. They are an extension on top of maps that enforce constraints on your data.

Instances of the struct will not be allowed to contain any data other than these keys.

Actually implemented using maps under the hood.

```exs
defmodule StructName do
  defstruct [:key1, :key2, :key3]
end

%StructName{} === %StructName{key1: nil, key2: nil, key3: nil}

# Pass value to a struct key

%StructName{key1: "value 1"}

# create
defmodule Person do
  defstruct [:name]

  def greet(person) do
    "Hello, #{person.name}."
  end
end

# execute
person = %Person{name: "Peter"}

Person.greet(person) === "Hello, Peter."
```

Structs can have keys with and without default value but Default keys MUST come LAST in the list.

```exs
defmodule DefaultKeys do
  defstruct [:key1, key2: "default2"]
end

%DefaultKeys{} === %DefaultKeys{key1: nil, key2: "default2"}
```

`@enforce_keys` for ensure certain keys are set.

```exs
defmodule EnforcedNamePerson do
  @enforce_keys [:name]
  defstruct @enforce_keys ++ [:age]
end

# MUST set name
%EnforcedNamePerson{name: "abc"}
```

Manipulate

```exs
defmodule MyStruct do
  defstruct [:key]
end

initial = %MyStruct{key: "value"}

updated = %{initial | key: "new value"}

updated === %MyStruct{key: "new value"}
```

## Enumeration

### Ranges

Can be ascending or descending.

```exs
0..10 # from 0 -> 10
5..-5 # from 5 -> 0 -> -5

# Convert to list
Enum.to_list(1..5) === [1,2,3,4,5]

# With step
0..11//2 # [0,2,4,6,8,10]

# Pattern matching

start..finish//step = 1..10//2
```

### Enum

Enumeration is the act of looping through elements.

Common used: `Enum.map/2`, `Enum.filter/2`, and `Enum.reduce/2`.

```exs
Enum.map([1, 2, 3, 4, 5], fn element -> element * 2 end) === Enum.map(1..5, fn element -> element * 2 end)

# `Enum.reduce/2`: 1 Is The Initial Accumulator Value
Enum.reduce(1..3, fn element, accumulator ->
  element + accumulator
end) === 6
# `Enum.reduce/3`: 5 Is The Initial Accumulator Value
Enum.reduce(1..3, 5, fn element, accumulator ->
  element + accumulator
end) === 11
```

Other useful:

- `Enum.all/2` check if all elements in a collection match some condition.
- `Enum.any?/2` check if any elements in a collection match some condition.
- `Enum.count/2` return the number of elements in a collection collection.
- `Enum.find/3` return an element in a collection that matches some condition. Middle variable of /3 is return value instead of nil if no match found.
- `Enum.random/1` return a random element in a collection.

#### Capture Operator And Module Functions

Use `&` and Arity to provide module functions (mean built-in functions too).

```exs
my_function = fn element -> IO.inspect(element) end

Enum.map(1..10, my_function)

defmodule NonAnonymous do
  def function(element) do
    IO.inspect(element)
  end
end

Enum.map(1..10, &NonAnonymous.function/1)

Enum.map(1..10, &is_integer/1)
```
