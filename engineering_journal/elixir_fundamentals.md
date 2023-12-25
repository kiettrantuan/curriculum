# Elixir Fundamentals

Elixir is a functional programming language.

## Course Tools

### Github Collab

OSS stands for Open Source Software.

A OSS Contributor can contribute in many forms, such as writing code, fixing bugs, improving documentation, or even participating in discussions.

## Basics

### Strings

Strings in Elixir are represented internally as **binaries**.

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
- `bag_distance/2` is pretty cool (return a float define the percentage of matching characters between 2 strings ?)

```exs
String.bag_distance("cats", "dogs") === 0.25

String.bag_distance("robed", "bored") === 1.0

String.bag_distance("robed", "bored-robe") === 0.5
```

### Comparison Operators

```exs
# return false as type difference: float vs integer
1.0 === 1
```

You can compare different data types to each other in the following [Sorting Order](https://hexdocs.pm/elixir/1.12.3/operators.html#term-ordering).

```txt
number < atom < reference < function < port < pid < tuple < map < list < bitstring 
```

## Data Structures

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

["b", "a", "b", "c"] -- ["b", "c"]
# -> ["a", "b"] # Very useful function
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

Can update **Existing** keys values using syntax `%{initial_map | updated_values}`.

```exs
initial = %{count: 1}

%{initial | count: 2}
```

## Pattern Matching - Basic

`=` sign is the `match operator` because it uses pattern matching to bind variables.

Ignored variables are led by an underscore `_`

### Tuple

```exs
{1, 2, 3} = {1, 2, 3}
my_tuple = {1, 2, 3}
{one, _two, three} = {1, 2, 3}
```

### List

```exs
[first] = [1]
[first] = [1, 2, 3]
# raise error
[head | tail] = [1, 2, 3]
# head = 1, tail = [2, 3]
[first, second | rest] = [1, 2, 3, 4, 5,6]
# fist = 1, second = 2, rest = [3, 4, 5, 6]
```

### Keyword List

```exs
[hello: my_variable] = [hello: "world"]
my_variable === "world"

[{k, v}] = [key: "value"]
k === :key
v === "value"
```

### Map

Unlike List, Map don't have to match on every key-value pair and can NOT be pattern match the key.

```exs
%{one: one} = %{one: 1, two: 2}
one === 1
%{hello => world} = %{"hello" => "world"}
# Raise error as key must be literals
```

### Range

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

**`Enum.chunk..` may very useful**

```exs
[1,2,3,4,5]
|> Enum.chunk_every(2, 1, :discard) === [[1,2], [2,3], [3,4], [4,5]]
```

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

## Built-in Modules

Worth reading: [API Reference](https://hexdocs.pm/elixir/api-reference.html).

List of Common modules (NOT ALL available modules):

- Core module: `Kernel`.
- Modules for Data Type: `Integer`, `String`, `List`, `Map`, `Keyword`, ...
- Modules For Behavior: `Enum`, ...

```exs
# Get tuple elem by index
Kernel.elem({3, 6, 9}, 1) === elem({3, 6, 9}, 1)
elem({3, 6, 9}, 1) === 9

# Check type `is_type(value_to_check)`
Kernel.is_map(%{}) === is_map(%{})
Kernel.is_binary("hello") === true

# max min
max(100,200) === min(200,300)

# Safe Convert any term Elixir into string
inspect(%{}) === "%{}"
```

```exs
# Parse list - un list
Integer.digits(123) === [1,2,3]
Integer.undigits([1,2,3]) === 123

# Parse Int
Integer.parse("25abc\n") === {25, "abc\n"}
```

- `Integer.gcd/2` gets greatest common denominator.

- `String.at/2` gets the value at the index of a string.

- `List.delete_at/2` remove an element at an index in a list.
- `List.insert_at/3` insert an element at a specified index within a list.
- `List.update_at/3` update an element at a specified index within a list.
- `List.zip/1` combine elements from multiple lists into a single list of tuples

```exs
letters = ["a", "b", "c"]
numbers = [1, 2, 3]

List.zip([letters, numbers]) === [{"a", 1}, {"b", 2}, {"c", 3}]
```

- `Map.get/3` retrieve values in a map.
- `Map.put/3` put a value into a map.
- `Map.keys/1` list the keys in a map.
- `Map.delete/2` remove a key and value from a map.
- `Map.merge/2` merge two maps together.
- `Map.update/4` and `Map.update/3` update a map using the existing value of the updated key.
- `Map.values/1` list the values in a map.

- `Keyword.get/3` retrieve values in a keyword list.
- `Keyword.keys/1` list the keys in a keyword list.
- `Keyword.keyword?/1` check if some data is a keyword list.

```exs
defmodule ConfigurableServer do
  def start_link(opts) do
    name = Keyword.get(opts, :name)
    initial_state = Keyword.get(opts, :state, 0)

    GenServer.start_link(__MODULE__, initial_state, name: name)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end
end
```

## Comprehensions And Non-Enumerable Data Types

### Non-Enumerables

Data types that does not implement the Enumerable protocol, such as: integers, floats, **strings**, atoms, **tuples**.

- Different from JS, **Strings** is Non-Enumerable. Mean we CAN NOT use `Enum` with plain strings type.
- Also, `String.split` has slightly difference behavior.

To Enumerate these types, simply convert they to enumerable type like Lists.

```exs
Integer.digits(123)
Integer.undigits([1,2,3])

Tuple.to_list({1, 2, 3})
List.to_tuple([1, 2, 3])

# Same as JS
String.split("a,b,c,d", ",") === ["a", "b", "c", "d"]

# Different from JS - default split whitespace
String.split("hello world") === ["hello", "world"]
# Different from JS - include empty string at start and end
String.split("abcde", "") === ["", "a", "b", "c", "d", "e", ""]
# Option to trim above empty string
String.split("abcde", "", trim: true) === ["a", "b", "c", "d", "e"]

Enum.join(["a", "b", "c"]) === Enum.join(["a", "b", "c"], "")
# "abc" - default join by empty string

```

### Comprehensions

Way to create new lists, maps, or sets by iterating over an existing collection and applying a set of transformations.

Similar to `Enum.map/2`, `Enum.filter/2`, and `Enum.reduce/2` functions but with a more concise syntax => Enum syntax sugar that has 3 parts: **generators**, **filters**, and **collectables**.

```exs
generator = 1..3

# Generator: enumerable data type 
for element <- generator do
  element * 2
end === [2, 4, 6]

# Filter: return true/false | element >= 2
for element <- generator, element >= 2 do
  element * 2
end === [4, 6]

# Collectable: `:into` collect the result to other data types than list
for element <- generator, into: "" do
  "#{element}"
end === "123"

for n <- 1..3, into: %{} do
  {:"key_#{n}", n}
end === %{key_1: 1, key_2: 2, key_3: 3}

for n <- 1..3, into: %{default: "hello!"} do
  {:"key_#{n}", n}
end === %{default: "hello!", key_1: 1, key_2: 2, key_3: 3}

# With Pattern matching
for {:keep, value} <- [keep: 1, keep: 2, filter: 1, filter: 3] do
  value
end === [1, 2]

for {key, value} <- %{a: 1, b: 2}, into: %{} do
  {key, value * 2}
end === %{a: 2, b: 4}
```

#### Multiple - Nested Loop

We can use multiple comma-separated generators, filters in a single comprehension.

The comprehension treats each additional generator like a **nested loop**. For each element in the first loop, it will enumerate through every element in the second loop.

```exs
# Multi generators
for a <- 1..3, b <- 4..6 do
  {a, b}
end === [
  {1, 4}, {1, 5}, {1, 6},
  {2, 4}, {2, 5}, {2, 6},
  {3, 4}, {3, 5}, {3, 6}
]

# Multi filters
for a <- 1..100, rem(a, 3) === 0, rem(a, 5) === 0 do
  a
end === [15, 30, 45, 60, 75, 90]

# Multi generators, filters
for a <- 1..45, b <- 1..5, rem(a, 5) === 0, rem(b, 5) === 0 do
  [a, b]
end === for a <- 1..45, rem(a, 5) === 0, b <- 1..5, rem(b, 5) === 0 do
  [a, b]
end
# [[5, 5], [10, 5], [15, 5], [20, 5], [25, 5], [30, 5], [35, 5], [40, 5], [45, 5]]
```

## Dates And Times

`Date` structs store `year`, `month`, `day` and some other related fields.

```exs
# new `year`, `month`, `day`
{:ok, date} = Date.new(2000, 10, 1)

date.year === 2000
date.month === 10
date.day === 1
```

`Time` structs store `hour`, `minute`, `second`.

```exs
# new `hour`, `minute`, `second`
{:ok, time} = Time.new(12, 30, 10)

time.hour === 12
time.minute === 30
time.second === 10
```

`DateTime` is a hybrid of `Date` and `Time`. It actually structs which can be `Map.from_struct`.

```exs
# new `date`, `time`
{:ok, datetime} = DateTime.new(date, time)

Map.from_struct(datetime) === %{
  microsecond: {0, 0},
  second: 10,
  calendar: Calendar.ISO,
  month: 10,
  day: 1,
  year: 2000,
  minute: 30,
  hour: 12,
  time_zone: "Etc/UTC",
  zone_abbr: "UTC",
  utc_offset: 0,
  std_offset: 0
}
```

> **`Timex`** is a recommended Library for handling dates/times, supports timezone.

### Sigils

`Sigils` is textual representation of data. We can use its syntax to create `Date`, `Time`, and `DateTime`.

Sigils syntax use a tilda `~` and a character for the type of data they represent, such as: `U` is UTC datetime.

```exs
date = ~D[2000-10-01]
time = ~T[12:30:10]
# The Z Offset Specifies The Timezone Offset. Z Is Zero For UTC.
datetime = ~U[2000-10-01 12:30:10Z]

DateTime.new(date, time) === datetime
DateTime.new(~D[2000-10-01], ~T[12:30:10]) === datetime
```

### Calendar

[Formatting Syntax](https://hexdocs.pm/elixir/Calendar.html#strftime/3-accepted-formats)

```exs
# `strftime`: String from Time

Calendar.strftime(~U[2000-10-01 12:30:10Z], "%y-%m-%d %I:%M:%S %p") === "00-10-01 12:30:10 PM"

Calendar.strftime(~U[2000-10-01 12:30:10Z], "%Y-%m-%D %I:%M:%S %p") === "2000-10-01 12:30:10 PM"
```

## Strings and Binaries

To check if a value is a string, we use the `is_binary/1` function. That's because strings in Elixir are represented internally as binaries (bitstring).

Use `?` to find codepoint of a character.

```exs
?A === 65
?a === 97

# Charlist
[104, 101, 108, 108, 111] === ~c"hello" 

# Bitstring to String
<<104, 101, 108, 108, 111>> === "hello"

# hex
"\u0065" === "e" # as 0x65 === 101 === ?e
```

**Generally** each character is store in 1 byte (= 8 bits).
Elixir uses UTF-8 to encode it's strings, meaning that each code point is encoded as a series of 8-bit bytes (cause 1 byte store integer max = 255).

```exs
byte_size("h") === 1
bit_size("h") === 8

byte_size("hello") === 5
bit_size("hello") === 40

byte_size("é") === 2
```

Be careful when splitting a string for enumeration, we can use `graphemes("abc")` instead `split("abc", "", trim: true)`.

```exs
String.graphemes("👩‍🚒") === ["👩‍🚒"]
String.codepoints("👩‍🚒") === ["👩", "‍", "🚒"]

noel = "noël" # "ë" === "e\u0308"
String.codepoints(noel) === ["n", "o", "e", "̈", "l"]
String.graphemes(noel) === ["n", "o", "ë", "l"]
```

**Charlist** is a **List** of valid code points.

```exs
[?h, ?e, ?l, ?l, ?o] === [104, 101, 108, 108, 111]

~c"hello"  === [?h, ?e, ?l, ?l, ?o]
~c"hello"  === [104, 101, 108, 108, 111]
~c"hello"  === 'hello'

List.to_string(~c"hello") === "hello"
String.to_charlist("hello") === ~c"hello"

Enum.map(~c"abcde", fn each -> each + 1 end) === ~c"bcdef"

"abcdefghijklmnopqrstuvwxyz"
|> String.to_charlist
|> IO.inspect(charlists: :as_lists)
# Print a list of codepoints
# [97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122]
```

## Regex

Use `~r` sigil with `//` to create a Regex.

```exs
~r/hello/
```

### Module Regex

```exs
Regex.match?(~r/ll/, "hello hello") === true
String.match?("hello hello", ~r/ll/) === true

# find
Regex.run(~r/ll/, "hello hello") === ["ll"]

# find ALL
Regex.scan(~r/ll/, "hello hello") === [["ll"], ["ll"]]

# replace ALL (by default)
Regex.replace(~r/el/, "hello hello", "a") === "halo halo"
String.replace("hello hello", ~r/el/, "a") === "halo halo"

# split on matches
Regex.split(~r/\d/, "one1two2three") === ["one", "two", "three"]
String.split("one1two2three", ~r/\d/) === ["one", "two", "three"]
```

- `\d` digit.
- `\w` word character.
- `.` non-newline character (essentially anything).
- `\s` whitespace character.

- `*` 0 or more times.
- `+` one or more times.
- `?` zero or one time.
- `{}` specify the number of times.

- `[]` range of digits or letters.
- `|` OR.
- `^` NOT.

- `()` capture groups.

- `(?=)` positive lookahead. Match expressions **Followed** by another.
- `(?!)` negative lookahead. Match expressions **NOT Followed** by another.
- `(?<=)` positive lookbehind. Match expressions **Preceded** by another.
- `(?<!)` negative lookbehind. Match expressions **NOT Preceded** by another.

```exs
Regex.run(~r/(a)(b)/, "ab") === ["ab", "a", "b"] # match "ab" ? -> match "a" ? -> match "b" ?

Regex.run(~r/(ab)/, "ab") === ["ab", "ab"] # match "ab" ? -> match "ab" ?

Regex.replace(~r/(\d{3})-\d{3}-(\d{4})/, "111-111-1111", fn match, group1, group2 ->
  "g1-" <> group1 <> "XXX" <> "g2-" <> group2
end) === "g1-111-XXX-g2-1111"

# match "a" followed by "u" -> "au" -> return "a" without "u"
Regex.scan(~r/a(?=u)/, "a au") === [["a"]]

# match "a" NOT followed by "u" -> "at", "a" -> return "a", "a"
Regex.scan(~r/a(?!u)/, "at a au") === [["a"], ["a"]]

# match `word+` preceded by `a digit with period` and followed by `a period`
Regex.scan(~r/(?<=\d\. )\w+(?=\.)/, "
1. one.
2. two
3. three.
") === [["one"], ["three"]] 
```

### Options

- `m`: patterns such as start of line `^` and end of line `$` will match multiple lines instead of just the string.
- `x`: Regular expressions can be written on multiple lines and documented.

```exs
Regex.match?(
  ~r/
\+\d{1,3} # country code i.e. +1
\s        # space  
\(\d{3}\) # area code i.e. (555)
-         # dash
(\d{3}    # prefix i.e. 555
-         # dash
\d{4})    # line number i.e. 5555
/x,
  "+1 (111)-111-1111"
) === true
```

## Recursion

Elixir can **optimize recursive functions if its tail-call** (the last thing it does is call itself). Otherwise, if the function calls itself in the body, it's called **body-recursion which is not optimized**.

```exs
defmodule RecursiveSum do
  def sum(list, accumulator \\ 0) do
    case list do
      [] -> accumulator
      [head | tail] -> sum(tail, accumulator + head)
    end
  end
end

defmodule BaseCaseExample do
  def sum([], accumulator), do: accumulator
  def sum([head | tail], accumulator), do: sum(tail, accumulator + head)
end

RecursiveSum.sum([1, 2, 3], 0) === 6

BaseCaseExample.sum([1, 2, 3], 0) === 6
```

Code block below will be optimize: **Recommended Format**.

```exs
defmodule CountBetween do
  def count(finish, finish), do: IO.puts(finish)

  def count(start, finish) when start < finish do
    IO.puts(start)
    count(start + 1, finish)
  end

  def count(start, finish) when start > finish do
    IO.puts(start)
    count(start - 1, finish)
  end
end

CountBetween.count(2, 5)
CountBetween.count(10, 5)
```

## Pattern Matching - Advanced

Behave based on data shape

```exs
case {1, 2} do
  [a, b] -> "behavior for list" 
  {a, b} -> "behavior for tuple"
end === "behavior for tuple"

case [1, 2, 3] do
  [head | tail] = list ->
    IO.inspect(head, label: "head")
    IO.inspect(tail, label: "tail")
    IO.inspect(list, label: "list")
end

# head: 1
# tail: [2, 3]
# list: [1, 2, 3]

anonymous_run = fn
  [] -> "1"
  [_] -> "2"
  [_, _] -> "3"
end

anonymous_run.([]) === "1"
anonymous_run.([1]) === "2"
anonymous_run.([1, 1]) === "3"

enumerable = [double: 1, double: 2, triple: 3, quadruple: 4]

Enum.map(enumerable, fn
  {:double, value} -> value * 2
  {:triple, value} -> value * 3
  {:quadruple, value} -> value * 4
end) === [2, 4, 9, 16]

enumerable = [add: 1, subtract: 2, add: 4, multiply: 3]

Enum.reduce(enumerable, 0, fn
  {:add, value}, acc -> acc + value
  {:subtract, value}, acc -> acc - value
  {:multiply, value}, acc -> acc * value
end) === 9

enumerable = [keep: 1, remove: 2, keep: 4, remove: 1]

Enum.filter(enumerable, fn
  {:keep, _} -> true
  {:remove, _} -> false
end) === [keep: 1, keep: 4]

defmodule PatternParamExample do
  def inspect([a, b, c] = param1) do
    IO.inspect(a, label: "a")
    IO.inspect(b, label: "b")
    IO.inspect(c, label: "c")
    IO.inspect(param1, label: "param1")
  end
end

PatternParamExample.inspect([1, 2, 3])

# a: 1
# b: 2
# c: 3
# param1: [1, 2, 3]

defmodule MessageMatchExample do
  def send(%{is_admin: true}, "") do
    {:error, :empty_message}
  end

  def send(%{is_admin: true}, message) do
    {:ok, message}
  end

  def send(%{is_admin: false}, _) do
    {:error, :not_authorized}
  end
end

MessageMatchExample.send(%{is_admin: true}, "") === {:error, :empty_message}
```

The **pin operator** allows us to use variables as hard-coded values, rather than rebinding a variable.

```exs
received = [1, 2]
expected = [1, 2, 3]

^received = expected # [1,2] = [1,2,3] -> Error

first = 1
actual = [2, 2, 3]

[^first, 2, 3] = actual  # [1,2,3] = [2,2,3] -> Error

first = 1
actual = [1, 2, 3]
[^first, 2, 3] = actual # Nothing happened
```

```exs
pinned_value = 1

case {:ok, 1} do
  {:ok, ^pinned_value} -> "clause 1"
  {:ok, generic_value} -> "clause 2"
end === "clause 1" # With pinned it behaves like we want

# Despite Being 2, Not 1, Clause 1 Is Triggered Because We Didn't Pin The Value.
case {:ok, 2} do
  {:ok, pinned_value} -> "clause 1"
  {:ok, generic_value} -> "clause 2"
end === "clause 1" # WRONG
```

## Guards

```exs
defmodule RockPaperScissors do
  defguard is_guess(guess) when guess in [:rock, :paper, :scissors]

  def winner(guess) when is_guess(guess) do
    case guess do
      :rock -> :paper
      :scissors -> :rock
      :paper -> :rock
    end
  end
end

RockPaperScissors.winner(:rock) === :paper

RockPaperScissors.winner("invalid guess") # Error
```

```exs
defmodule PolymorphicGuardExample do
  def double(num) when is_number(num) do
    num * 2
  end

  def double(string) when is_binary(string) do
    string <> " " <> string
  end
end

PolymorphicGuardExample.double(2) === 4
PolymorphicGuardExample.double("example") === "example example"
```

## With

`with` is a control structure that provides a convenient way to handle multiple expressions and pattern match on their results. It allows you to chain together a sequence of expressions and evaluate them one by one, stopping if any of them return an error or a pattern match fails.

```exs
with {:ok, v1} <- check1(),
     {:ok, v2} <- check2(v1),
     {:ok, v3} <- check3(v2),
     {:ok, v4} <- check4(v3),
     {:ok, _} <- check5(v4) do
  # code that requires successful results above
end

# Same as 

case action1() do
  {:ok, v1} ->
  case action2(v1) do
    {:ok, v2} ->
      case action3(v2) do
        {:ok, v3} -> 
          case action4(v3) do
            {:ok, v4} -> 
              case check5(v4) do
                {:ok, _} -> 
                  # code that requires successful results above.
              end
          end
      end
  end
end
```

With Else

```exs
user = %{name: "Jon", is_admin: false}

with %{name: name, is_admin: true} <- user do
  IO.puts("admin #{name} is authorized.")
else
  %{is_admin: false, name: name} ->
    IO.puts("#{name} is not an admin")

  %{is_admin: false} ->
    IO.puts("Unknown user is not an admin")

  _ ->
    IO.puts("Something went wrong!")
end

value = "example"

with {:not_binary, true} <- {:not_binary, is_binary(value)},
     {:too_long, true} <- {:too_long, String.length(value) <= 10},
     {:too_short, true} <- {:too_short, 2 <= String.length(value)} do
  IO.puts("success")
else
  {:not_binary, _} -> IO.puts("value is not binary")
  {:too_long, _} -> IO.puts("value is too long")
  {:too_short, _} -> IO.puts("value is too short")
end
```

## Protocols

`protocol` allows us to create a common functionality, with different implementations.

Specifically, protocols enable polymorphic behavior based off of data.

Define using `defprotocol` for head and `defimpl` for implementation and `for:` for struct or data type.

```exs
defprotocol Adder do
  def add(value, value)
end

defimpl Adder, for: Integer do
  def add(int1, int2) do
    int1 + int2
  end
end

Adder.add(1, 2)

defimpl Adder, for: BitString do
  def add(string1, string2) do
    string1 <> string2
  end
end

Adder.add("hello, ", "world")
```

For modules that have struct

```exs
defprotocol Sound do
  def say(struct)
end

defmodule Cat do
  defstruct [:mood]
end

defimpl Sound, for: Cat do
  def say(cat) do
    case cat.mood do
      :happy -> "Purr"
      :angry -> "Hiss!"
    end
  end
end

Sound.say(%Cat{mood: :happy})
```

## Persistence Using The File System

### Streams

`Enum` requires each element in the enumeration to be stored in memory during execution. Each `Enum` function stores a copy of the the enumerable it creates and executes sequentially.

In short, **chain Enums** waste memory. Instead, use Streams and Lazy evaluation can massively improve memory usage.

```exs
1..10
|> Enum.map(fn each -> each * 2 end)
|> Enum.filter(fn each -> each <= 10 end)
|> Enum.take(4)
```

`Streams` are composable, lazy enumerables. **Lazy** means they execute on each element in the stream one by one. **Composable** means that we build up functions to execute on each element in the stream.

The `Stream` will only evaluate when it's called with any eager function from the `Enum` module.

```exs
1..10
|> Stream.map(fn each -> each * 2 end)
|> Stream.filter(fn each -> each <= 10 end)
|> Stream.take(4)
|> Enum.to_list()
```

Streams will generally provide the greatest benefits when operations **reduce the number of elements** in the enumerable.

Stream can be used as generator.

- `iterate/2` to iterate over an accumulator. Each function return `next_accumulator`.
- `unfold/2` separates the accumulator and the return value. So you can accumulate, and then generate a separate value from the accumulator. Each function return: `{value, next_accumulator}` to continue OR `nil` to end stream.

```exs
# [1,2,3,1,2,3,...] **Cycle** to infinity
Stream.cycle([1, 2, 3])
|> Enum.take(10) === [1, 2, 3, 1, 2, 3, 1, 2, 3, 1]

# acc = 0 -> function <-> next acc
Stream.iterate(0, fn accumulator -> accumulator + 1 end)
|> Enum.take(5) === [0, 1, 2, 3, 4]

# acc = 5 <-> function -> value
Stream.unfold(5, fn accumulator ->
  value = "value: #{accumulator}"
  next_accumulator = accumulator + 1
  {value, next_accumulator}
end)
|> Enum.take(5) === ["value: 5", "value: 6", "value: 7", "value: 8", "value: 9"]

Stream.unfold(0, fn
  10 ->
    nil

  accumulator ->
    value = "value: #{accumulator}"
    next_accumulator = accumulator + 1
    {value, next_accumulator}
end)
|> Enum.to_list() === ["value: 0", "value: 1", "value: 2", "value: 3", "value: 4", "value: 5", "value: 6", "value: 7",
 "value: 8", "value: 9"]
```

### File

`File` module for working with the file system and the `Path` module for working with file paths.

- [File.cd/1](https://hexdocs.pm/elixir/File.html#cd/1) change the current directory.
- [File.dir?/2](https://hexdocs.pm/elixir/File.html#dir?/2) check if a given path is a directory.
- [File.exists?/2](https://hexdocs.pm/elixir/File.html#exists?/2) check if a file exists.
- [File.ls/1](https://hexdocs.pm/elixir/File.html#ls/1) list all files and folders in the current directory.
- [File.read/1](https://hexdocs.pm/elixir/File.html#read/1) read content from a file.
- [File.rm/1](https://hexdocs.pm/elixir/File.html#rm/1) remove a file.
- [File.rm_rf/1](https://hexdocs.pm/elixir/File.html#rm_rf/1)remove files and directories in a given path.
- [File.mkdir/1](https://hexdocs.pm/elixir/File.html#mkdir/1) create a directory given a path.
- [File.mkdir_p/1](https://hexdocs.pm/elixir/File.html#mkdir_p/1) create a directory and any missing parent directories given a path.
- [File.write/3](https://hexdocs.pm/elixir/File.html#write/3) write content to a given file path.

- [Path.absname/1](https://hexdocs.pm/elixir/Path.html#absname/1) convert the given path into an absolute path.
- [Path.dirname/1](https://hexdocs.pm/elixir/Path.html#dirname/1) return the directory portion of a given path.
- [Path.join/2](https://hexdocs.pm/elixir/Path.html#join/2) join two paths. This is much more reliable than string concatenation.
- [Path.split/1](https://hexdocs.pm/elixir/Path.html#split/1) split a path into a list on each directory separator `/`
- [Path.wildcard/2](https://hexdocs.pm/elixir/Path.html#wildcard/2) return a list of files that match the provided expression.

`File.open/2` and `File.close/1` to open a file and perform some operations, then close when finished.

While the file is open, `IO.read/2` and `IO.write/2` to read and write to the file.

- `IO.read/2` function can read a new line each time called.
- `IO.write/2` writes over the entire content of the file. We need to open the file with the :write option to enable write permission.

```exs
File.write!("open_close.txt", content)

{:ok, file} = File.open("open_close.txt")

IO.read(file, :line) |> IO.inspect()
IO.read(file, :line) |> IO.inspect()
IO.read(file, :line) |> IO.inspect()
IO.read(file, :line) |> IO.inspect()

File.close(file)
```

```exs
File.write!("open_close.txt", content)

{:ok, file} = File.open("open_close.txt", [:write])

IO.write(file, "written content")

File.close(file)

File.read("open_close.txt") |> IO.inspect(label: "Updated File")
```

## Processes

All Elixir code runs inside of a process.

- Processes are **isolated** from each other and communicate via message passing. (A process crashes won't affect others)
- Processes can store state and allow us to have in-memory persistence.

- `send/2` and `receive/1` messages between processes by using **pid** (process id).
- `self/0` return current pid.
- `spawn/1` create a new child process and return its pid.
- `spawn_link/1` create new process that link to current process (link process crashes will lead to current process crashes).
- `Process.link/1` link current process with another process by **pid** argument.
- `Process.sleep/1` sleep for milliseconds.
- `Process.send_after/3` send message after milliseconds.
- `Process.exit/2` with option `:normal` or `:kill`.

```exs
send(self(), {:hello, "world"})

receive do
  {:hello, payload} -> payload
end === "world"
```

Spawn's process end when its callback function end.

```exs
pid = spawn(fn -> IO.puts("I was called") end)

Process.alive?(pid) && IO.puts("I am alive!")

Process.sleep(100)

Process.alive?(pid) === false && IO.puts("I am dead :(")

# I am alive!
# I was called
# I am dead!

# -> Print: alive -> called -> dead
```

### State

This process will die after receive a message.

```exs
pid1 = spawn(fn ->
  receive do
    {:hello, what} -> IO.puts(what)
  end
end)

send(pid1, {:hello, "world"})
```

This process stay alive as it loop itself.

```exs
defmodule ServerProcess do
  def loop do
    IO.puts("called #{Enum.random(1..10)}")

    receive do
      "message" -> loop()
    end
  end
end

server_process = spawn(fn -> ServerProcess.loop() end)

send(server_process, "message")
```

Then, we can store state as below.

```exs
defmodule Counter do
  def loop(state \\ 0) do
    IO.inspect(state, label: "counter")

    receive do
      :increment -> loop(state + 1)
      :decrement -> loop(state - 1)
    end
  end
end

counter_process = spawn(fn -> Counter.loop() end)

send(counter_process, :increment)
send(counter_process, :decrement)
```

## GenServers

A module from OTP (Open Telecom Platform) library. Stand for **Generic Server**, refers to a programming pattern and behavior.

Generic Server provides a structured approach to building concurrent and fault-tolerant systems by encapsulating state, managing message-based communication, and defining behavior through callback functions.

1. **State Management**: The [GenServer](https://hexdocs.pm/elixir/GenServer.html) process holds and manages its own internal state. This state can be modified by handling specific messages and updating the state accordingly.
2. **Message Handling**: [GenServer](https://hexdocs.pm/elixir/GenServer.html) processes receive messages asynchronously and handle them using pattern matching on the message content. The behavior of the server can be defined based on the message received.
3. **Synchronous and Asynchronous Communication**: [GenServer](https://hexdocs.pm/elixir/GenServer.html) processes can communicate synchronously by sending a message and waiting for a response, or asynchronously by sending a message without expecting an immediate reply.
4. **Supervision and Fault Tolerance**: [GenServer](https://hexdocs.pm/elixir/GenServer.html) processes are often used within supervision trees, allowing them to be monitored and restarted in the event of failures or crashes. This contributes to the fault-tolerant nature of OTP applications.
5. **Callback Functions**: [GenServer](https://hexdocs.pm/elixir/GenServer.html) requires implementing specific callback functions such as [handle_call/3](https://hexdocs.pm/elixir/GenServer.html#c:handle_call/3), [handle_cast/2](https://hexdocs.pm/elixir/GenServer.html#c:handle_cast/2), and [handle_info/2](https://hexdocs.pm/elixir/GenServer.html#c:handle_info/2) to define the behavior of the server for different types of messages.

### Message Handler Callbacks

The [GenServer](https://hexdocs.pm/elixir/GenServer.html) module defines all of the boilerplate under the hood, and allows us to conveniently provide callback functions
 including:

- [init/1](https://hexdocs.pm/elixir/GenServer.html#c:init/1) defines the initial state in an `{:ok, state}` tuple.
- [handle_call/3](https://hexdocs.pm/elixir/GenServer.html#c:handle_call/3) handle a synchronous message meant for a GenServer process.
- [handle_cast/2](https://hexdocs.pm/elixir/GenServer.html#c:handle_cast/2) handle an asynchronous message meant for a GenServer process.
- [handle_info/2](https://hexdocs.pm/elixir/GenServer.html#c:handle_info/2) handle a generic asynchronous message.

- `GenServer.handle_cast/2`
  - Non-blocking message handling.
  - Typically only used to update GenServer state.
- `GenServer.handle_info/2`
  - Non-blocking message handling
  - Used for a wider variety of messages such as system level behavior, or handling messages that are sent to many different types of processes.
  - Can receive messages sent after an amount of time with `Process.send_after/4`.

### Starting A GenServer

We commonly use one of the following functions to start a GenServer process.

- [GenServer.start_link/3](https://hexdocs.pm/elixir/GenServer.html#start_link/3) start a GenServer as a linked process.
- [GenServer.start/3](https://hexdocs.pm/elixir/GenServer.html#start/3) start a GenServer without linking the process.

### Sending A GenServer A Message

We can send the [GenServer](https://hexdocs.pm/elixir/GenServer.html) messages with functions such as:

- [GenServer.call/3](https://hexdocs.pm/elixir/GenServer.html#call/3) send a synchronous message for a GenServer handled by `handle_call/3`.
- [GenServer.cast/2](https://hexdocs.pm/elixir/GenServer.html#cast/2) send an asynchronous message for a GenServer handled by `handle_cast/2`.
- [Kernel.send/2](https://hexdocs.pm/elixir/Kernel.html#send/2) send a generic asynchronous message handled by `handle_info/2`
- [Process.send/3](https://hexdocs.pm/elixir/Process.html#send/3) send a generic asynchronous message with some additional options handled by `handle_info/2`.
- [Process.send_after/4](https://hexdocs.pm/elixir/Process.html#send_after/4) send a generic asynchronous message handled by `handle_info/2`.

```exs
defmodule CounterServer do
  use GenServer

  # initializes the initial state = 0
  @impl true
  def init(_init_arg) do
    {:ok, 0}
  end

  # asynchronously updates the state
  @impl true
  def handle_cast(:increment, state) do
    {:noreply, state + 1}
  end

  # returns a synchronous response
  @impl true
  def handle_call(:get_count, _from, state) do
    # `response` bound for sake of clarity.
    response = state
    {:reply, response, state}
  end
end

# Call

{:ok, pid} = GenServer.start_link(CounterServer, [])
first = GenServer.call(pid, :get_count)

GenServer.cast(pid, :increment)
second = GenServer.call(pid, :get_count)

GenServer.cast(pid, :increment)
third = GenServer.call(pid, :get_count)

{first, second, third} === {0, 1, 2}
```

### Client API

Client API makes our code more reusable, readable, and easy to change. This is purely for code organization.

Callback functions are often referred to as the **Server API**.

Client API functions typically use `__MODULE__` when referencing the current module to make it easier to rename the module in the future.

```exs
defmodule ClientServerExample do
  use GenServer
  # Client API

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [])
  end

  def increment(pid) do
    GenServer.cast(pid, :increment)
  end

  def get_count(pid) do
    GenServer.call(pid, :get_count)
  end

  # Server API

  def init(_init_arg) do
    {:ok, 0}
  end

  def handle_cast(:increment, state) do
    {:noreply, state + 1}
  end

  def handle_call(:get_count, _from, state) do
    response = state
    {:reply, response, state}
  end
end
```

Separated Client and Server modules can not use `__MODULE__` to reference.

```exs
defmodule ClientExample do
  def start_link(_opts) do
    GenServer.start_link(ServerExample, [])
  end

  def increment(pid) do
    GenServer.cast(pid, :increment)
  end

  def get_count(pid) do
    GenServer.call(pid, :get_count)
  end
end

defmodule ServerExample do
  use GenServer

  def init(_init_arg) do
    {:ok, 0}
  end

  def handle_cast(:increment, state) do
    {:noreply, state + 1}
  end

  def handle_call(:get_count, _from, state) do
    response = state
    {:reply, response, state}
  end
end
```

### Named Processes

`GenServer.start_link/3` takes additional options as the third argument. We can provide a `:name` option to name the process. Names are typically atoms or module names (which are just atoms under the hood.)

Named processes are unique, there cannot be two processes with the same name. Named processes are also easy to reference as you can use the name of the process to send them a message.

```exs
defmodule NamedCounter do
  def start_link(_opts) do
    GenServer.start_link(NamedCounter, [], name: NamedCounter)
  end

  def init(_init_arg) do
    {:ok, 0}
  end

  def handle_cast(:increment, state) do
    {:noreply, state + 1}
  end
end

# cast accept both process name and pid.
GenServer.cast(NamedCounter, :increment)

# Return pid of process name.
# Can be used to get pid for functions accept only pid.
Process.whereis(NamedCounter)
```

### GenServers Sending Themselves A Message

A GenServer cannot synchronously send itself a message using `call/3` because the current message blocks the process mailbox.

```exs
defmodule SendingSelfExample do
  use GenServer

  def init(_init_arg) do
    {:ok, nil}
  end

  def handle_call(:talking_to_myself, _from, state) do
    Process.sleep(1000)
    IO.puts("Talking to myself")
    GenServer.call(self(), :talking_to_myself)
    {:reply, "response", state}
  end

  def handle_cast(:talking_to_myself, state) do
    Process.sleep(1000)
    IO.puts("Talking to myself")
    GenServer.cast(self(), :talking_to_myself)
    {:noreply, state}
  end
end

{:ok, pid} = GenServer.start(SendingSelfExample, [])
GenServer.call(pid, :talking_to_myself)
```

Instead of `cast/2` + `handle_cast/2` or `call/3` + `handle_call/3`, use `send_after/3` with `handle_info/2` to send self a message.

```exs
defmodule Timer do
  @moduledoc """
  iex> {:ok, pid} = Timer.start_link([])
  iex> Timer.get_time(pid)
  0
  iex> Process.sleep(1200)
  iex> Timer.get_time(pid)
  1
  """
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, 0)
  end

  def get_time(timer_pid) do
    GenServer.call(timer_pid, :get_time)
  end

  def init(_) do
    inc()
    {:ok, 0}
  end

  def inc() do
    Process.send_after(self(), :inc, 1000)
  end

  def handle_info(:inc, state) do
    {:noreply, state + 1}
  end

  def handle_call(:get_time, _from, state) do
    {:reply, state, state}
  end
end
```

### Testing GenServers

To test something **Stateful** like a process.

```exs
defmodule CounterServer do
  use GenServer

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:increment, _from, state) do
    {:reply, state + 1, state + 1}
  end

  @impl true
  def handle_call(:get_count, _from, state) do
    {:reply, state, state}
  end
end

defmodule CounterClient do
  def start_link(_opts) do
    GenServer.start_link(CounterServer, 0)
  end

  def increment(pid) do
    GenServer.call(pid, :increment)
  end

  def get_count(pid) do
    GenServer.call(pid, :get_count)
  end
end
```

Generally, we **don't want to test** the implementation like below. Cause if any of the internals change, these tests could break, even though the behavior of the counter module doesn't.

```exs
ExUnit.start(auto_run: false)

defmodule CounterServerTest do
  use ExUnit.Case

  test "Counter receives :increment call" do
    {:ok, pid} = GenServer.start_link(CounterServer, 0)
    GenServer.call(pid, :increment)
    assert :sys.get_state(pid) == 1
  end
end

ExUnit.run()
```

Instead, we generally **want to test** on the client interface of the GenServer like below.

```exs
ExUnit.start(auto_run: false)

defmodule CounterClientTest do
  use ExUnit.Case

  test "increment/1" do
    {:ok, pid} = CounterClient.start_link([])
    CounterClient.increment(pid)
    assert CounterClient.get_count(pid) == 1
  end
end

ExUnit.run()
```

## Supervisors

`Supervisors` monitor processes and *restart* them when they die. *restart* mean kill the process and start a new one in its place.

Every supervisor is also a process. The `Supervisor.start_link/2` function accepts a list of child processes and starts the supervisor process. We provide each child as a map with an `:id` and a `:start` signature.

```exs
defmodule Worker do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], [])
  end

  def init(state) do
    {:ok, state}
  end
end

children = [
  %{
    id: :worker1,
    start: {Worker, :start_link, [1]}
  },
  %{
    id: :worker2,
    start: {Worker, :start_link, [2]}
  },
  %{
    id: :worker3,
    start: {Worker, :start_link, [3]}
  }
]

{:ok, supervisor_pid} = Supervisor.start_link(children, strategy: :one_for_one)
```

### Restart Strategies

- `:one_for_one` restart only crashed worker.
- `:one_for_all` restart all workers if any of them crashed.
- `:rest_for_one` restart workers in order after the crashed process.

### Syntax Sugar

Instead of a map with `:id` and `:start` keys, use tuple:

- First value is the name of the module as `:id`.
- Second value is the argument passed to `start_link/1`.

```exs
children = [
  {Bomb, [name: "Syntax Sugar Bomb", bomb_time: 1000]}
]
```

### Supervised Mix Projects

Command to generate a supervised mix project.

```sh
mix new my_app --sup
```

OR we can manually add these configuration, file for supervised.

- `my_app/application.ex` use an `Application` module that defines application callbacks.

```exs
defmodule MyApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: RockPaperScissors.Worker.start_link(arg)
      # {RockPaperScissors.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
```

- Add module to `mix.exs`.

```exs
def application do
  [
    extra_applications: [:logger],
    mod: {MyApp.Application, []}
  ]
end
```

## Task

A module allows us to spawn a process, perform some work in that process, then end the process when our work is finished.

Task is also OTP-compliant, meaning it conform to certain OTP conventions that improve error handling, and allow them to start under a supervisor.

- `Task.start/1` like Kernel `spawn/1`, it's fire-and-forget.
- `async/1` create an async process (Task struct) and `await/1` to run + await that process.
- `await_many/1` await a list of async task.
- `await/2` and `await_many/2` accept a timeout value as the second argument (default to 5000 milliseconds).

```exs
task =
  Task.async(fn ->
    # simulating expensive calculation
    Process.sleep(1000)
    "response!"
  end)

Task.await(task)
```

```exs
computation1 = fn -> Process.sleep(1000) end
computation2 = fn -> Process.sleep(1000) end

{microseconds, _result} =
  :timer.tc(fn ->
    task1 = Task.async(fn -> computation1.() end)
    task2 = Task.async(fn -> computation2.() end)

    Task.await(task1)
    Task.await(task2)
  end)

# Expected To Be ~1 Second
microseconds / 1000 / 1000
```

### Task Supervisor

- `Task.Supervisor.start_child/2` start a fire-and-forget task.
- `Task.Supervisor.async/2` + `Task.await/2` execute tasks concurrently and retrieve its result. If the task fails, the caller will also fail.
- `Task.Supervisor.async_nolink/2` + `Task.yield/2` + `Task.shutdown/2` execute tasks concurrently and retrieve their results or the reason they failed within a given time frame. If the task fails, the caller won't fail. You will receive the error reason either on yield or shutdown.

```exs
children = [
  {Task.Supervisor, name: MyTaskSupervisor}
]

{:ok, supervisor_pid} =
  Supervisor.start_link(children, strategy: :one_for_one, name: :parent_supervisor)

task =
  Task.Supervisor.async(MyTaskSupervisor, fn ->
    IO.puts("Task Started")
    Process.sleep(1000)
    IO.puts("Task Finished")
    "response!"
  end)

Task.await(task)
```
