use 5.010;
use strict;
use warnings;

package WebService::OMDB;
{
  $WebService::OMDB::VERSION = '1.170211'; ## version one, date of changelog(yymmdd)
}

# ABSTRACT: Interface to http://www.omdbapi.com/

use LWP::UserAgent;
use JSON;

use constant BASE_URL => 'http://www.omdbapi.com/';

sub new {
	my ($class, %cfg) = @_;

	my $self = bless {}, $class;
	$self->{APIKEY} = $cfg{apikey} || die "API key required";
	$self->{DATATYPE} = $cfg{return} || 'json';
	return $self;
}

sub search {
    my ($self, $s, $options ) = @_;

    die "search string is required" unless $s;

    my $response = $self->_get( 's', $s, $options );
    if ( $response->is_success ) {

        my $content = decode_json( $response->content );
        return $content->{Search};
    }
    else {
        die $response->status_line;
    }
}

sub id {
    my ( $self, $i, $options ) = @_;

    die "id is required" unless $i;

    my $response = $self->_get( 'i', $i, $options );
    if ( $response->is_success ) {

        my $content = decode_json( $response->content );
        return $content;
    }
    else {
        die $response->status_line;
    }

}

sub title {
    my ( $self, $t, $options ) = @_;

    die "title is required" unless $t;

    my $response = $self->_get( 't', $t, $options );
    if ( $response->is_success ) {

        my $content = decode_json( $response->content );
        return $content;
    }
    else {
        die $response->status_line;
    }

}

sub _get {
    my ( $self, $search_param, $search_term, $options ) = @_;

    my $url = $self->_generate_url( $search_param, $search_term, $options );
    my $ua = LWP::UserAgent->new();
    $ua->agent( $options->{user_agent} ) if $options->{user_agent};
    return $ua->get($url);
}

