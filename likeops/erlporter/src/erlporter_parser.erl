%% Copyright
-module(erlporter_parser).

%% API
-export([parse_http/1]).

-include_lib("xmerl/include/xmerl.hrl").

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

parse_http({ok, {_Status, _Headers, Body}}) ->
  parse_xml(Body);

parse_http({error, Reason}) ->
  io:format("Error: ~s~n", [Reason]).

%%
%% parses xml data received from data server
%%
parse_xml(Input) ->
  Patched = replace(Input, "windows-1251", "utf-8"), %% HACK - replaces encoding with a supported one
  Binary = unicode:characters_to_binary(win_to_utf(Patched)),
  Cleaned = erlang:binary_to_list(Binary),

%% scan input
  {XML, _Rest} = xmerl_scan:string(Cleaned),

%% xpath to issues elements
  Issues = xmerl_xpath:string("/rtsdata/issues/issue", XML),

%% xpath to moment attribute
  Moments = xmerl_xpath:string("/rtsdata/@moment", XML),
  Moment = hd([Value || #xmlAttribute{name = Name, value = Value} <- Moments, (Name == moment)]),

%% extracts data and flats result
  lists:flatten(extract_key_value_data(Issues, Moment, [])).

%%
%% extracts data as key-value pairs where value is a JSON like string
%%
extract_key_value_data([Head | Tail], Moment, Buffer) ->
  XMLAttributes = xmerl_xpath:string("@*", Head),

%%   Key = hd([Value || #xmlAttribute{name = Name, value = Value} <- XMLAttributes, (Name == short_code)]),
  Key = extract_key(XMLAttributes),
  MomentJSON = io_lib:format("\"~s\":\"~s\"", ["moment", Moment]),

  Attributes = extract_attributes(XMLAttributes, []),
  AttributesFull = lists:merge(Attributes, [MomentJSON]),
  Joined = "{" ++ string:join(AttributesFull, ",") ++ "}",
  JSON = erlang:binary_to_list(unicode:characters_to_binary(Joined)),

  extract_key_value_data(Tail, Moment, [Buffer | [{Key, JSON}]]);

extract_key_value_data([], _, Buffer) ->
  Buffer.

%%
%% searches for required key attribute and returns it
%%
extract_key([#xmlAttribute{name = Name, value = Value} | _]) when Name == short_code ->
  Value;

extract_key([_ | Tail]) ->
  extract_key(Tail);

extract_key([]) ->
  "error".

%%
%% extracts attributes and generates JSON like string
%%
extract_attributes([#xmlAttribute{name = Name, value = Value} | Tail], Buffer) ->
  String = io_lib:format("\"~ts\":\"~ts\"", [Name, Value]),
  extract_attributes(Tail, lists:merge(Buffer, [String]));

extract_attributes([], Buffer) ->
  Buffer.

win_to_utf(Str) ->
  [convert(Char) || Char <- Str].

convert(Char) ->
  if
    Char == 136 -> _Char = Char + 889; %% Ё
    Char == 168 -> _Char = Char + 969; %% ё
    Char >= 191 -> _Char = Char + 848; %% А..Яа..я
    true -> Char
  end.

replace(Str, Regex, New) ->
  re:replace(Str, Regex, New, [multiline, {return, list}]).

%% greplace(Str, Regex, New) ->
%%   re:replace(Str, Regex, New, [global, multiline, {return, list}]).

%%
%% Tests
%%
-ifdef(TEST).

%% request_test() ->
%%   run().

win_to_utf_en_test() ->
  ?assertEqual("SDFG", win_to_utf("SDFG")).

parse_test() ->
  Items = parse_xml(xml()),
%%   erlang:display(Items),
  ?assertEqual(2, length(Items)),
  ?assertEqual(true, lists:keymember("RIH3", 1, Items)),
  ?assertEqual(true, lists:keymember("RIM3", 1, Items)),
  ok.

xml() -> "<?xml version=\"1.0\" encoding=\"windows-1251\"?>
<?xml-stylesheet type=\"text/xsl\" href=\"/export/xml/fortsmarketresults.xsl\"?>
<rtsdata moment=\"2013-03-06 04:15:57\">
<issues moment=\"2013-03-05\">
<issue rts_system=\"F\" name_ru=\"\" name_en=\"RTS Index Futures\" code=\"RTS-6.13\" short_code=\"RIM3\" delivery_date=\"2013-06-17\" best_bid=\"148310\" best_ask=\"148350\" first_price=\"145520\" max_price=\"148410\" min_price=\"145100\" last_price=\"148320\" last_price_change=\"1.903\" avg_price=\"146980\" settl_price=\"148320\" options_volatility=\"\" money_volume_market=\"1491962599.04\" volume_market=\"16533\" trades_num_market=\"4958\" money_volume_adr=\"0\" volume_adr=\"0\" trades_num_adr=\"0\" open_interest=\"109178\" open_interest_money=\"9942188667.34\" />
<issue rts_system=\"F\" name_ru=\"\" name_en=\"RTS Index Futures\" code=\"RTS-3.13\" short_code=\"RIH3\" delivery_date=\"2013-03-15\" best_bid=\"152300\" best_ask=\"152330\" first_price=\"149620\" max_price=\"152450\" min_price=\"149020\" last_price=\"152310\" last_price_change=\"1.88\" avg_price=\"150797\" settl_price=\"152310\" options_volatility=\"\" money_volume_market=\"114104658239.64\" volume_market=\"1232332\" trades_num_market=\"328922\" money_volume_adr=\"1014131928.43\" volume_adr=\"10855\" trades_num_adr=\"47\" open_interest=\"871430\" open_interest_money=\"81490704591.1\" />
</issues>
</rtsdata>".

-endif.

