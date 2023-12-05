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

Different to JS: `1.0 === 1` return `false` as type difference: `float` vs `integer`

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

```exs
{}
{0, "string", :atoms}
{:success, "Well done!"}
{:error, "Too bad!"}
```

### Pattern Matching

`=` sign is the `match operator` because it uses pattern matching to bind variables.

```exs
{1, 2, 3} = {1, 2, 3}
my_tuple = {1, 2, 3}
# Ignored variables are leaded by an underscore `_`
{one, _two, three} = {1, 2, 3}
```
