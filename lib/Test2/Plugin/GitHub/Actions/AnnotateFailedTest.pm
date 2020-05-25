package Test2::Plugin::GitHub::Actions::AnnotateFailedTest;
use strict;
use warnings;
use feature qw(state);

use Encode qw(encode_utf8);
use Test2::API qw(
    test2_add_callback_post_load
    test2_stack
    test2_stderr
);
use URI::Escape qw(uri_escape);

our $VERSION = "0.01";

sub import {
    my ($class) = @_;

    return unless $ENV{GITHUB_ACTIONS};
    state $loaded = 0; # avoid multiple callback addition
    return if $loaded;
    $loaded++;

    test2_add_callback_post_load(sub {
        my $hub = test2_stack()->top;
        $hub->listen(\&listener, inherit => 1);
    });
}

sub listener {
    my ($hub, $event) = @_;

    return unless $event->causes_fail;

    my $trace = $event->trace;
    my $file = $trace->file // '<no name>';
    my $line = $trace->line // 0;
    my $detail = encode_utf8 $event->summary; # avoid Wide character in print warning

    my $stderr = test2_stderr();

    if (length $detail) {
        $stderr->printf("::error file=%s,line=%d::%s\n", $file, $line, _escape_data($detail));
    } else {
        $stderr->printf("::error file=%s,line=%d\n", $file, $line);
    }
}

# escape a message of workflow command.
# see also: https://github.com/actions/toolkit/blob/30e0a77337213de5d4e158b05d1019c6615f69fd/packages/core/src/command.ts#L92-L97
sub _escape_data {
    my ($msg) = @_;
    return uri_escape($msg, "%\r\n");
}

1;
__END__

=encoding utf-8

=head1 NAME

Test2::Plugin::GitHub::Actions::AnnotateFailedTest - It's new $module

=head1 SYNOPSIS

    use Test2::Plugin::GitHub::Actions::AnnotateFailedTest;

=head1 DESCRIPTION

Test2::Plugin::GitHub::Actions::AnnotateFailedTest is ...

=head1 LICENSE

Copyright (C) utgwkk.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

utgwkk E<lt>utagawakiki@gmail.comE<gt>

=cut

