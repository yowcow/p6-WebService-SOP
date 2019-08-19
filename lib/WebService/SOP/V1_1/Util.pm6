use v6;
use JSON::Fast;
use Digest::HMAC;
use Digest::SHA;
use URI::Escape;

unit class WebService::SOP::V1_1::Util;

my \SIG_VALID_FOR_SEC = 10 * 60;

our sub stringify-params(%params --> Str) {
    %params.keys.sort.grep({ $_ !~~ m{^^ sop_ } })
        .map({

            die "Only Stringy or Numeric is acceptable for values { $_ } - { %params.perl } - { %params{$_}.perl }"
                if not (%params{$_} ~~ Stringy || %params{$_} ~~ Numeric);

            $_ ~ '=' ~ %params{$_}
        }).join('&');
}

multi sub create-signature(%params, Str $app_secret --> Str) is export {
    samewith(stringify-params(%params), $app_secret);
}

multi sub create-signature(Str $data, Str $app_secret --> Str) is export {
    hmac-hex($app_secret, $data, &sha256);
}

multi sub is-signature-valid(Str $sig, %params, Str $app_secret, Int $time = time --> Bool) is export {

    # `time` is mandatory
    return False if not %params<time>:exists;

    # `sig` is valid for SIG_VALID_FOR_SEC seconds
    return False if (%params<time> - $time).abs > SIG_VALID_FOR_SEC;

    create-signature(%params, $app_secret) eq $sig;
}

multi sub is-signature-valid(Str $sig, Str $json-str, Str $app_secret, Int $time = time --> Bool) is export {
    my %params = from-json($json-str);

    # `time` is mandatory
    return False if not %params<time>:exists;

    # `sig` is valid for SIG_VALID_FOR_SEC seconds
    return False if (%params<time> - $time).abs > SIG_VALID_FOR_SEC;

    create-signature($json-str, $app_secret) eq $sig;
}

sub build-query-string(%query! --> Str) is export {
    my Str @elements;
    my Sub $build-query = sub ($k, $v) {
        uri-escape($k) ~ '=' ~ uri-escape($v)
    }

    for %query.sort(*.key) -> (:$key, :$value) {
        given $value {
            when Hash {
                die "A Hash can't exist in value";
            }
            when Array {
                for |@$value -> $val {
                    @elements.push: $build-query($key, $val);
                }
            }
            default {
                @elements.push: $build-query($key, $value);
            }
        }
    }

    @elements.join('&');
}
