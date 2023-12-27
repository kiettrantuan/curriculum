defmodule RandomNumberWeb.PageController do
  use RandomNumberWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def random_number(conn, _params) do
    render(conn, :random_number, random_number: Enum.random(1..100))
  end
end
