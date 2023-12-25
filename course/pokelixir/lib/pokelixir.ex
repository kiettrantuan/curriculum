defmodule Pokelixir do
  @moduledoc """
  Documentation for `Pokelixir`.
  """

  @doc """
  Hello world.


  ## Examples
      iex> Pokelixir.get("charizard")
      %Pokemon{
        id: 6,
        name: "charizard",
        hp: 78,
        attack: 84,
        defense: 78,
        special_attack: 109,
        special_defense: 85,
        speed: 100,
        height: 17,
        weight: 905,
        types: ["fire", "flying"]
      }

      iex> Pokelixir.all()
      {1302, 1302}
  """
  def get(name) do
    Finch.start_link(name: MyFinch)

    {:ok, res} =
      Finch.build(:get, "https://pokeapi.co/api/v2/pokemon/#{name}") |> Finch.request(MyFinch)

    body = Jason.decode!(res.body)

    # struct(
    #   Pokemon,
    #   %Pokemon{}
    #   |> Map.to_list()
    #   |> Stream.map(fn {k, _} -> {k, body["#{k}"]} end)
    #   |> Stream.filter(fn {_, v} -> v !== nil end)
    #   |> Map.new()
    # )

    types = Enum.map(body["types"], fn m -> m["type"]["name"] end)

    stats =
      Enum.map(body["stats"], fn m ->
        stat_name = String.replace(m["stat"]["name"], "-", "_")
        {stat_name, m["base_stat"]}
      end)
      |> Map.new()

    %Pokemon{
      id: body["id"],
      name: body["name"],
      hp: stats["hp"],
      attack: stats["attack"],
      defense: stats["defense"],
      special_attack: stats["special_attack"],
      special_defense: stats["special_defense"],
      speed: stats["speed"],
      height: body["height"],
      weight: body["weight"],
      types: types
    }
  end

  def all() do
    Finch.start_link(name: MyFinch2)

    {:ok, res_20} =
      Finch.build(:get, "https://pokeapi.co/api/v2/pokemon") |> Finch.request(MyFinch2)

    count = Jason.decode!(res_20.body)["count"]

    {:ok, res_full} =
      Finch.build(:get, "https://pokeapi.co/api/v2/pokemon?limit=#{count}")
      |> Finch.request(MyFinch2)

    body = Jason.decode!(res_full.body)

    total_results = Enum.count(body["results"])

    {body["count"], total_results}
  end
end
