#!/usr/bin/perl -w
use Data::Dumper;
use strict;

# Read the file:
open my $file, '<', $ARGV[0] or die "Cannot open '$ARGV[0]': $!\n";
chomp(my @excuses = <$file>);

# Construct the Markov chain
my %markov;
for my $excuse(@excuses)
{
	# Split by the word:
	my @words = split /\s/, $excuse;

	# Loop through all words, creating key/pair values of every every two
	# words => the third word. For example, 'hello how are you' becomes:
	# 	'hello how' => [ 'are' ]
	#	'how are' => [ 'you' ]
	my ($i, $j, $k) = (0, 1, 2);
	while($k < @words)
	{
		push @{$markov{"$words[${i}++] $words[${j}++]"}}, $words[${k}++];
	}
}

# print Dumper(\%markov);

# Start at a capital letter:
my @starts = grep { $_ =~ /^[A-Z]/ } keys %markov;

# Traverse the chain to generate the excuse:
my @selected = split /\s/, $starts[rand @starts];
my $out = $selected[0] . " ";

do
{
	$out .= $selected[(@selected - 1)] . " ";
	push @selected,
		$markov{join " ", @selected}->[rand @{$markov{join " ", @selected}}];
	shift @selected;
}
while(defined $markov{join " ", @selected});

# Add some punctuation if needed:
$out .= "." unless($out =~ /[.!?]$/);

print $out;
