use strict;
use warnings;
use Test2::V0;

use Test2::Plugin::GitHub::Actions::AnnotateFailedTest;

is +Test2::Plugin::GitHub::Actions::AnnotateFailedTest::_escape_data("hoge\r\nfuga"), 'hoge%0D%0Afuga';

done_testing;
