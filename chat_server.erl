-module(chat_server).
-export([start/0, loop/0, handle_client/2]).

start() ->
    spawn(fun loop/0).

loop() ->
    {ok, ListenSocket} = gen_tcp:listen(9999, [binary, {active, false}]),
    accept(ListenSocket).

accept(ListenSocket) ->
    {ok, Socket} = gen_tcp:accept(ListenSocket),
    spawn(fun() -> handle_client(Socket, "") end),
    accept(ListenSocket).

handle_client(Socket, PrevData) ->
    receive
        {tcp, Socket, Data} ->
            case Data of
                "quit" ->
                    gen_tcp:send(Socket, "Goodbye!"),
                    gen_tcp:close(Socket);
                _ ->
                    NewData = PrevData ++ Data,
                    io:format("Received: ~s~n", [NewData]),
                    gen_tcp:send(Socket, NewData),
                    handle_client(Socket, NewData)
            end;
        {tcp_closed, Socket} ->
            io:format("Client disconnected~n", []),
            ok
    end.
