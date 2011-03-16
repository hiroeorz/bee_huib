-module(status).
-compile(export_all).
-include("twoorl.hrl").

parse_to_json(Msgs, UserDict) ->
    {ok, parse_to_json(Msgs, UserDict, [])}.

parse_to_json(Msgs, UserDict, MsgList) ->
    case Msgs of
	[] -> lists:reverse(MsgList);
	[Record | Tail] ->
	    parse_to_json(Tail, UserDict,
			  [msg_record_for_json(Record, UserDict) | MsgList])
    end.

msg_record_for_json(Msg, UserDict) ->
   
    MsgBody = msg:body(Msg),
    MsgId = msg:id(Msg),
    MsgUserId = msg:usr_id(Msg),
    {ok, [UserStruct| _]} = orddict:find(MsgUserId, UserDict),

    {datetime, Date} = msg:created_on(Msg),
    {ok, FormattedDate} = twoorl_util:format_datetime_string(Date),

    {struct, [{text, MsgBody}, 
	      {id,   MsgId},
	      {user, UserStruct},
	      {created_at, FormattedDate}]}.

user_record_for_json(User) ->
    {struct, [{username, usr:username(User)}]}.

users_dict(Msgs) -> users_dict(Msgs, []).

users_dict(Msgs, Ids) ->
    case Msgs of 
	[] ->
	    usr:dict(Ids);
	[Msg | Tail] ->
	    UserId = msg:usr_id(Msg),

	    case lists:member(UserId, Ids) of
		true -> 
		    users_dict(Tail, Ids);
		false ->
		    users_dict(Tail, [UserId | Ids])
	    end
    end.

reply_msg_ids(Replys) -> reply_msg_ids(Replys, []).
reply_msg_ids(Replys, MsgIds) ->
    case Replys of
	[] ->
	    MsgIds;
	[Reply | Tail] ->
	    reply_msg_ids(Tail, [reply:msg_id(Reply) | MsgIds])
    end.

timeline_count(A) -> 
    case yaws_api:getvar(A, count) of
	{ok, Count} -> list_to_integer(Count);
	undefined     -> 20
    end.

params_where(A, Where) ->
    Where1 = where_since_id(A, Where),
    Where1.

where_since_id(A, Where) ->
    case yaws_api:getvar(A, since_id) of
	{ok, SinceId} -> {'and', [{id, '>', SinceId}, Where]};
	undefined     -> Where
    end.
