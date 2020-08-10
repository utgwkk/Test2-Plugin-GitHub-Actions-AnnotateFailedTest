use strict;
use warnings;
use Test2::V0;

my $events = intercept {
    local $ENV{GITHUB_ACTIONS} = undef;
    require Test2::Plugin::GitHub::Actions::AnnotateFailedTest;
    Test2::Plugin::GitHub::Actions::AnnotateFailedTest->import;

    ok 0, 'failed';
};

is $events, array {
    fail_events 'Ok';
    end;
};

done_testing;
