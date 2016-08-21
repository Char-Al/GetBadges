#!/usr/bin/perl
# author : Charles VAN GOETHEM

use strict;
use warnings;
use Data::Dumper;
use Encode qw(encode decode);
use Getopt::Long;
use LWP::Simple;

# Encoding format of the page
my $encoding='utf-8';

# Command line parser
my $start=0;
my $end=1500;
my $out="";
my $verbose=1;
GetOptions (
	"start|s=i" => \$start,	# numeric
	"end|e=i" => \$end,	# numeric
	"out|o=s"   => \$out,	# string
	"verbose|v"  => \$verbose)	# flag
or die("Error in command line arguments\n");



my @num_badges=($start..$end);
my $urlbase="http://www.senscritique.com/badge/";
my %badge;
my $cpt=0;

# begin the table
open(FILE,">$out");
print FILE "<table>
	<tr>
		<td>#</td>
		<td>Titre</td>
		<td>Description</td>
		<td>Image</td>
	</tr>";

foreach my $id_badge (@num_badges)
{

	# print if verbosity
	if ($id_badge%10==0)
	{
		print "$id_badge\n";
	}
	# make the url
	my $url_badge="$urlbase$id_badge";
	my $html = get($url_badge);
	# get the title name page
	$html =~ m/<title>(.*)\n/;
	my $title = $1;
	# test if redirection (title is the title of the main page)
	if($html =~ m/<title>[ \s]*Avis/){
		next;
	}
	# not redirection : new badge
	$cpt++;
	# get the name
	$html =~ m/<h1[ \s]class="d-heading1">(.*?)<\/h1>/;
	my $name_badge=$1;
	# get the desc
	$html =~ m/<meta name="description" content="(.*?)" \/>\n/;
	my $desc_badge=$1;
	# get the image
	$html =~ m/<img[ \s]+class="acvi-achievement" src="(.*?)"/;
	my $img_badge=$1;
	# print on output in the html table
	print FILE "	<tr>
		<td>$cpt</td>
		<td><a href=\"$url_badge\" target=\"_blank\">$name_badge</a></td>
		<td>$desc_badge</td>
		<td><img src=\"$img_badge\" width=\"50\" heigth=\"50\"></td>
	</tr>";
	
}

# end the HTML table and close file
print FILE "</table>";
close(FILE);

__END__
