use v6;
use lib 'lib';
use Test;
use WebService::SOP::Auth::V1_1::Util;

my Str $class = 'WebService::SOP::Auth::V1_1::Util';

subtest {

    is ::($class).stringify-params({
        "zzz" => "zzz",
        "yyy" => "yyy",
        "xxx" => "xxx",
    }), 'xxx=xxx&yyy=yyy&zzz=zzz';

    is ::($class).stringify-params({
        "sop_hoge" => "hoge",
        "zzz" => "zzz",
        "yyy" => "yyy",
        "xxx" => "xxx",
    }), 'xxx=xxx&yyy=yyy&zzz=zzz';

    dies-ok {
        ::($class).stringify-params({
            "xxx" => {
                "yyy" => "yyy",
            },
        })
    }, 'Structured data dies';

}, 'Test stringify-params';

subtest {

    subtest {
        is ::($class).create-signature(
            {   "ccc" => "ccc",
                "bbb" => "bbb",
                "aaa" => "aaa",
            },
            "hogehoge"
        ), '2fbfe87e54cc53036463633ef29beeaa4d740e435af586798917826d9e525112';

        is ::($class).create-signature(
            {   "ccc"      => "ccc",
                "bbb"      => "bbb",
                "aaa"      => "aaa",
                "sop_hoge" => "hoge",
            },
            "hogehoge"
        ), '2fbfe87e54cc53036463633ef29beeaa4d740e435af586798917826d9e525112';

    }, '1st param isa Hash';

    subtest {
        is ::($class).create-signature(
            '{"hoge":"fuga"}',
            "hogehoge"
        ), 'dc76e675e2bcabc31182e33506f5b01ea7966a9c0640d335cc6cc551f0bb1bba';

    }, '1st param isa Str';

}, 'Test create-signature';

subtest {

    subtest {
        my %params = "hoge" => "hoge";
        my Str $sig = ::($class).create-signature(%params, "hogehoge");

        ok !::($class).is-signature-valid($sig, %params, "hogehoge");

    }, 'No `time` in params';

    subtest {
        my $time   = time;
        my %params = "hoge" => "hoge",
                     "time" => $time - 601;
        my Str $sig = ::($class).create-signature(%params, "hogehoge");

        ok !::($class).is-signature-valid($sig, %params, "hogehoge", $time);

    }, '`time` is too old';

    subtest {
        my $time   = time;
        my %params = "hoge" => "hoge",
                     "time" => $time - 600;
        my Str $sig = ::($class).create-signature(%params, "hogehoge");

        ok ::($class).is-signature-valid($sig, %params, "hogehoge", $time);

    }, 'Valid';

    subtest {
        my $time   = time;
        my %params = "hoge" => "hoge",
                     "time" => $time + 600;
        my Str $sig = ::($class).create-signature(%params, "hogehoge");

        ok ::($class).is-signature-valid($sig, %params, "hogehoge", $time);

    }, 'Valid';

    subtest {
        my $time   = time;
        my %params = "hoge" => "hoge",
                     "time" => $time + 601;
        my Str $sig = ::($class).create-signature(%params, "hogehoge");

        ok !::($class).is-signature-valid($sig, %params, "hogehoge", $time);

    }, '`time` is too new';

}, 'Test is-signature-valid on Hash';

subtest {

    subtest {
        my Str $json = to-json({ hoge => 'fuga' });
        my Str $sig  = ::($class).create-signature($json, "hogehoge");

        ok !::($class).is-signature-valid($sig, $json, "hogehoge");

    }, 'No `time` in JSON';

    subtest {
        my Int $time = time;
        my Str $json = to-json({
            hoge => 'hoge',
            time => $time - 601
        });
        my Str $sig = ::($class).create-signature($json, "hogehoge");

        ok !::($class).is-signature-valid($sig, $json, 'hogehoge', $time);

    }, '`time` is too old';

    subtest {
        my Int $time = time;
        my Str $json = to-json({
            hoge => 'hoge',
            time => $time - 600
        });
        my Str $sig = ::($class).create-signature($json, "hogehoge");

        ok ::($class).is-signature-valid($sig, $json, 'hogehoge', $time);

    }, '`time` is valid';

    subtest {
        my Int $time = time;
        my Str $json = to-json({
            hoge => 'hoge',
            time => $time + 600
        });
        my Str $sig = ::($class).create-signature($json, "hogehoge");

        ok ::($class).is-signature-valid($sig, $json, 'hogehoge', $time);

    }, '`time` is valid';

    subtest {
        my Int $time = time;
        my Str $json = to-json({
            hoge => 'hoge',
            time => $time + 601
        });
        my Str $sig = ::($class).create-signature($json, "hogehoge");

        ok !::($class).is-signature-valid($sig, $json, 'hogehoge', $time);

    }, '`time` is too new';

}, 'Test is-signature-valid on JSON';

done-testing;
