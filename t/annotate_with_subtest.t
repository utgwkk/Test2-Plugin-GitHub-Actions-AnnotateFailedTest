use strict;
use warnings;
use Test2::V0;
use Module::Spy qw(spy_on);

my $file = __FILE__;
my ($subtest_line, $assertion_line);

my $g = spy_on('Test2::Plugin::GitHub::Actions::AnnotateFailedTest', '_issue_error');

my $event = intercept {
    local $ENV{GITHUB_ACTIONS} = 'true';
    require Test2::Plugin::GitHub::Actions::AnnotateFailedTest;
    Test2::Plugin::GitHub::Actions::AnnotateFailedTest->import;

    subtest 'in subtest' => sub {
        $assertion_line = __LINE__ + 1;
        ok 0, 'failed';
        $subtest_line = __LINE__ + 1;
    };
};
my $calls = $g->calls_all;
undef $g;

like $event, array {
    item event Subtest => sub {
        call subevents => array {
            item event 'Ok';
            etc;
        };
    };
};

is $calls, [
    [$file, $assertion_line, 'failed'],
    [$file, $subtest_line, 'in subtest'],
], 'annotate with failure and failed subtest';

done_testing;
