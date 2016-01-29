use v6;
use lib 'lib';
use Test;

[
    'WebService::SOP::Auth::V1_1',
    'WebService::SOP::Auth::V1_1::Util',
    'WebService::SOP::Auth::V1_1::Request::GET',
    'WebService::SOP::Auth::V1_1::Request::POST',
    'WebService::SOP::Auth::V1_1::Request::POST_JSON',
].map(-> $module { use-ok $module, $module });

done-testing;
