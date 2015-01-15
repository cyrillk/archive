-module(erlporter_parser).

%% API
-export([parse_xml/1]).

-include_lib("xmerl/include/xmerl.hrl").

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

%% ===================================================================
%% API functions
%% ===================================================================

%% @spec parse_xml(string()) -> [Key, [{Name, <<Value>>}]]
%% @doc Parses xml response from data server and returns a list of attributes
parse_xml(Input) ->
    %% replaces encoding with a supported one
    Patched = re:replace(Input, "windows-1251", "utf-8", [multiline, {return, list}]),

    %% removes all unsupported symbols - might be changed in the future
    Cleaned = [X || X <- Patched, X < 128],
    
    %% scans input string with xmerl
    {XML, _Rest} = xmerl_scan:string(Cleaned),

    %% xpath to moment attribute
    Moments = xmerl_xpath:string("/rtsdata/@moment", XML),
    Moment = hd([Value || #xmlAttribute{name = Name, value = Value} <- Moments, Name == moment]),

    %% xpath to issues elements
    Issues = xmerl_xpath:string("/rtsdata/issues/issue", XML),

    %% extracts data as key/value pairs
    extract_key_value_data(Issues, {"moment", list_to_binary(Moment)}, []).

%% ===================================================================
%% private functions
%% ===================================================================

%% @doc extracts xml attributes as key-value pairs
extract_key_value_data([Head | Tail], Moment, Buffer) ->
    XMLAttributes = xmerl_xpath:string("@*", Head),
    
    %% retrieve all attributes except 'name_ru' and 'name_en'
    Attributes = [{N, list_to_binary(V)} || #xmlAttribute{name = N, value = V} <- XMLAttributes, N /= name_ru, N /= name_en],
    
    %% retrieve key from attributes
    Key = hd([binary_to_list(V) || {N, V} <- Attributes, N == short_code]),
    
    extract_key_value_data(Tail, Moment, Buffer ++ [{Key, Attributes ++ [Moment]}]);
extract_key_value_data([], _, Buffer) ->
    Buffer.

%% ===================================================================
%% tests
%% ===================================================================
-ifdef(TEST).

parse_test() ->
    Items = parse_xml(test_xml()), %% tests xml data
    erlang:display(Items),
    ?assertEqual(2, length(Items)),
    ?assertEqual(true, lists:keymember("RIH3", 1, Items)),
    ?assertEqual(true, lists:keymember("RIM3", 1, Items)),
    ok.

test_xml() -> "<?xml version=\"1.0\" encoding=\"windows-1251\"?>
<?xml-stylesheet type=\"text/xsl\" href=\"/export/xml/fortsmarketresults.xsl\"?>
<rtsdata moment=\"2013-03-06 04:15:57\">
<issues moment=\"2013-03-05\">
<issue rts_system=\"F\" name_ru=\"\" name_en=\"RTS Index Futures\" code=\"RTS-6.13\" short_code=\"RIM3\" delivery_date=\"2013-06-17\" best_bid=\"148310\" best_ask=\"148350\" first_price=\"145520\" max_price=\"148410\" min_price=\"145100\" last_price=\"148320\" last_price_change=\"1.903\" avg_price=\"146980\" settl_price=\"148320\" options_volatility=\"\" money_volume_market=\"1491962599.04\" volume_market=\"16533\" trades_num_market=\"4958\" money_volume_adr=\"0\" volume_adr=\"0\" trades_num_adr=\"0\" open_interest=\"109178\" open_interest_money=\"9942188667.34\" />
<issue rts_system=\"F\" name_ru=\"\" name_en=\"RTS Index Futures\" code=\"RTS-3.13\" short_code=\"RIH3\" delivery_date=\"2013-03-15\" best_bid=\"152300\" best_ask=\"152330\" first_price=\"149620\" max_price=\"152450\" min_price=\"149020\" last_price=\"152310\" last_price_change=\"1.88\" avg_price=\"150797\" settl_price=\"152310\" options_volatility=\"\" money_volume_market=\"114104658239.64\" volume_market=\"1232332\" trades_num_market=\"328922\" money_volume_adr=\"1014131928.43\" volume_adr=\"10855\" trades_num_adr=\"47\" open_interest=\"871430\" open_interest_money=\"81490704591.1\" />
</issues>
</rtsdata>".

-endif.

