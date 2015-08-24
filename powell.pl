#!/usr/bin/perl -w
use strict;

# The order to use - this decides the size of each prefix:
our $ORDER = 2;

# Read the file:
open my $file, '<', $ARGV[0] or die "Cannot open '$ARGV[0]': $!\n";
chomp(my @excuses = <$file>);

# Construct the Markov chain
my %markov;
for my $excuse(@excuses)
{
	# Split by the word:
	my @words = split /\s/, $excuse;

	# Loop through all words, creating key/pair values of every every n words =>
	# the (n + 1)th word (where n = $ORDER). For example, 'hello how are you'
	# (n = 2) becomes:
	# 	'hello how' => [ 'are' ]
	#	'how are' => [ 'you' ]
	for(my $i = 0; $i < (@words - $ORDER); $i++)
	{
		my @selection = @words[$i..($i + $ORDER)];
		my $a = pop @selection;
		push @{$markov{join " ", @selection}}, $a;
	}
}

# Start at a capital letter:
my @starts = grep { $_ =~ /^[A-Z]/ } keys %markov;

# Traverse the chain to generate the excuse:
my @selected = split /\s/, $starts[rand @starts];
my $out = $selected[0] unless(@selected eq 1);

do
{
	if(defined $selected[1]) { $out .= " " . $selected[1] } else
		{ $out .= " " . $selected[0] };
	push @selected,
		$markov{join " ", @selected}->[rand @{$markov{join " ", @selected}}];
	shift @selected;
}
while(defined $markov{join " ", @selected});

# Add the last word and some punctuation if needed:
if(@selected > 1) { $out .= " $_" for(@selected[1..(@selected - 1)]); } else
	{ $out .= " " . $selected[0]; }
#$out .= " " . $selected[-1];
$out .= "." unless($out =~ /[.!?]$/);

print $out, "\n";
