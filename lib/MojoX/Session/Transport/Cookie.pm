package MojoX::Session::Transport::Cookie;

use strict;
use warnings;

use base 'MojoX::Session::Transport';

use Mojo::Cookie::Request;
use Mojo::Cookie::Response;

__PACKAGE__->attr('tx', chained => 1);
__PACKAGE__->attr('name', default => 'sid', chained => 1);

sub get {
    my ($self) = @_;

    my $cookies = $self->tx->req->cookies;
    return unless $cookies;

    my $sid;
    foreach my $cookie (@$cookies) {
        last if ($sid = $cookie->name($self->name)->value);
    }

    return $sid;
}

sub set {
    my ($self, $sid, $expires) = @_;

    my $cookie = Mojo::Cookie::Response->new();
    $cookie->name($self->name)->value($sid);
    $cookie->expires($expires);

    $self->tx->res->cookies($cookie);
}

1;
__END__

=head1 NAME

MojoX::Session::Transport::Cookie - Cookie Transport for MojoX::Session

=head1 SYNOPSIS

    my $session = MojoX::Session->new(
        transport => MojoX::Session::Transport::Cookie->new(tx => $tx),
        ...
    );

=head1 DESCRIPTION

L<MojoX::Session::Transport::Cookie> is a transport for L<MojoX::Session> that
gets and sets session id to and from cookies.

=head1 ATTRIBUTES

L<MojoX::Session::Transport::Cookie> implements the following attributes.

=head2 C<tx>
    
    my $tx = $transport->tx;
    $transport = $transport->tx($tx);

Get and set L<Mojo::Transaction> object.

=head1 METHODS

L<MojoX::Session::Transport::Cookie> inherits all methods from
L<MojoX::Session::Transport>.

=head2 C<get>

Get session id from request cookie.

=head2 C<set>

Set session id to the response cookie.

=head1 AUTHOR

vti, C<vti@cpan.org>.

=head1 COPYRIGHT

Copyright (C) 2008, Viacheslav Tikhanovskii.

This program is free software, you can redistribute it and/or modify it under
the same terms as Perl 5.10.

=cut