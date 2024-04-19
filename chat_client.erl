-module(chat_client).
-export([start/0, loop/1]).

start() ->
    {ok, Socket} = gen_tcp:connect("localhost", 9999, [binary, {active, false}]),
    loop(Socket).

loop(Socket) ->
    io:format("Enter a message (type 'quit' to exit): "),
    Data = io:get_line(""),
    gen_tcp:send(Socket, Data),
    receive
        {tcp, Socket, Response} ->
            io:format("Server response: ~s~n", [Response]),
            loop(Socket)
    end.