# generates a url from the options
sub _generate_url {
    my ( $self, $search_param, $search_term, $options ) = @_;

    my $url = sprintf( "%s?%s=%s&apikey=%s", BASE_URL, $search_param, $search_term, $self->{APIKEY} );

    while ( my ( $key, $value ) = each(%$options) ) {
        $url .= sprintf( "&%s=%s", $key, $value // 0 );
    }

    return $url;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

WebService::OMDB - Interface to http://www.omdbapi.com/

=head1 VERSION

version 1.170211

=head1 SYNOPSIS

	my $omdb = WebService::OMDB->new(
		apikey => $apikey ## Required for OMDB access
	);

  my $search_results = $omdb->search('Grease');
  # returns...
	[
	  {
	    "Poster": "https://m.media-amazon.com/images/M/MV5BZmUyMDEyOTgtZmUwOS00NTdkLThlNzctNTM1ODQ4M2VhMjdhXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_SX300.jpg",
	    "Title": "Grease",
	    "Type": "movie",
	    "Year": "1978",
	    "imdbID": "tt0077631"
	  },
	  {
	    "Poster": "https://m.media-amazon.com/images/M/MV5BMjViYmViYzAtNzAxOC00YWM2LTg4M2YtZmQzYWJhZTQzMzkyXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_SX300.jpg",
	    "Title": "Grease 2",
	    "Type": "movie",
	    "Year": "1982",
	    "imdbID": "tt0084021"
	  },
	  {
	    "Poster": "https://m.media-amazon.com/images/M/MV5BMTUxMDM3OTk0OF5BMl5BanBnXkFtZTgwOTk4MDk4NzE@._V1_SX300.jpg",
	    "Title": "Grease Live!",
	    "Type": "movie",
	    "Year": "2016",
	    "imdbID": "tt4366830"
	  },
	  {
	    "Poster": "https://images-na.ssl-images-amazon.com/images/M/MV5BMTU0MzU2OTAxMl5BMl5BanBnXkFtZTcwNDQ4OTE0MQ@@._V1_SX300.jpg",
	    "Title": "Grease: You're the One That I Want!",
	    "Type": "series",
	    "Year": "2006–",
	    "imdbID": "tt0840266"
	  },
	  {
	    "Poster": "N/A",
	    "Title": "Grease Is the Word",
	    "Type": "series",
	    "Year": "2007–",
	    "imdbID": "tt0996579"
	  },
	  {
	    "Poster": "https://images-na.ssl-images-amazon.com/images/M/MV5BMTQyMzAyNzkzNl5BMl5BanBnXkFtZTgwMDIzNzgwMzE@._V1_SX300.jpg",
	    "Title": "Grease Monkeys",
	    "Type": "series",
	    "Year": "2003–",
	    "imdbID": "tt0361187"
	  },
	  {
	    "Poster": "https://images-na.ssl-images-amazon.com/images/M/MV5BYTJkNWE5OTgtNDY5NC00Y2IwLTllZTEtZTViNmExNjA1MzMwXkEyXkFqcGdeQXVyMTEwODg2MDY@._V1_SX300.jpg",
	    "Title": "Grease Day USA",
	    "Type": "movie",
	    "Year": "1978",
	    "imdbID": "tt0433385"
	  },
	  {
	    "Poster": "https://m.media-amazon.com/images/M/MV5BMTQ2MzMyNjA1MF5BMl5BanBnXkFtZTgwMDA4MzQ5NzE@._V1_SX300.jpg",
	    "Title": "Elbow Grease",
	    "Type": "movie",
	    "Year": "2016",
	    "imdbID": "tt3317776"
	  },
	  {
	    "Poster": "N/A",
	    "Title": "Man of Grease",
	    "Type": "movie",
	    "Year": "2000",
	    "imdbID": "tt0282716"
	  },
	  {
	    "Poster": "N/A",
	    "Title": "Grease 20th Anniversary Re-Release Party",
	    "Type": "movie",
	    "Year": "2002",
	    "imdbID": "tt0433384"
	  }
	];

  my $id_result = $omdb->id('tt0077631');
  # returns...
	{
	  "Actors": "John Travolta, Olivia Newton-John, Stockard Channing, Jeff Conaway",
	  "Awards": "Nominated for 1 Oscar. Another 3 wins & 7 nominations.",
	  "BoxOffice": "N/A",
	  "Country": "USA",
	  "DVD": "24 Sep 2002",
	  "Director": "Randal Kleiser",
	  "Genre": "Musical, Romance",
	  "Language": "English",
	  "Metascore": "70",
	  "Plot": "Good girl Sandy and greaser Danny fell in love over the summer. When they unexpectedly discover they're now in the same high school, will they be able to rekindle their romance?",
	  "Poster": "https://m.media-amazon.com/images/M/MV5BZmUyMDEyOTgtZmUwOS00NTdkLThlNzctNTM1ODQ4M2VhMjdhXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_SX300.jpg",
	  "Production": "Paramount Pictures",
	  "Rated": "PG-13",
	  "Ratings": [
	    {
	      "Source": "Internet Movie Database",
	      "Value": "7.2/10"
	    },
	    {
	      "Source": "Rotten Tomatoes",
	      "Value": "75%"
	    },
	    {
	      "Source": "Metacritic",
	      "Value": "70/100"
	    }
	  ],
	  "Released": "16 Jun 1978",
	  "Response": "True",
	  "Runtime": "110 min",
	  "Title": "Grease",
	  "Type": "movie",
	  "Website": "N/A",
	  "Writer": "Jim Jacobs (original musical), Warren Casey (original musical), Bronte Woodard (screenplay), Allan Carr (adaptation)",
	  "Year": "1978",
	  "imdbID": "tt0077631",
	  "imdbRating": "7.2",
	  "imdbVotes": "207,264"
	}

  my $title_result = $omdb->title('Grease');
  # returns the same as id

=head1 DESCRIPTION

WebService::OMDB is an interface to L<http://www.omdbapi.com/>.

This version has been refactored to an object-oriented interface, and takes your API key during construction.



=head1 METHODS

=head2 new(apikey => $apikey, return => [json|xml])

Initiate object, set apikey and data format for results.

=over 4

=item apikey

String. Required.

=item return

String. not yet implemented in results, defaults to json.

=back

=head2 search( $search_term, $options )

Searches based on the title. Returns an array of results.

=over 4

=item search_term

String. Required.

=item options

The options shown at L<http://www.omdbapi.com/>. Hash reference. Optional.

=back

=head2 id( $id )

Gets a result based on the IMDB id. Returns a single result.

=over 4

=item id

String. Required.

=item options

The options shown at L<http://www.omdbapi.com/>. Hash reference. Optional.

=back

=head2 title( $title )

Gets a result based on the title. Returns a single result.

=over 4

=item title

String. Required.

=item options

The options shown at L<http://www.omdbapi.com/>. Hash reference. Optional.

=back

=head1 AUTHOR

Andrew Jones <andrew@arjones.co.uk>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Andrew Jones.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
