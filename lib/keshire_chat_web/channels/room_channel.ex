defmodule KeshireChatWeb.RoomState do
  def initialize do
    Agent.start_link(
      fn -> %{ "app" => true, "sms" => false, "pn" => false } end,
      name: __MODULE__
     )
  end

  def join name do
    IO.inspect(Agent.get(__MODULE__, fn m -> IO.inspect(m) end))
    Agent.update(
      __MODULE__,
      &Map.put(&1, name, true)
    )
  end

  def leave name do
    Agent.update(
      __MODULE__,
      &Map.put(&1, name, false)
    )
  end

  def joined name do
    Agent.get(
      __MODULE__,
      fn map -> map[name] end
    )
  end
end

defmodule KeshireChatWeb.RoomChannel do
  alias KeshireChatWeb.RoomState

  use Phoenix.Channel

  def join("rooms:lobby", _message, socket) do
    RoomState.initialize
    {:ok, socket}
  end

  def handle_in("join:" <> channel, payload, socket) do
    RoomState.join channel
    {:noreply, socket}
  end

  def handle_in("leave:" <> channel, payload, socket) do
    RoomState.leave channel
    {:noreply, socket}
  end

  def handle_in("app:new_message", payload, socket) do
    _broadcast socket, payload
  end

  def handle_in("sms:new_message", payload, socket) do
    _broadcast socket, payload
  end

  def handle_in("pn:new_message", payload, socket) do
    _broadcast socket, payload
  end


  defp _broadcast socket, payload do
    if RoomState.joined "app" do
      broadcast! socket, "app:new_message", payload
    end

    if RoomState.joined "sms" do
      broadcast! socket, "sms:new_message", payload
    end

    if RoomState.joined "pn" do
      broadcast! socket, "pn:new_message", payload
    end

    {:noreply, socket}
  end
end