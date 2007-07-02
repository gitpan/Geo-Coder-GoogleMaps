package Geo::Coder::GoogleMaps::Location ;

use strict;
use warnings;
use strict;
use Carp;
use JSON::Syck;
use XML::LibXML;

our $VERSION='0.2';

=head1 NAME

Geo::Coder::GoogleMaps::Location - Geo::Coder::GoogleMaps' Location object

=head1 VERSION

Version 0.2 (follow Geo::Coder::Google version number)

=head1 SYNOPSIS

Here we have the object returned by Geo::Coder::GoogleMaps->geocode()

=head1 FUNCTIONS

=head2 new

The constructor can take the following arguments :

	- SubAdministrativeAreaName : a string
	- PostalCodeNumber : a postal code (err...)
	- LocalityName : yes! A locality name !
	- ThoroughfareName: same thing => a string
	- AdministrativeAreaName
	- CountryNameCode
	- address
	- longitude
	- latitude
	- altitude (warning in Google Map API altitude must be 0)

=cut

sub new {
	my($class, %param) = @_;
	my $obj = {
		'AddressDetails' => {
			'Country' => {
				'AdministrativeArea' => {
					'SubAdministrativeArea' => {
						'SubAdministrativeAreaName' => delete $param{'SubAdministrativeAreaName'} || '',
						'Locality' => {
							'PostalCode' => {
								'PostalCodeNumber' => delete $param{'PostalCodeNumber'} || ''
							},
							'LocalityName' => delete $param{'LocalityName'} || '',
							'Thoroughfare' => {
								'ThoroughfareName' => delete $param{'ThoroughfareName'} || ''
							}
						}
					},
					'AdministrativeAreaName' => delete $param{'AdministrativeAreaName'} || ''
				},
				'CountryNameCode' => delete $param{'CountryNameCode'} || ''
			}
		},
		'address' => delete $param{'address'} || '',
		'Point' => {
			'coordinates' => [
				delete $param{'longitude'} || '',
				delete $param{'latitude'} || '',
				delete $param{'altitude'} || 0
			]
		}
	};
	my $out = delete $param{'output'} || 'json';
	bless { data => $obj, output => $out }, $class;
}

=head2 SubAdministrativeAreaName

Access the SubAdministrativeAreaName parameter.

	print $location->SubAdministrativeAreaName(); # retrieve the value
	$location->SubAdministrativeAreaName("Paris"); # set the value

=cut

sub SubAdministrativeAreaName {
	my ($self,$data) = @_ ;
	return $data ? $self->{data}->{'AddressDetails'}->{'Country'}->{'AdministrativeArea'}->{'SubAdministrativeArea'}->{'SubAdministrativeAreaName'}=$data : $self->{data}->{'AddressDetails'}->{'Country'}->{'AdministrativeArea'}->{'SubAdministrativeArea'}->{'SubAdministrativeAreaName'} ;
}

=head2 PostalCodeNumber

Access the PostalCodeNumber parameter.

	print $location->PostalCodeNumber(); # retrieve the value
	$location->PostalCodeNumber("75000"); # set the value

=cut

sub PostalCodeNumber {
	my ($self,$data) = @_ ;
	return $data ? $self->{data}->{'AddressDetails'}->{'Country'}->{'AdministrativeArea'}->{'SubAdministrativeArea'}->{'Locality'}->{'PostalCode'}->{'PostalCodeNumber'}=$data : $self->{data}->{'AddressDetails'}->{'Country'}->{'AdministrativeArea'}->{'SubAdministrativeArea'}->{'Locality'}->{'PostalCode'}->{'PostalCodeNumber'} ;
}

=head2 ThoroughfareName

Access the ThoroughfareName parameter.

	print $location->ThoroughfareName(); # retrieve the value
	$location->ThoroughfareName("1 Avenue des Champs Élysées"); # set the value

=cut

sub ThoroughfareName {
	my ($self,$data) = @_ ;
	return $data ? $self->{data}->{'AddressDetails'}->{'Country'}->{'AdministrativeArea'}->{'SubAdministrativeArea'}->{'Locality'}->{'Thoroughfare'}->{'ThoroughfareName'}=$data : $self->{data}->{'AddressDetails'}->{'Country'}->{'AdministrativeArea'}->{'SubAdministrativeArea'}->{'Locality'}->{'Thoroughfare'}->{'ThoroughfareName'} ;
}

=head2 LocalityName

Access the LocalityName parameter.

	print $location->LocalityName(); # retrieve the value
	$location->LocalityName("Paris"); # set the value

=cut

sub LocalityName {
	my ($self,$data) = @_ ;
	return $data ? $self->{data}->{'AddressDetails'}->{'Country'}->{'AdministrativeArea'}->{'SubAdministrativeArea'}->{'Locality'}->{'LocalityName'}=$data : $self->{data}->{'AddressDetails'}->{'Country'}->{'AdministrativeArea'}->{'SubAdministrativeArea'}->{'Locality'}->{'LocalityName'} ;
}

