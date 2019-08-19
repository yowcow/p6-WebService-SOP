use v6;
use HTTP::Request::Common;
use URI;
use WebService::SOP::V1_1::Util;

unit class WebService::SOP::V1_1::Request::PUT;

method create-request(URI :$uri, Hash:D :$params, Str:D :$app-secret --> HTTP::Request) {

    die '`time` is required in params' if not $params<time>:exists;

    my %query = %( $uri.query-form.Hash, %$params );
    %query<sig> = create-signature(%query, $app-secret);

    PUT(
        URI.new("{$uri.scheme}://{$uri.host}{$uri.path}"),
        content      => build-query-string(%query),
        Content-Type => 'application/x-www-form-urlencoded',
    );
}
