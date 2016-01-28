use v6;
use lib 'lib';
use URI;
use Test;
use WebService::SOP::Auth::V1_1::Request::GET;

my Str $class = 'WebService::SOP::Auth::V1_1::Request::GET';

subtest {
    my URI $uri  .= new('http://hoge/get?hoge=hoge');

    dies-ok {
        ::($class).create-request(
            uri        => $uri,
            params     => ['hoge', 'fuga'],
            app-secret => 'hoge',
        )
    }, 'Dies when `params` is not Hash';

    dies-ok {
        ::($class).create-request(
            uri        => $uri,
            params     => { foo => 'bar' },
            app-secret => 'hoge'
        )
    }, 'Dies when `time` is missing in params';

}, 'Test create-request fails';

subtest {
    my Int $time = time;

    subtest {
        my HTTP::Request $req = ::($class).create-request(
            uri        => URI.new('http://hoge/fuga'),
            params     => { foo => 'bar', time => $time },
            app-secret => 'hogehoge',
        );

        is $req.uri.scheme, 'http';
        is $req.uri.host,   'hoge';
        is $req.uri.path,   '/fuga';

        my %query = $req.uri.query-form;

        is %query<foo>, 'bar';
        is %query<time>, $time;
        like %query<sig>, rx{ ^^ <[a..z 0..9]> ** 64 $$ };

    }, 'With no query merge';

    subtest {
        my HTTP::Request $req = ::($class).create-request(
            uri        => URI.new('http://hoge/fuga?bar=foo'),
            params     => { foo => 'bar', time => $time },
            app-secret => 'hogehoge',
        );

        is $req.uri.scheme, 'http';
        is $req.uri.host,   'hoge';
        is $req.uri.path,   '/fuga';

        my %query = $req.uri.query-form;

        is %query<foo>, 'bar';
        is %query<bar>, 'foo';
        is %query<time>, $time;
        like %query<sig>, rx{ ^^ <[a..z 0..9]> ** 64 $$ };

    }, 'With query merge';

}, 'Test create-request succeeds';

done-testing;
