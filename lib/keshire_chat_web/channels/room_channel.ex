defmodule KeshireChatWeb.RoomChannel do
  use Phoenix.Channel

  def join("rooms:lobby", _message, socket) do
    {:ok, socket}
  end

  def join(_room, _params, _socket) do
    {:error, %{reason: "you can only join the lobby"}}
  end

  def handle_in("app:new_message", payload, socket) do
    broadcast! socket, "app:new_message", payload
    broadcast! socket, "sms:new_message", payload
    broadcast! socket, "pn:new_message", payload
    {:noreply, socket}
  end
  def handle_in("sms:new_message", payload, socket) do
    broadcast! socket, "app:new_message", payload
    broadcast! socket, "sms:new_message", payload
    broadcast! socket, "pn:new_message", payload
    {:noreply, socket}
  end
  def handle_in("pn:new_message", payload, socket) do
    broadcast! socket, "app:new_message", payload
    broadcast! socket, "sms:new_message", payload
    broadcast! socket, "pn:new_message", payload
    {:noreply, socket}
  end

end