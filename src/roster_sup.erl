-module(roster_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    % {ok, { {one_for_one, 5, 10}, []} }.
	Server = {roster, {roster, start, []},
			permanent, 2000, worker, [roster]},
	Children = [Server],
	RestartStrategy = {one_for_one, 0, 1},
	{ok, {RestartStrategy, Children}}.