=head2 AdministrativeAreaName

Access the AdministrativeAreaName parameter.

	print $location->AdministrativeAreaName(); # retrieve the value
	$location->AdministrativeAreaName("PA"); # set the value

=cut

sub AdministrativeAreaName {
	my ($self,$data) = @_ ;
	return $data ? $self->{data}->{'AddressDetails'}->{'Country'}->{'AdministrativeArea'}->{'AdministrativeAreaName'}=$data : $self->{data}->{'AddressDetails'}->{'Country'}->{'AdministrativeArea'}->{'AdministrativeAreaName'} ;
}

=head2 CountryNameCode

Access the CountryNameCode parameter.

	print $location->CountryNameCode(); # retrieve the value
	$location->CountryNameCode("FR"); # set the value

=cut

sub CountryNameCode {
	my ($self,$data) = @_ ;
	return $data ? $self->{data}->{'AddressDetails'}->{'Country'}->{'CountryNameCode'}=$data : $self->{data}->{'AddressDetails'}->{'Country'}->{'CountryNameCode'} ;
}

=head2 Accuracy

Access the Accuracy parameter.

	print $location->Accuracy(); # retrieve the value
	$location->Accuracy(8); # set the value

=cut

sub Accuracy {
	my ($self,$data) = @_ ;
	return $data ? $self->{data}->{'AddressDetails'}->{'Accuracy'}=$data : $self->{data}->{'AddressDetails'}->{'Accuracy'} ;
}

=head2 address

Access the address parameter.

	print $location->address(); # retrieve the value
	$location->address("1 Avenue des Champs Élysées, 75000, Paris, FR"); # set the value

=cut

sub address {
	my ($self,$data) = @_ ;
	return $data ? $self->{data}->{'address'}=$data : $self->{data}->{'address'} ;
}

=head2 id

Access the id parameter.

	print $location->id(); # retrieve the value
	$location->id("point1"); # set the value

=cut

sub id {
	my ($self,$data) = @_ ;
	return $data ? $self->{data}->{'id'}=$data : $self->{data}->{'id'} ;
}

=head2 latitude

Access the latitude parameter.

	print $location->latitude(); # retrieve the value
	$location->latitude("-122.4558"); # set the value

=cut

sub latitude {
	my ($self,$data) = @_ ;
	return $data ? $self->{data}->{'Point'}->{'coordinates'}->[1]=$data : $self->{data}->{'Point'}->{'coordinates'}->[1] ;
}


=head2 longitude

Access the longitude parameter.

	print $location->longitude(); # retrieve the value
	$location->longitude("55.23465"); # set the value

=cut

sub longitude {
	my ($self,$data) = @_ ;
	return $data ? $self->{data}->{'Point'}->{'coordinates'}->[0]=$data : $self->{data}->{'Point'}->{'coordinates'}->[0] ;
}

=head2 altitude

Access the altitude parameter.

	print $location->altitude(); # retrieve the value
	$location->altitude(0); # set the value

Please note that it must be 0 if you use the Google Map API.

=cut

sub altitude {
	my ($self,$data) = @_ ;
	return $data ? $self->{data}->{'Point'}->{'coordinates'}->[2]=$data : $self->{data}->{'Point'}->{'coordinates'}->[2] ;
}

=head2 coordinates

This method is not really an accessor, it's only a getter which return longitude, latitude and altitude as a string.

	print "Placemark's coordinates",$location->coordinates,"\n";

=cut

sub coordinates {
	my $self = shift;
	return $self->longitude().','.$self->latitude().','.$self->altitude ;
}

=head2 toJSON

Return a JSON encoded object ( thanks to JSON::Syck::Dump() )

	my $json = $location->toJSON ;

=cut

sub toJSON {
	my $self = shift;
	return JSON::Syck::Dump($self->{'data'}) ;
}

=head2 toKML

Return a KML object ( thanks to XML::LibXML ).

	my $kml = $location->toXML ;

Please note that this function can take an optionnal argument (0 or 1) and if it's set to 1 this method return a XML string instead of the XML::LibXML::Document object.

=cut

