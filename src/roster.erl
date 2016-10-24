-module(roster).
-export([start/0]).

-define(SERVER, "localhost").
-define(USER, "root").
-define(PASSWD, "123456").
-define(DB, "test").

start() ->
	mysql:start_link(p1, ?SERVER, 3306, ?USER, ?PASSWD, ?DB, undefined, utf8),
	case file:open("roster.txt",read) of
		{ok, Data} ->
			Val = readdata(Data),
			lists:foreach(fun(X) -> 
				case X of
		            {roster,Usj,Us,Jid,Name,Subscription,Ask,Groups,
		                               Askmessage,Xs} ->
			            % io:format("Usj:~p~n", [Usj]),
			            % io:format("Us:~p~n", [Us]),
			            % io:format("Jid:~p~n", [Jid]),
			            % io:format("Name:~p~n~n", [Name]),
			            % io:format("Subscription:~p~n", [Subscription]),
			            % io:format("Ask:~p~n", [Ask]),
			            % io:format("Groups:~p~n", [Groups]),
			            % io:format("Askmessage:~p~n", [Askmessage]),
			            % io:format("Xs:~p~n", [Xs]),
			            {Uid, _} = Us,
			            {Oid, Oserver,_} = Jid,
			            Ojid = list_to_binary([Oid, <<"@">>,Oserver]),
			            if Ask == out -> Oask = "O";
			               Ask == in  -> Oask = "I";
			               true -> Oask = "O"
			            end,
			            if Subscription == none -> Osubscription = "N";
			               Subscription == both  -> Osubscription = "B";
			               true -> Osubscription = "N"
			            end,
			            Sql = list_to_binary([<<"INSERT INTO rosterusers(username, jid, nick, subscription, ask, askmessage, server, subscribe, type) VALUES "
					     "('">>, Uid ,<<"', '">>, Ojid ,<<"', '">>, Name,<<"', '">>, Osubscription, <<"', '">>, Oask,<<"', '', 'N', '', 'item')">>]),
			       		mysql:fetch(p1, Sql);
			       	_ -> ok
			    end
			end,Val);
		{error, Why} -> {error, Why}
	end,
	io:format("Import Data Over!~n"),
	init:stop().

readdata(Data) ->
	case io:read(Data, '') of
		{ok, Term} -> [Term|readdata(Data)];
		eof -> [];
		Error -> Error
	end.
