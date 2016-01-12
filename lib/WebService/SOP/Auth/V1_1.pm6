use v6;
use URI;

unit class WebService::SOP::Auth::V1_1;

has Int $.app-id;
has Str $.app-secret;
has Int $.time = time;

submethod BUILD(Int:D :$!app-id, Str:D :$!app-secret, Int :$!time = time) {}

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
