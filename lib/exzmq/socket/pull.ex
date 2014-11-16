## This Source Code Form is subject to the terms of the Mozilla Public
## License, v. 2.0. If a copy of the MPL was not distributed with this
## file, You can obtain one at http://mozilla.org/MPL/2.0/.
defmodule Exzmq.Socket.Pull do

  defmodule State do
      defstruct []
  end

  ##===================================================================
  ## API
  ##===================================================================

  ##===================================================================
  ## ezmq_socket callbacks
  ##===================================================================

  @type state_name :: atom
  @type reason :: atom
  @spec init(tuple) :: {:ok, state_name, State.t} | {:stop, reason}
  def init(_opts) do
    {:ok, :idle, %State{}}
  end

  def close(_state_name, _transport, mqsstate, state) do
    {:next_state, :idle, mqsstate, state}
  end

  def encap_msg({_transport, msg}, _state_name, _mqsstate, _state) do
    Exzmq.simple_encap_msg(msg)
  end

  def decap_msg(_transport, {_remoteId, msg}, _stateName, _mqsstate, _state) do
    Exzmq.simple_decap_msg(msg)
  end

  ##Check
  def idle(:check, :deliver, _mqsstate, _state) do
    :ok
  end

  def idle(:check, {:deliver_recv, _transport}, _mqsstate, _state) do
    :ok
  end

  def idle(:check, :recv, _mqsstate, _state) do
    :ok
  end

  def idle(:check, _, _mqsstate, _state) do
    {:error, :fsm}
  end

  ## do

  def idle(:do, {:deliver, _transport}, mqsstate, state) do
    {:next_state, :idle, mqsstate, state}
  end

  def idle(:do, {:queue, _transport}, mqsstate, state) do
    {:next_state, :idle, mqsstate, state}
  end

  def idle(:do, {:dequeue, _transport}, mqsstate, state) do
    {:next_state, :idle, mqsstate, state}
  end

  def idle(:do, _, _mqsstate, _state) do
    {:error,:fsm}
  end

end
