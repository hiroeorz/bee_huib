
-module(twoorl_ja).
-export([bundle/1]).

bundle(Tag) ->
    case Tag of
	%% layout
	login -> <<"ログイン">>;
	register -> <<"新規ユーザ作成">>;
	logged_in_as -> <<"こんにちは">>;
	settings -> <<"設定">>;
	logout -> <<"ログアウト">>;
	get_source ->
	    <<"Obtenir le <a href=\"http://code.google.com/p/twoorl\">"
	     "code source</a>">>;

	%% navbar
	home -> <<"ホーム">>;
	replies -> <<"返信">>;
	me -> <<"送信">>;
	everyone -> <<"全員">>;

	%% login page
	login_cap -> <<"ログイン">>;
	username -> <<"ユーザ名">>;
	password -> <<"パスワード">>;
	not_member -> <<"まだTwoorlに登録していませんか?">>;
	login_submit -> <<"ログイン">>;

	%% register page
	register_cap -> <<"新規ユーザ登録">>;
	email -> <<"Eメール">>;
	password2 -> <<"パスワード(確認用)">>;
	already_member -> <<"既にTwoorlに登録済みですか?">>;

	%% home page
	upto -> <<"今なにしてる?">>;
	twitter_msg -> <<"Twitterへの自動送信します。"
			"返信は有効ではありません。">>;

	%% main page
	public_timeline -> <<"全ユーザ">>;

	%% users page
	{no_user, Username} ->
	    [<<"Le nom d'utilisateur '">>, Username, <<"' n'existe pas">>];
	{timeline_of, Username} ->
	    [Username, <<" のタイムライン">>];
	following -> <<"フォローしている">>;
	followers -> <<"フォローされている">>;
	follow -> <<"フォロー">>;
	unfollow -> <<"フォローを解除">>;

	%% friends page
	{friends_of, Userlink} ->
	    [<<"Gens suivis par ">>, Userlink];
	{followers_of, Userlink} ->
	    [<<"Suiveurs de ">>, Userlink];
	{no_friends, Username} ->
	    [Username, <<" ユーザ名">>];
	{no_followers, Username} ->
	    [Username, <<" n'est suivi par personne">>];


	%% settings page
	settings_cap -> <<"設定">>;
	use_gravatar -> <<"アイコン画像に<a href=\"http://gravatar.com\" "
			 "target=\"_blank\">Gravatar</a>を使用しますか?">>;
	profile_bg -> <<"背景画像">>;
	profile_bg_help ->
	    <<"背景画像に使用する画像へのURLを入力してください。<br> "
	     "(初期画像のままで良い場合は空欄のままにしておいてください):">>;
	twitter_help ->
	    <<"Twoorlへのツイートを自動的にツイッターに送信するように設定出来ます。 "
	     "<br/><br/>"
	     "リプライを含むツイートはツイッターに送信しません。 (例, "
	     "\"@hoge\")">>;
	twitter_username -> <<"ツイッターのアカウント名:">>;
	twitter_password -> <<"ツイッターのパスワード:">>;
	twitter_auto -> <<"Twoorlへのツイートを自動的にツイッターに送信しますか?">>;
	submit -> <<"保存">>;
	
	%% error messages
	{missing_field, Field} ->
	    [<<"Le champ ">>, Field, <<" est requis.">>];
	{username_taken, Val} ->
	    [<<"Le nom d'utilisateur '">>, Val, <<"' n'est pas disponible.">>];
	{invalid_username, Val} ->
	    [<<"Le nom d'utilisateur '">>, Val,
	     <<"' n'est pas valide. Seulement les lettres, numéros et le symbole de souligné ('_') sont acceptés.">>];
	invalid_login ->
	    <<"ユーザ名かパスワードが間違っています。">>;
	{too_short, Field, Min} ->
	    [<<"Le champ ">>, Field, <<" est trop court (">>, Min,
	     <<" charactères minimum).">>];
	password_mismatch ->
	    <<"Les mots de passe ne coïncident pas.">>;
	twitter_unauthorized ->
	    <<"Twitter n'a pas accepté le nom d'usager ou le mot de passe fournis.">>;
	twitter_authorization_error ->
	    <<"Échec lors de la connexion à Twitter. Veuillez essayer plus tard.">>;
	{invalid_url, Field} ->
	    [<<"Le champ URL ">>, Field, <<" doit commencer par 'http://'">>];
	
	%% confirmation messages
	settings_updated ->
	    [<<"Votre configuration a été mise à jour.">>]
    end.

