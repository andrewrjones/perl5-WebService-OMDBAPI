#!perl

use strict;
use warnings;

use Test::More;
# skip tests if we are not online
use HTTP::Online ':skip_all';
plan tests => 5;

use WebService::OMDB;

use constant TITLE  => 'Grease';
use constant IMDBID => 'tt0077631';
use constant APIKEY => '8d779c47';

my $omdb = WebService::OMDB->new(
	apikey => APIKEY
);

my $search_results = $omdb->search(TITLE);
ok( @{$search_results} >= 4, 'at least 4 results' );

my $id_result = $omdb->id(IMDBID);
ok($id_result);
is( $id_result->{Title}, TITLE );

my $title_result = $omdb->title(TITLE);
ok($title_result);
is( $id_result->{imdbID}, IMDBID );
