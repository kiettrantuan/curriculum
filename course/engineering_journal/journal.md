# A React Developer's Journal on Learning Elixir

## Github Collab exercise

OSS stands for Open Source Software.

A OSS Contributor can contribute in many forms, such as writing code, fixing bugs, improving documentation, or even participating in discussions.

## Strings

- Concatenation: `<>`
- Multi lines:

```elixir
string = """
line 1
line 2
"""
```

- Interpolation: `#{value}`
- Escaping: `\`

## Comparison Operators

Different to JS: `1.0 === 1` return `false` as type difference: `float` vs `integer`

You can compare different data types to each other in the following [Sorting Order](https://hexdocs.pm/elixir/1.12.3/operators.html#term-ordering).

```txt
number < atom < reference < function < port < pid < tuple < map < list < bitstring 
```
