# defmodule KeshireChat.Registry do
#   def join(room_key, user_key, http_request) do
#     IO.puts "[JOIN] #{user_key} joined #{room_key}" # no test -jsk
#   end
# end

defmodule KeshireChat.RegistryTest do
  use ExUnit.Case

  # test "Registry can subscribe a user to a channel" do
  #   KeshireChat.Registry.join(:test_room_key, :test_user_key, :test_http_request)
  #   KeshireChat.Registry.list(:test_room_key)
  #   |>
  # end
end
