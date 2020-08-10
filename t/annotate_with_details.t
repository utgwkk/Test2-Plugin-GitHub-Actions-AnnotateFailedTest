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
    is 0, -1, 'not equal';
};

my $fail = $events->[0];
my $raw_message = length $fail->{info}->[0]->{details} ? "not equal\n" . $fail->{info}->[0]->{details} : 'not equal';
my $message = "::error file=$file,line=$line\::" . Test2::Plugin::GitHub::Actions::AnnotateFailedTest::_escape_data($raw_message) . "\n";

is $events, array {
    event 'Fail';
    event Output => sub {
        field stream_name => 'STDERR';
        call message => $message;
    };
    end;
};

done_testing;
