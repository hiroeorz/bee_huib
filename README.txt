To run Twoorl follow the following steps:

- Get the latest versiona of ErlyWeb (prior to 0.7.1, this would be from trunk) and Yaws
- If installing to MacOSX, you should add +ssl when install Erlang. example: sudo port install erlang +ssl
- Install MySQL and create a MySQL database for twoorl.
- Run twoorl.sql to create the Twoorl tables.
- Run migrations/[1-9].sql to migrate Twoorl tables.
- Edit src/twoorl_app.hrl with your appropriate environment variables.

- Make Directory for logs
  $ mkdir logs

- Edit yaws.conf to add the ErlyWeb application settings for Twoorl.

- start Yaws
  $ sudo yaws -i --conf etc/yaws.conf

- connecto to mysql server in the shell, type ...
  > erlydb:start(mysql, [{hostname, "localhost"}, {username, "beehuib"},{password, "beehuib"}, {database, "beehuib"}]).

- compile erlang sources in the shell, type...
  > erlyweb:compile("/Users/shin/src/erlyweb/bee_huib",[{erlydb_driver, mysql}]).

- start server in the shell, type...
  > twoorl:start().

Cheers!
Yariv

To run in embedded mode:

$ make clean && make
$ erl -sname twoorlapp -setcookie twoorl -mnesia dir "'twoorl.mnesia'" -yaws embedded true -pa ebin -boot start_sasl
1> [application:start(X) || X <- [inets, crypto, mnesia, twoorl]].
[ok, ok, ok, ok]

# Nick Gerakines



* when modified source code
