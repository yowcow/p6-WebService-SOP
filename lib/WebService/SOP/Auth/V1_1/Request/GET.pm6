use v6;
use HTTP::Request;
use URI::Escape;
use WebService::SOP::Auth::V1_1::Util;

unit class WebService::SOP::Auth::V1_1::Request::GET;

method create-request(URI :$uri, Hash :$params, Str :$app-secret --> HTTP::Request) {

    die '`time` is required in params' if not $params<time>:exists;

    $params<sig> = WebService::SOP::Auth::V1_1::Util.create-signature($params, $app-secret);

    my Str $query = (for %( %( $uri.query-form ), %$params ).kv -> $k, $v {
        uri-escape($k) ~ '=' ~ uri-escape($v)
    }).join("&");

    HTTP::Request.new(GET => URI.new("{$uri.scheme}://{$uri.host}{$uri.path}?{$query}"));
}
