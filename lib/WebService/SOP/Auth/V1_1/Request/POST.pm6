use v6;
use HTTP::Request::Common;
use URI::Escape;
use WebService::SOP::Auth::V1_1::Util;

unit class WebService::SOP::Auth::V1_1::Request::POST;

method create-request(URI :$uri, Hash:D :$params, Str:D :$app-secret --> HTTP::Request) {

    die '`time` is required in params' if not $params<time>:exists;

    my %query = %( $uri.query-form, %$params );
    %query<sig> = WebService::SOP::Auth::V1_1::Util.create-signature(%query, $app-secret);

    POST(URI.new("{$uri.scheme}://{$uri.host}{$uri.path}"), %query);
}