# sub toKML {
# 	my $self = shift;
# 	my $as_string = shift;
# 	my $document = XML::LibXML::Document->createDocument( "1.0", "UTF-8" );
# 	$document->setStandalone(1);
# 	my $kml = $document->createElement('kml');
# 	$kml->setNamespace("http://earth.google.com/kml/2.1", '',0);
# 	$document->setDocumentElement($kml);
# 	my $placemark = $document->createElement('Placemark');
# 	$kml->appendChild($placemark);
# 	
# 	my $address = $document->createElement('address');
# 	$address->appendText($self->address);
# 	$placemark->appendChild($address);
# 	
# 	my $AddressDetails = $document->createElement('AddressDetails');
# 	$placemark->appendChild($AddressDetails);
# 	
# 	my $Country = $document->createElement('Country');
# 	$AddressDetails->appendChild($Country);
# 	
# 	my $CountryNameCode = $document->createElement('CountryNameCode');
# 	$CountryNameCode->appendText($self->CountryNameCode);
# 	$Country->appendChild($CountryNameCode);
# 	
# 	my $AdministrativeArea = $document->createElement('AdministrativeArea');
# 	$Country->appendChild($AdministrativeArea);
# 	
# 	my $AdministrativeAreaName = $document->createElement('AdministrativeAreaName');
# 	$AdministrativeAreaName->appendText($self->AdministrativeAreaName);
# 	$AdministrativeArea->appendChild($AdministrativeAreaName);
# 	
# 	my $SubAdministrativeArea = $document->createElement('SubAdministrativeArea');
# 	$AdministrativeArea->appendChild($SubAdministrativeArea);
# 	my $SubAdministrativeAreaName = $document->createElement('SubAdministrativeAreaName');
# 	$SubAdministrativeAreaName->appendText($self->SubAdministrativeAreaName);
# 	$SubAdministrativeArea->appendChild($SubAdministrativeAreaName);
# 	my $Locality = $document->createElement('Locality');
# 	$SubAdministrativeArea->appendChild($Locality);
# 	my $LocalityName = $document->createElement('LocalityName');
# 	$LocalityName->appendText($self->LocalityName);
# 	$Locality->appendChild($LocalityName);
# 	my $PostalCode = $document->createElement('PostalCode');
# 	$Locality->appendChild($PostalCode);
# 	my $PostalCodeNumber = $document->createElement('PostalCodeNumber');
# 	$PostalCodeNumber->appendText($self->PostalCodeNumber);
# 	$PostalCode->appendChild($PostalCodeNumber);
# 	my $Thoroughfare = $document->createElement('Thoroughfare');
# 	$Locality->appendChild($Thoroughfare);
# 	my $ThoroughfareName = $document->createElement('ThoroughfareName');
# 	$ThoroughfareName->appendText($self->ThoroughfareName);
# 	$Thoroughfare->appendChild($ThoroughfareName);
# 	my $Point = $document->createElement('Point');
# 	$placemark->appendChild($Point);
# 	my $coordinates = $document->createElement('coordinates');
# 	$Point->appendChild($coordinates);
# 	$coordinates->appendText($self->longitude().','.$self->latitude().','.$self->altitude);
# 	
# 	
# 	$document->setEncoding("UTF-8");
# 	return $document->toString(1) if($as_string);
# 	return $document;
# }

sub toKML {
	sub _toKMLinternal {
		my $self = shift;
		my $document = shift;
		my $xml_element = shift;
		my $root = shift;
		return unless($root);
		foreach my $key (keys(%{$root})){
			my $new_element = $document->createElement($key);
			if( $self->can($key) ){
				if(defined($self->$key)){
					$new_element->appendText($self->$key);
					$xml_element->appendChild($new_element);
				}
			}
			else{
				if($key eq 'AddressDetails'){
					$new_element->setNamespace("urn:oasis:names:tc:ciq:xsdschema:xAL:2.0", '',0);
				}
				$xml_element->appendChild($new_element);
				_toKMLinternal($self,$document,$new_element,$root->{$key});
			}
		}
	}
	
	my $self = shift;
	my $as_string = shift;
	my $document = XML::LibXML::Document->createDocument( "1.0", "UTF-8" );
	$document->setStandalone(1);
	my $kml = $document->createElement('kml');
	$kml->setNamespace("http://earth.google.com/kml/2.1", '',0);
	$document->setDocumentElement($kml);
	my $placemark = $document->createElement('Placemark');
	$placemark->setAttribute('id',$self->id);
	$kml->appendChild($placemark);
	my $data = {%{$self->{data}}};
	delete($data->{id});
	delete($data->{AddressDetails}->{Accuracy});
	_toKMLinternal($self,$document,$placemark,$data);
	$document->setEncoding("UTF-8");
	return $document->toString(1) if($as_string);
	return $document;
}

=head2 toXML

An allias for toKML()

=cut

sub toXML {
	return shift->toKML(@_);
}

=head2 Serialyze

This method simply call the good to(JSON|XML|KML) depending of the output format you selected.

You can eventually pass extra arguments, they will be relayed.

	$location->Serialyze(1); # if the output is set to XML or KML you will have a stringified XML as output

=cut

sub Serialyze {
	my $self = shift;
	if($self->{output}){
		return $self->toJSON if($self->{output} eq 'json');
		return $self->toKML(@_) if($self->{output} eq 'xml' or $self->{output} eq 'kml');
		return $self->toJSON ;
	}
	else {
		return $self->toJSON ;
	}
}

sub _setData {
	my ($self,$data)=@_;
	$self->{data}=$data;
}

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

=item * Nabla Development: 

L<http://www.nabladev.com> and L<http://opensource.nabladev.com>

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
1; # end of Geo::Coder::GoogleMaps::Location