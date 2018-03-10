ERL_INCLUDE_PATH=$(shell erl -eval 'io:format("~s~n", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)

all: priv/graphql_parser.so

priv/graphql_parser.so: src/graphqlparser_nif.c
	gcc -fpic -shared -I$(ERL_INCLUDE_PATH) -I/usr/local/include/graphqlparser/ src/graphqlparser_nif.c -o priv/graphql_parser.so -lgraphqlparser
