%% Copyright
-module(erlporter_worker).

%% API
-export([start/0, stop/0, ping/0]).

-define(GET_URL, "http://www.rts.ru/export/xml/fortsmarketresults.aspx?code=~s&rts_system=F").
-define(PUT_URL, "curl -XPUT http://54.228.222.119:8098/riak/~s/~s -d '~s' -H 'content-type: application/json'").

-define(PARAMS_RTS, {"RTS-%", "RTS"}). %% {FILTER, BUCKET}
-define(PARAMS_GAZR, {"GAZR%", "GAZR"}). %% {FILTER, BUCKET}
-define(PARAMS_SBRF, {"SBRF%", "SBRF"}). %% {FILTER, BUCKET}

-define(TIMEOUT, 30).

%% to ping process, returns simple reply
ping() ->
  {ok, erlang:localtime()}.

%% runs process
start() ->
  inets:start(), %% Starts the Inets application.
  loop_request().

%% stops process
stop() ->
  inets:stop(). %% Stops the Inets application.

loop_request() ->
  io:fwrite("~w~n", [erlang:localtime()]), %% output
  get_and_put(?PARAMS_RTS),
  get_and_put(?PARAMS_GAZR),
  get_and_put(?PARAMS_SBRF),
  timer:sleep(timer:seconds(?TIMEOUT)), %% timeout
  loop_request().

get_and_put({Filter, Bucket}) ->
  Request = io_lib:format(?GET_URL, [Filter]),
  Records = erlporter_parser:parse_http(httpc:request(Request)), %% {ok, {StatusLine, Headers, Body}} | {error,Reason}
  put_items(Records, Bucket).

%% makes put request
put_items([{Key, JSON} | Tail], Bucket) ->
  io:fwrite("~s~n", [Key]), %% output
  Command = io_lib:format(?PUT_URL, [Bucket, Key, JSON]),
  os:cmd(erlang:binary_to_list(unicode:characters_to_binary(Command))),
  put_items(Tail, Bucket);

put_items([], _) ->
  ok.
