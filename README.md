# NAME

WWW::Sixpack - Perl client library for SeatGeek's Sixpack A/B testing framework http://sixpack.seatgeek.com/

# VERSION

Version 0.03

# SYNOPSIS

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

# SUBROUTINES/METHODS

## new

Constructs the WWW::Sixpack object. Options that can be passed in are:

- `host`

    The sixpack server (defaults to 'http://localhost:5000').

- `client_id`

    The client id if the "user" is known already. By default we generate a new UUID.

- `ua`

    The useragent to use (defaults to [LWP::UserAgent](http://search.cpan.org/perldoc?LWP::UserAgent)).

## participate

This function takes the following arguments:

Arguments:

- `experiment`

    The name of the experiment. This will generate a new experiment when the name is unknown.

- `alternatives`

    At least two alternatives.

- `options`

    An optional hashref with the following options:

    - `force`

        Force a specific alternative to be returned

    - `user_agent`

        User agent of the user making a request. Used for bot detection.

    - `ip_address`

        IP address of user making a request. Used for bot detection.

## convert

This function takes the following arguments:

Arguments:

- `experiment`

    The name of the experiment.

- `kpi`

    A KPI you wish to track. When the KPI is unknown, it will be created.

## \_get\_response

Internal method to fire the actual request and parse the result

# AUTHOR

Menno Blom, `<blom at cpan.org>`

# BUGS

Please report any bugs or feature requests to `bug-www-sixpack at rt.cpan.org`, or through
the web interface at [http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-Sixpack](http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-Sixpack).  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

# SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::Sixpack



You can also look for information at:

- RT: CPAN's request tracker (report bugs here)

    [http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-Sixpack](http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-Sixpack)

- AnnoCPAN: Annotated CPAN documentation

    [http://annocpan.org/dist/WWW-Sixpack](http://annocpan.org/dist/WWW-Sixpack)

- CPAN Ratings

    [http://cpanratings.perl.org/d/WWW-Sixpack](http://cpanratings.perl.org/d/WWW-Sixpack)

- Search CPAN

    [http://search.cpan.org/dist/WWW-Sixpack/](http://search.cpan.org/dist/WWW-Sixpack/)

# LICENSE AND COPYRIGHT

Copyright 2013 Menno Blom.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See [http://dev.perl.org/licenses/](http://dev.perl.org/licenses/) for more information.


