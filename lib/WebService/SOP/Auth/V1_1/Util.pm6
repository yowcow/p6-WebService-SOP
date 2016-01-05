use v6;
use Digest::HMAC;
use Digest::SHA;
use WebService::SOP::Auth::V1_1::X;

unit class WebService::SOP::Auth::V1_1::Util;

my \SIG_VALID_FOR_SEC = 10 * 60;

method stringify-params(%params --> Str) {
    %params.keys.sort.grep({ $_ !~~ m{^^ sop_ } })
        .map({

            WebService::SOP::Auth::V1_1::X.new(
                reason => "Only Stringy or Numeric is acceptable for values"
            ).throw if not (%params{$_} ~~ Stringy || %params{$_} ~~ Numeric);

            $_ ~ '=' ~ %params{$_}
        }).join('&');
}

multi method create-signature(%params, Str $app_secret --> Str) {
    self.create-signature(self.stringify-params(%params), $app_secret);
}

multi method create-signature(Str $data, Str $app_secret --> Str) {
    hmac-hex($app_secret, $data, &sha256);
}

multi method is-signature-valid(Str $sig, %params, Str $app_secret, Int $time = time --> Bool) {

    # `time` is mandatory
    return False if not %params<time>:exists;

    # `sig` is valid for SIG_VALID_FOR_SEC seconds
    return False if (%params<time> - $time).abs > SIG_VALID_FOR_SEC;

    self.create-signature(%params, $app_secret) eq $sig;
}

multi method is-signature-valid(Str $sig, Str $json-str, Str $app_secret, Int $time = time --> Bool) {
    my %params = from-json($json-str);

    # `time` is mandatory
    return False if not %params<time>:exists;

    # `sig` is valid for SIG_VALID_FOR_SEC seconds
    return False if (%params<time> - $time).abs > SIG_VALID_FOR_SEC;

    self.create-signature($json-str, $app_secret) eq $sig;
}
