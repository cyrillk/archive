-module(erlporter_server).

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(TIMEOUT, 100). %% timeout in seconds

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% ===================================================================
%% gen_server callbacks
%% ===================================================================

init([]) ->
    {ok, [[Host]]} = init:get_argument(host),
    lager:log(info, self(), "application running against [~p] server", [Host]),

    %% starts ibrowse
    application:start(ibrowse),
    {ok, _S, _H, Body} = ibrowse:send_req(lists:flatten(io_lib:format("http://~s:8098/ping", [Host])), [], get),
    lager:log(info, self(), "server replied [~p] to ping request", [Body]),

    %% starts processing
    timer:send_after(1000, [{host, Host}]),
    {ok, ?MODULE}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info([{host, Host}], State) ->
    timer:send_after(timer:seconds(?TIMEOUT), [{host, Host}]),
    erlporter_main:process(Host), %% does some real work
    {noreply, State};
handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    application:stop(ibrowse),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
