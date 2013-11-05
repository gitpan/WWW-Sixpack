package WWW::Sixpack;

use 5.006;
use strict;
use warnings FATAL => 'all';

use Carp qw( croak );
use Data::UUID;
use JSON::Any;
use LWP::UserAgent;
use URI;

our $VALID_NAME_RE = qr/^[a-z0-9][a-z0-9\-_ ]*$/;

=head1 NAME

WWW::Sixpack - Perl client library for SeatGeek's Sixpack A/B testing framework http://sixpack.seatgeek.com/

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';

=head1 SYNOPSIS

    use WWW::Sixpack;

    my $sixpack = WWW::Sixpack->new();

    # Participate in a test (creates the test if necessary)
    my $alternative = $sixpack->participate('new-test', [ 'alt-1', 'alt-2' ],
        { ip_address => $client_ip, user_agent => $client_ua });

    if( $alternative->{alternative}{name} eq 'alt-1' ) {
        # show data for variant alt-1
    } else {
        # show data for variant alt-2

    }

    # Convert
    $sixpack->convert('new-test')

=head1 SUBROUTINES/METHODS

=head2 new

Constructs the WWW::Sixpack object. Options that can be passed in are:

=over 4

=item C<host>

The sixpack server (defaults to 'http://localhost:5000').

=item C<client_id>

The client id if the "user" is known already. By default we generate a new UUID.

=item C<ua>

The useragent to use (defaults to L<LWP::UserAgent>).

=back

=cut

sub new {
    my ($class, %args) = @_;
    my $self = {
        host      => 'http://localhost:5000',
        ua        => LWP::UserAgent->new,
        json      => JSON::Any->new,
        client_id => Data::UUID->new->create_str,
        %args,
    };
    bless $self, $class;
}

=head2 participate

This function takes the following arguments:

Arguments:

=over 4

=item C<experiment>

The name of the experiment. This will generate a new experiment when the name is unknown.

=item C<alternatives>

At least two alternatives.

=item C<options>

An optional hashref with the following options:

=over 4

=item C<force>

Force a specific alternative to be returned

=item C<user_agent>

User agent of the user making a request. Used for bot detection.

=item C<ip_address>

IP address of user making a request. Used for bot detection.

=back

=back

=cut

sub participate {
    my ($self, $experiment, $alternatives, $options) = @_;

    croak('Bad experiment name')
        if( $experiment !~ m/$VALID_NAME_RE/ );
    croak('Must specify at least 2 alternatives')
        if( !$alternatives || !ref $alternatives ||
            ref $alternatives ne 'ARRAY' || @$alternatives < 2 );

    for my $alt (@{$alternatives}) {
        croak('Bad alternative name: '.$alt) if( $alt !~ m/$VALID_NAME_RE/ );
    }

    $options ||= { };

    my %params = (
        client_id    => $self->{client_id},
        experiment   => $experiment,
        alternatives => $alternatives,
        %{$options}
    );

    return $self->_get_response('/participate', \%params);
}

=head2 convert

This function takes the following arguments:

Arguments:

=over 4

=item C<experiment>

The name of the experiment.

=item C<kpi>

A KPI you wish to track. When the KPI is unknown, it will be created.

=back

=cut

sub convert {
    my ($self, $experiment, $kpi) = @_;

    croak('Bad experiment name')
        if( $experiment !~ m/$VALID_NAME_RE/ );

    my %params = (
        client_id    => $self->{client_id},
        experiment   => $experiment,
    );

    if( $kpi ) {
        croak('Bad KPI name')
            if( $kpi !~ m/$VALID_NAME_RE/ );
        $params{kpi} = $kpi;
    }

    return $self->_get_response('/convert', \%params);

}

=head2 _get_response

Internal method to fire the actual request and parse the result

=cut

sub _get_response {
    my ($self, $endpoint, $params) = @_;

    my $uri = URI->new($self->{host});
       $uri->path($endpoint);
       $uri->query_form( $params );

    my $resp = $self->{ua}->get( $uri );
    my $json = ( $resp->is_success )
             ? $resp->content
             : '{"status": "failed", "response": "http error: sixpack is unreachable"}';

    return $self->{json}->jsonToObj( $json );
}

=head1 AUTHOR

Menno Blom, C<< <blom at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-www-sixpack at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-Sixpack>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::Sixpack


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-Sixpack>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-Sixpack>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-Sixpack>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-Sixpack/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Menno Blom.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.


=cut

1; # End of WWW::Sixpack
