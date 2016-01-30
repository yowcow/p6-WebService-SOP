use v6;
use URI;
use WebService::SOP::Auth::V1_1::Request::GET;
use WebService::SOP::Auth::V1_1::Request::POST;
use WebService::SOP::Auth::V1_1::Request::POST_JSON;

unit class WebService::SOP::Auth::V1_1;

has Int $!app-id;
has Str $!app-secret;
has Int $!time;

submethod BUILD(Int:D :$!app-id, Str:D :$!app-secret, Int :$!time = time) {}

method get($uri, Hash:D $params --> HTTP::Request) {
    self.create-request('GET', $uri, $params);
}

method post($uri, Hash:D $params --> HTTP::Request) {
    self.create-request('POST', $uri, $params);
}

method post-json($uri, Hash:D $params --> HTTP::Request) {
    self.create-request('POST_JSON', $uri, $params);
}

multi method create-request(Str:D $method, Str:D $uri, Hash:D $params --> HTTP::Request) {
    samewith($method, URI.new($uri), $params);
}

multi method create-request(Str:D $method, URI:D $uri, Hash:D $params is copy --> HTTP::Request) {

    $params<app_id> = $!app-id;
    $params<time>   = $!time;

    ::("WebService::SOP::Auth::V1_1::Request::{$method}").create-request(
        uri        => $uri,
        params     => $params,
        app-secret => $!app-secret,
    );
}

=begin pod

=head1 NAME

WebService::SOP::Auth::V1_1 - blah blah blah

=head1 SYNOPSIS

  use WebService::SOP::Auth::V1_1;

=head1 DESCRIPTION

WebService::SOP::Auth::V1_1 is ...

=head1 AUTHOR

yowcow <yowcow@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright 2016 yowcow

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
