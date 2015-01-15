#!/bin/bash
# erl -pa ebin deps/*/ebin -boot start_sasl -s lager -s inets -s erlporter

echo -n "Enter host name and press [ENTER]: "
read address

if [ -z "$address" ]
    then address="localhost"
fi

erl -detached -pa ebin deps/*/ebin -boot start_sasl -s lager -s erlporter -host $address;\
sleep 1s;\
tail -f ./log/console.log
