use strict;
use warnings;
use Test2::V0;
use Test2::Plugin::IOEvents;
use Test2::API qw(test2_reset_io);
test2_reset_io();

my $file = __FILE__;
my $line;

my $events = intercept {
    local $ENV{GITHUB_ACTIONS} = 'true';
    require Test2::Plugin::GitHub::Actions::AnnotateFailedTest;
    Test2::Plugin::GitHub::Actions::AnnotateFailedTest->import;

    $line = __LINE__ + 1;
    ok 0, 'failed';
};

is $events, array {
    event 'Ok';
    event Output => sub {
        field stream_name => 'STDERR';
        call message => "::error file=$file,line=$line\::failed\n";
    };
    event 'Diag';
    end;
};

done_testing;
