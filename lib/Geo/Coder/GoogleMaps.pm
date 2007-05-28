package Geo::Coder::GoogleMaps;

use warnings;
use strict;
use Carp;
use Encode;
use JSON::Syck;
use HTTP::Request;
use LWP::UserAgent;
use URI;
use XML::LibXML ;
use Geo::Coder::GoogleMaps::Location;

=head1 NAME

Geo::Coder::GoogleMaps - Google Maps Geocoding API

=head1 VERSION

Version 0.1

=cut

our $VERSION = '0.1';

=head1 SYNOPSIS

This module provide Google Maps API. Please note that this module use Tatsuhiko Miyagawa's work on Geo::Coder::Google as base (L<http://search.cpan.org/~miyagawa/>).

In fact it's a fork of Mr Miyagawa's module. Geo::Coder::GoogleMaps use the default JSON data type as default output but also support XML/KML.

The direct output of the geocode() method is now a Geo::Coder::GoogleMaps::Location object which can be exported to any of the supported format.


	use Geo::Coder::GoogleMaps;
	
	my $gmap = Geo::Coder::GoogleMaps->new( apikey => 'abcd' , output => 'xml');
	my $location = $gmap->geocode(location => '88 rue du chateau, 92600, Asnières sur seine, France');
	
	print $location->latitude,',',$location->longitude,"\n";
	
	$location->toKML()->toString(); # is absolutly equivalent to $location->toKML(1);
	

=head1 FUNCTIONS

=head2 new

=cut


sub new {
	my($class, %param) = @_;
	
	my $key = delete $param{apikey}
		or Carp::croak("Usage: new(apikey => \$apikey)");
	
	my $ua   = delete $param{ua}   || LWP::UserAgent->new(agent => __PACKAGE__ . "/$VERSION");
	my $host = delete $param{host} || 'maps.google.com';
	my $output = delete $param{output} || 'json';
	
	bless { key => $key, ua => $ua, host => $host, output => $output }, $class;
}

=head2 geocode

=cut

sub geocode {
	my $self = shift;
	
	my %param;
	if (@_ % 2 == 0) {
		%param = @_;
	} else {
		$param{location} = shift;
	}
	
	my $location = $param{location}
		or Carp::croak("Usage: geocode(location => \$location)");
	
	if (Encode::is_utf8($location)) {
		$location = Encode::encode_utf8($location);
	}
	
	my $uri = URI->new("http://$self->{host}/maps/geo");
	$uri->query_form(q => $location, key => $self->{key});
# 	$uri->query_form(q => $location, output => $self->{output}, key => $self->{key});
	
	my $res = $self->{ua}->get($uri);
	
	if ($res->is_error) {
		Carp::croak("Google Maps API returned error: " . $res->status_line);
	}
	
	# Ugh, Google Maps returns so stupid HTTP header
	# Content-Type: text/javascript; charset=UTF-8; charset=Shift_JIS
	my @ctype = $res->content_type;
	my $charset = ($ctype[1] =~ /charset=([\w\-]+)$/)[0] || "utf-8";
	
	my $content = Encode::decode($charset, $res->content);
# 	if ($self->{output} eq 'json'){
		local $JSON::Syck::ImplicitUnicode = 1;
		my $data = JSON::Syck::Load($content);
		
		my @placemark=();
		foreach my $Placemark (@{$data->{Placemark}}){
			my $loc = Geo::Coder::GoogleMaps::Location->new(output => $self->{output});
			$loc->_setData($Placemark);
			push @placemark, $loc;
		}
		wantarray ? @placemark : $placemark[0];
# 	}
# 	elsif ($self->{output} eq 'xml' || $self->{output} eq 'kml'){
# 		my $parser = new XML::LibXML;
# 		my $document = $parser->parse_string( $content );
# # 		my ($kml) = $document->getChildren
# 	}
}

1;
__END__

=head1 AUTHOR

Arnaud DUPUIS, C<< <a.dupuis at nabladev.com> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-geo-coder-googlemaps at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Geo-Coder-GoogleMaps>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Geo::Coder::GoogleMaps

You can also look for information at:

=over 4

=item * Nabla Development: http://www.nabladev.com and http://opensource.nabladev.com

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Geo-Coder-GoogleMaps>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Geo-Coder-GoogleMaps>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Geo-Coder-GoogleMaps>

=item * Search CPAN

L<http://search.cpan.org/dist/Geo-Coder-GoogleMaps>

=back

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2007 Arnaud DUPUIS and Nabla Development, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Geo::Coder::GoogleMaps
