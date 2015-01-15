#### The Erlang application to import/export required (for me) data to the riak database.

## Useful links

### rebar

http://alancastro.org/2010/05/01/erlang-application-management-with-rebar.html

http://www.metabrew.com/article/erlang-rebar-tutorial-generating-releases-upgrades

http://carbonshaft.blogspot.co.uk/2011/11/tutorial-getting-started-with-erlang.html

### riak

http://docs.basho.com/riak/latest/tutorials/fast-track/Loading-Data-and-Running-MapReduce-Queries/

### eunit

http://spawnlink.com/articles/getting-started-with-eunit/index.html

http://salientblue.com/codenotes/?name=erl_start

### other

http://www.infoq.com/articles/vinoski-erlang-rest - yaws

http://stm.rest.ru/blog/?p=75 - encoding

http://userprimary.net/posts/2009/02/09/learning-string-manipulation-in-erlang/ - parsing

sub(Str,Old,New) ->
RegExp = "\\Q"++Old++"\\E",
re:replace(Str,RegExp,New,[multiline, {return, list}]).

gsub(Str,Old,New) ->
RegExp = "\\Q"++Old++"\\E",
re:replace(Str,RegExp,New,[global, multiline, {return, list}]).


