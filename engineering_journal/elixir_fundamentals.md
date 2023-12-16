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
