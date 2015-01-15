%% Copyright
-module(erlservice_web).

%% API
-export([start/0,call/3]).

start() ->
  {ok, Pid} = inets:start(httpd, [
    {modules, [mod_esi, mod_alias, mod_log, mod_disk_log]},
    {port, 8081},
    {server_name, "httpd_test"},
    {server_root, "log"},
    {document_root, "www"},
    {erl_script_alias, {"/erl", [erlservice_web]}},
    {bind_address, "localhost"},
    {error_log, "error.log"},
    {transfer_log, "transfer.log"},
    {mime_types,[
      {"json","application/json"}
    ]},
    {ipfamily, inet}]),
  httpd:info(Pid).

call(SessionID, _Env, Input) ->
  erlservice_handler:handle(Input),
  mod_esi:deliver(SessionID, [
    "Content-Type: application/json\r\n\r\n",
    "{{aaa:1024},{bbb:2048}}"
  ]).

%% http://erlang.org/doc/apps/inets/http_server.html
%% http://www.erlang.org/doc/man/httpd.html

%% mod_alias,
%% mod_auth,
%% mod_esi,
%% mod_actions,
%% mod_cgi,
%% mod_dir,
%% mod_get,
%% mod_head,
%% mod_log,
%% mod_disk_log
