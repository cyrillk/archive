%% Copyright
-module(erlservice_handler).

%% API
-export([handle/1, handle/2]).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

handle(InputString) ->
  erlang:display("INPUT: " ++ InputString), %% TODO remove
  handle(string:tokens(InputString, "&"), []).

handle([Head | Tail], Buffer) ->
  [Key | Value] = string:tokens(Head, "="),
  handle(Tail, lists:merge(Buffer, [{Key, hd(Value)}]));

handle([], Buffer) ->
  Buffer.

%% Tests
-ifdef(TEST).

handle_empty_test() ->
  ?assertEqual("12345", handle([], "12345")).

handle_string_test() ->
  Items = handle("aaa=111&bbb=222"),
  validate_items(Items).

handle_list_test() ->
  Items = handle(["aaa=111", "bbb=222"], []),
  validate_items(Items).

validate_items(Items) ->
  ?assertEqual(2, length(Items)),
  ?assertEqual(true, lists:member({"aaa", "111"}, Items)),
  ?assertEqual(true, lists:member({"bbb", "222"}, Items)).

-endif.
