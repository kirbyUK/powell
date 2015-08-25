#!/usr/bin/perl -w
use Getopt::Long;
use strict;

# Subroutine prototypes:
sub help; # Prints help information and exits.
sub main; # The main body of the program.

# Process command line options:
my $help = ""; # Print help (True/false).
my $capital = ""; # Start the generated text with a capital letter.
my $order = 2; # The order to use - this decides the size of each prefix.
my $separator = qr{\n}m; # The regex used to split records.
GetOptions(
	"help" => \$help,
	"capital" => \$capital,
	"order=i" => \$order,
	"separator=s" => sub {
		my ($opt_name, $opt_value) = @_;
		$separator = qr{$opt_value}m;
		die "Invalid separator regex '$opt_value'!" unless($separator);
	}
);

if($help) { help } else { main }

sub main
{
	# Validate the order:
	die "Order '$order' is not a non-zero positive integer!\n"
		unless($order > 0);

	# Read the file(s):
	my @samples;
	for my $filename(@ARGV)
	{
		open my $file, '<', $filename or die "Cannot open '$filename': $!\n";

		# Slurp the file and split it with the specified separator:
		local $/;
		push @samples, split $separator, <$file>;
	}
	# Remove any blank samples and extrenuous whitespace:
	@samples = map { $_ =~ s/\s+/ /gr } @samples;

	# Construct the Markov chain
	my %markov;
	for my $sample(@samples)
	{
		# Split by the word:
		my @words = split /\s/, $sample;

		# Loop through all words, creating key/pair values of every every n
		# words => the (n + 1)th word (where n = $order). For example, 'hello
		# how are you' (n = 2) becomes:
		# 	'hello how' => [ 'are' ]
		#	'how are' => [ 'you' ]
		for(my $i = 0; $i < (@words - $order); $i++)
		{
			my @selection = @words[$i..($i + $order)];
			my $a = pop @selection;
			push @{$markov{join " ", @selection}}, $a;
		}
	}

	# Start at a capital letter if enabled:
	my @starts = ($capital) ? grep { $_ =~ /^[A-Z]/ } keys %markov :
		keys %markov;

	# Traverse the chain to generate the text:
	my @selected = split /\s/, $starts[rand @starts];
	push my @out, $selected[0] unless(@selected eq 1);

	do
	{
		if(defined $selected[1]) { push @out, $selected[1] } else
			{ push @out, $selected[0] };
		push @selected,
			$markov{join " ", @selected}->[rand @{$markov{join " ", @selected}}];
		shift @selected;
	}
	while(defined $markov{join " ", @selected});

	# Add the last word and some punctuation if needed:
	if(@selected > 1) { push @out, $_ for(@selected[1..(@selected - 1)]); } else
		{ push @out, $selected[0]; }
	my $out = join " ", @out;
	$out .= "." unless($out =~ /[.!?]$/);

	print $out, "\n";
}

# Prints help text and exits:
sub help
{
	print "powell: usage: powell [OPTIONS] [FILES]\n\n";
	print "powell takes any number of files, reads them line by line and uses\n";
	print " Markov chains to randomly construct a new string.\n\n";
	print "Options are as follows:\n";
	print "\t-h or --help:          Displays this help text and quits\n";
	print "\t-c or --capital:       Start the string with a capital letter.\n";
	print "\t-o n or --order=n:     Sets the order to use, where n is a positive\n";
	print "\t non-zero integer. The default order is 2.\n";
	print "\t-s r or --separator=r: Perl regex used to seperate records.\n";
	print "\t The default is '\\n'.\n";
}
