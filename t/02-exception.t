use v6;
use lib 'lib';
use Test;
use WebService::SOP::Auth::V1_1::X;

try {

    WebService::SOP::Auth::V1_1::X.new(reason => "HOGE").throw;

    fail 'Should not be called';

    CATCH {
        default {
            is $_.reason, 'HOGE';
            is $_.message, 'Error: HOGE';
        }
    }
}

done-testing;
