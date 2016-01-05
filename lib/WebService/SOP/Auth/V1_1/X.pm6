use v6;

unit class WebService::SOP::Auth::V1_1::X is Exception;

has $.reason;

method message(--> Str) { "Error: $.reason" }
