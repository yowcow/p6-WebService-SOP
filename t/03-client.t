use v6;
use lib 'lib';
use Test;
use URI;
use WebService::SOP::Auth::V1_1;

subtest {

    subtest {
        dies-ok {
            WebService::SOP::Auth::V1_1.new(
                app-secret => 'hogefuga',
            );
        }, 'Fails without app-id';

        dies-ok {
            WebService::SOP::Auth::V1_1.new(
                app-id     => 'hogefuga',
                app-secret => 'hogefuga',
            );
        }, 'Fails with wrong type';

    }, 'Test app-id';

    subtest {
        dies-ok {
            WebService::SOP::Auth::V1_1.new(
                app-id => 123,
            );
        }, 'Fails without app-secret';

        dies-ok {
            WebService::SOP::Auth::V1_1.new(
                app-id     => 123,
                app-secret => 12345,
            );
        }, 'Fails with wrong type';

    }, 'Test app-secret';

    subtest {
        my WebService::SOP::Auth::V1_1 $auth .= new(
            app-id     => 123,
            app-secret => 'hogefuga',
        );

        is $auth.app-id, 123,            'app-id is 123';
        is $auth.app-secret, 'hogefuga', 'app-secret is hogefuga';
        is $auth.time.WHAT, Int,         'time is type Int';
        ok $auth.time > 0,               'time is greater than 0';

    }, 'Succeeds without "time"';

    subtest {
        my Int $time = time;
        my WebService::SOP::Auth::V1_1 $auth .= new(
            app-id     => 123,
            app-secret => 'hogefuga',
            time       => $time,
        );

        is $auth.time, $time, 'time is given time: ' ~ $time;

    }, 'Succeeds with "time"';

}, 'Test instance';

done-testing;
