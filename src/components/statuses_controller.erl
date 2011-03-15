-module(statuses_controller).
-export([home_timeline/1, user_timeline/1, mentions/1]).
-include("twoorl.hrl").

home_timeline(A) ->
    twoorl_util:auth(
      A,
      fun(Usr) ->
	      Ids = usr:get_timeline_usr_ids(Usr),
	      OrderBy = {order_by, {created_on, desc}},
	      Limit = {limit, status:get_count()},	      
	      Where = {usr_id, in, Ids},

	      %%Total = msg:count('*', Where1),
	      Msgs = msg:find(Where, [OrderBy, Limit]),
	      {ok, UserDict} = status:users_dict(Msgs),
	      {ok, MsgData} = status:parse(Msgs, UserDict),

	      {response, [{html, json:encode({array, MsgData}) }]}
      end).

user_timeline(A) ->
    twoorl_util:auth(
      A,
      fun(Usr) ->
	      OrderBy = {order_by, {created_on, desc}},
	      Limit = {limit, status:get_count()},	      
	      Where = {usr_id, '=', Usr:id()},

	      Msgs = msg:find(Where, [OrderBy, Limit]),
	      {ok, UserDict} = status:users_dict(Msgs),
	      {ok, MsgData} = status:parse(Msgs, UserDict),

	      {response, [{html, json:encode({array, MsgData}) }]}
      end).

mentions(A) ->
    twoorl_util:auth(
      A,
      fun(Usr) ->
	      Where = {usr_id, '=', Usr:id()},
	      Replys = reply:find(Where),
	      ReplyIds = status:reply_msg_ids(Replys),

	      Where1 = {id, in, ReplyIds},
	      OrderBy = {order_by, {created_on, desc}},
	      Limit = {limit, status:get_count()},	      

	      Msgs = msg:find(Where1, [OrderBy, Limit]),
	      {ok, UserDict} = status:users_dict(Msgs),
	      {ok, MsgData} = status:parse(Msgs, UserDict),

	      {response, [{html, json:encode({array, MsgData}) }]}
      end).
