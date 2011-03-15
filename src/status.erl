-module(status).
-compile(export_all).
-include("twoorl.hrl").

get_count() -> 20.

parse(Msgs, UserDict) ->
    {ok, parse(Msgs, UserDict, [])}.

parse(Msgs, UserDict, MsgList) ->
    case Msgs of
	[] -> lists:reverse(MsgList);
	[Record | Tail] ->
	    parse(Tail, UserDict,
		  [msg_record_for_json(Record, UserDict) | MsgList])
    end.

msg_record_for_json(Msg, UserDict) ->
   
    MsgBody = msg:body(Msg),
    MsgId = msg:id(Msg),
    MsgUserId = msg:usr_id(Msg),
    {ok, [UserStruct| _]} = orddict:find(MsgUserId, UserDict),

    {struct, [{text, MsgBody}, 
	      {id,   MsgId},
	      {user, UserStruct}]}.

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
