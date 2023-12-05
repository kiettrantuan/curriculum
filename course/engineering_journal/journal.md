# A React Developer's Journal on Learning Elixir

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
