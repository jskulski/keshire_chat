defmodule KeshireChatWeb.PageController do
  use KeshireChatWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
