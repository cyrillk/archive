-module(erlporter_main).

%% API
-export([process/1]).

-define(GET_URL, "http://www.rts.ru/export/xml/fortsmarketresults.aspx?code=~s").
%%-define(GET_URL, "http://www.rts.ru/export/xml/fortsmarketresults.aspx?code=~s&rts_system=F").

-define(PUT_URL, "http://~s:8098/riak/~s/~s").

%% [{FILTER, BUCKET}]
-define(PARAMS, [{"RTS-%", "RTS"}, {"GAZR%", "GAZR"}, {"SBRF%", "SBRF"}]).

-define(BUCKET, "delayed").

%%-define(MEASURE(Fun), Started = erlang:now(), Fun(), timer:now_diff(erlang:now(), Started)).

%% ===================================================================
%% API functions
%% ===================================================================

%% @spec process(string()) -> ok
%% @doc imports data from remote host, process it and exports to the storage
process(Host) ->
    Period = measure(fun() -> processItem(?PARAMS, Host) end),
    lager:log(info, self(), "data processed in [~p ms]", [Period div 1000]),
    ok.

%% ===================================================================
%% private functions
%% ===================================================================

%% TODO use macros instead
measure(Fun) ->
    Started = erlang:now(),
    Fun(),
    timer:now_diff(erlang:now(), Started).

processItem([Params | Tail], Host) ->
    Period = measure(fun() -> export(import(Params), Host, Params) end),
    lager:log(info, self(), "~p processed in [~p ms]", [Params, Period div 1000]),
    processItem(Tail, Host);
processItem([], _T) ->
    ok.

import({Filter, _B}) ->
    Request = io_lib:format(?GET_URL, [Filter]),
    {ok, _S, _H, ResponseBody} = ibrowse:send_req(Request, [], get),
    erlporter_parser:parse_xml(ResponseBody).
    
export([{Key, Data} | Tail], Host, {_F, Base}) ->
    URL = lists:flatten(io_lib:format(?PUT_URL, [Host, ?BUCKET, Key])),
    Export = mochijson2:encode(Data ++ [{base, list_to_binary(Base)}]),
    ibrowse:send_req(URL, [{"Content-Type", "application/json"}], put, Export),
    export(Tail, Host, {_F, Base});
export([], _H, _P) ->
    ok.
