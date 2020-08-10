use strict;
use warnings;
use Test2::V0;

my $events = intercept {
    local $ENV{GITHUB_ACTIONS} = 'true';
    require Test2::Plugin::GitHub::Actions::AnnotateFailedTest;
    Test2::Plugin::GitHub::Actions::AnnotateFailedTest->import;

    ok 1;
    is 1, 1;
    pass 'ok';
};

is $events, array {
    event 'Ok';
    event 'Ok';
    event 'Ok';
    end;
};

done_testing;
