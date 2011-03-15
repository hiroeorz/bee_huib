-module(statuses_controller).
-export([home_timeline/1, user_timeline/1, mentions/1, update/1]).
-include("twoorl.hrl").

home_timeline(A) ->
    twoorl_util:auth(
      A,
      fun(Usr) ->
	      Ids = usr:get_timeline_usr_ids(Usr),
	      OrderBy = {order_by, {created_on, desc}},
	      Limit = {limit, status:timeline_count()},	      
	      Where = {usr_id, in, Ids},

	      %%Total = msg:count('*', Where1),
	      Msgs = msg:find(Where, [OrderBy, Limit]),
	      {ok, UserDict} = status:users_dict(Msgs),
	      {ok, MsgData} = status:parse_to_json(Msgs, UserDict),

	      {response, [{html, json:encode({array, MsgData}) }]}
      end).

user_timeline(A) ->
    twoorl_util:auth(
      A,
      fun(Usr) ->
	      OrderBy = {order_by, {created_on, desc}},
	      Limit = {limit, status:timeline_count()},	      
	      Where = {usr_id, '=', Usr:id()},

	      Msgs = msg:find(Where, [OrderBy, Limit]),
	      {ok, UserDict} = status:users_dict(Msgs),
	      {ok, MsgData} = status:parse_to_json(Msgs, UserDict),

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
	      Limit = {limit, status:timeline_count()},	      

	      Msgs = msg:find(Where1, [OrderBy, Limit]),
	      {ok, UserDict} = status:users_dict(Msgs),
	      {ok, MsgData} = status:parse_to_json(Msgs, UserDict),

	      {response, [{html, json:encode({array, MsgData}) }]}
      end).

update(A) ->
    twoorl_util:auth(
      A,
      fun(Usr) ->
	      Params = yaws_api:parse_post(A),
	      {[Body], Errs} =
		  erlyweb_forms:validate(
		    Params, ["status"],
		    fun("status", Val) ->
			    case Val of
				[] ->
				    {error, empty_msg};
				_ ->
				    %% helps avoid DOS
				    {ok, lists:sublist(Val, ?MAX_MSG_SIZE)}
			    end
		    end),
	      case Errs of
		  [] ->
		      {Body1, BodyNoLinks, RecipientNames} =
			  msg:process_raw_body(Body),

		      Msg = msg:new_with([{usr_username, Usr:username()},
					  {usr_id, Usr:id()},
					  {body, Body1},
					  {body_nolinks, BodyNoLinks},
					  {body_raw, Body},
					  {usr_gravatar_id,
					   twoorl_util:gravatar_id(
					     Usr:email())},
					  {usr_gravatar_enabled,
					   Usr:gravatar_enabled()},
					  {twitter_status, 0},
					  {spam, Usr:spammer()}]),
		      Msg1 = Msg:save(),

		      spawn(
			fun() ->
				RecipientIds = 
				    usr:find(
				      {username, in,
				       lists:usort(
					 [Name || Name <- RecipientNames])}),
				reply:save_replies(Msg1:id(), RecipientIds)
			end),
		      
		      {response,
		       [{html, json:encode({struct, [{result, "success"}]}) }]};
		  _ ->
		      {response,
		       [{html, json:encode({struct, [{result, "error"}]}) }]}
	      end
      end).
