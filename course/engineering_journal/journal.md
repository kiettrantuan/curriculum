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

### Pattern Matching

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
