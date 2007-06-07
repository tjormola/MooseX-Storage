
package MooseX::Storage::Base::WithChecksum;
use Moose::Role;

use Digest       ();
use Data::Dumper ();

use MooseX::Storage::Engine;

our $VERSION = '0.01';

our $DIGEST_MARKER = '__DIGEST__';

sub pack {
    my ($self, @args ) = @_;

    my $e = MooseX::Storage::Engine->new( object => $self );

    my $collapsed = $e->collapse_object(@args);
    
    $collapsed->{$DIGEST_MARKER} = $self->_digest_packed($collapsed, @args);
    
    return $collapsed;
}

sub unpack {
    my ($class, $data, @args) = @_;

    # check checksum on data
    
    my $old_checksum = delete $data->{$DIGEST_MARKER};
    
    my $checksum = $class->_digest_packed($data, @args);

    ($checksum eq $old_checksum)
        || confess "Bad Checksum got=($checksum) expected=($old_checksum)";    

    my $e = MooseX::Storage::Engine->new(class => $class);
    $class->new($e->expand_object($data, @args));
}


sub _digest_packed {
    my ( $self, $collapsed, @args ) = @_;

    my $d = $self->_digest_object(@args);

    {
        local $Data::Dumper::Indent   = 0;
        local $Data::Dumper::Sortkeys = 1;
        $d->add( Data::Dumper::Dumper($collapsed) );
    }

    return $d->hexdigest;
}

sub _digest_object {
    my ( $self, %options ) = @_;
    my $digest_opts = $options{digest};
    
    $digest_opts = [ $digest_opts ] 
        if !ref($digest_opts) or ref($digest_opts) ne 'ARRAY';
        
    my ( $d, @args ) = @$digest_opts;

    if ( ref $d ) {
        if ( $d->can("clone") ) {
            return $d->clone;
        } 
        elsif ( $d->can("reset") ) {
            $d->reset;
            return $d;
        } 
        else {
            die "Can't clone or reset digest object: $d";
        }
    } 
    else {
        return Digest->new($d || "SHA1", @args);
    }
}

1;

__END__

=pod

=head1 NAME

MooseX::Storage::Base::WithChecksum

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=over 4

=item B<pack (?$salt)>

=item B<unpack ($data, ?$salt)>

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

Stevan Little E<lt>stevan.little@iinteractive.comE<gt>

Yuval Kogman

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
