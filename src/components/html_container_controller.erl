%% This file is part of Twoorl.
%% 
%% Twoorl is free software: you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published by
%% the Free Software Foundation, either version 3 of the License, or
%% (at your option) any later version.
%% 
%% Twoorl is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%% GNU General Public License for more details.
%% 
%% You should have received a copy of the GNU General Public License
%% along with Twoorl.  If not, see <http://www.gnu.org/licenses/>.
%%
%% Copyright Yariv Sadan, 2008
%%
%% @author Yariv Sadan <yarivsblog@gmail.com> [http://yarivsblog.com]
%% @copyright Yariv Sadan, 2008

-module(html_container_controller).
-export([private/0, index/3]).
-include("twoorl.hrl").

private() ->
    true.

index(_A, Ewc, PhasedVars) ->
    Background = case proplists:get_value(background, PhasedVars) of
		      undefined ->
			  ?DEFAULT_BACKGROUND;
		      Bg ->
			  Bg
		  end,
    HeaderItems = case proplists:get_value(header_items, PhasedVars) of
		      undefined -> [];
		      Other -> Other
		  end,

    [{data, {Background, HeaderItems}}, Ewc].

