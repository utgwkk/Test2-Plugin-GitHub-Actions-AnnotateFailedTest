use strict;
use warnings;
use Test2::V0;
use Module::Spy qw(spy_on);

use Test2::Plugin::GitHub::Actions::AnnotateFailedTest;

my $file = __FILE__;
my $line;

my $g = spy_on('Test2::Plugin::GitHub::Actions::AnnotateFailedTest', '_issue_error');

my $event = intercept {
    local $ENV{GITHUB_ACTIONS} = 'true';
    require Test2::Plugin::GitHub::Actions::AnnotateFailedTest;
    Test2::Plugin::GitHub::Actions::AnnotateFailedTest->import;

    $line = __LINE__ + 1;
    is 0, -1, 'not equal';
};
my $call = $g->calls_most_recent;
pop @$call; # pop the last arg $file_context
undef $g;

my $fail = $event->[0];

my $message = length $fail->{info}->[0]->{details} ? "not equal\n" . $fail->{info}->[0]->{details} : 'not equal';

is $call, [$file, $line, $message], 'annotate with details';

done_testing;
