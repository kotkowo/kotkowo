defmodule KotkowoWeb.Plug.AssignIp do
  @moduledoc false
  import Plug.Conn

  def init(_) do
    %{}
  end

  def call(conn, _opts) do
    remote_ip = conn.remote_ip
    put_session(conn, :remote_ip, remote_ip)
  end
end
