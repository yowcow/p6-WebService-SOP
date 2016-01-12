use v6;
use lib 'lib';
use Test;

[
    'WebService::SOP::Auth::V1_1',
    'WebService::SOP::Auth::V1_1::Util',
].map(-> $module { use-ok $module, $module });

done-testing;
