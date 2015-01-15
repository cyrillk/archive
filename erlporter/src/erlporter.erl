
-module(erlporter).

-behaviour(application).

%% API
-export([start/0, stop/0]).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% API functions
%% ===================================================================

start() ->
    application:start(?MODULE).

stop() ->
    application:stop(?MODULE).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    %% Result = erlporter_sup:start_link(),
    %% {ok, [[H]]} = init:get_argument(host),
    %% gen_server:cast(erlporter_server, {host, H}),
    %% Result.
    erlporter_sup:start_link().

stop(_State) ->
    ok.
