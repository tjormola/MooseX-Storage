
package MooseX::Storage::Format::JSON;
use Moose::Role;

use JSON::Any;

requires 'pack';
requires 'unpack';

sub thaw {
    my ( $class, $json ) = @_;
    $class->unpack( JSON::Any->jsonToObj($json) );
}

sub freeze {
    my $self = shift;
    JSON::Any->objToJson( $self->pack() );
}

1;

__END__

=pod

=head1 NAME

MooseX::Storage::Format::JSON

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=over 4

=item B<freeze>

=item B<thaw ($json)>

=back

=head2 Introspection

=over 4

=item B<meta>

=back

=head1 BUGS

All complex software has bugs lurking in it, and this module is no 
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHOR

Chris Prather E<lt>chris.prather@iinteractive.comE<gt>

Stevan Little E<lt>stevan.little@iinteractive.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

