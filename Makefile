all:
	./rebar get-deps
	./rebar compile
	@erl -noshell -pa './deps/mysql/ebin' -pa './ebin' -s roster start

clean:
	./rebar delete-deps
	./rebar clean