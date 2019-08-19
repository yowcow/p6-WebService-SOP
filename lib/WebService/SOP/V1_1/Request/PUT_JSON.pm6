use v6;
use HTTP::Request::Common;
use JSON::Fast;
use URI;
use WebService::SOP::V1_1::Util;

unit class WebService::SOP::V1_1::Request::PUT_JSON;

method create-request(URI :$uri, Hash:D :$params, Str:D :$app-secret --> HTTP::Request) {

    die '`time` is required in params' if not $params<time>:exists;

    my Str $json-data = to-json(%( $uri.query-form.Hash, %$params ), pretty => False);
    my Str $sig = create-signature($json-data, $app-secret);

    PUT(
        URI.new("{$uri.scheme}://{$uri.host}{$uri.path}"),
        content      => $json-data,
        Content-Type => 'application/json',
        X-Sop-Sig    => $sig,
    );
}
