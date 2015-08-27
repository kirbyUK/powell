powell
======

A simple general-purpose random text generator using Markov Chains.
The name comes from a friend, who would come up with the strangest excuses
known to man. The program was originally going to generate new excuses for him,
but it ended up being more generic.

USAGE
-----

Taken from the program's own help:

```
powell [OPTIONS] [FILES]

powell takes any number of files, reads them line by line and uses
 Markov chains to randomly construct a new string.

Options are as follows:
	-h or --help:          Displays this help text and quits
	-c or --capital:       Start the string with a capital letter.
	-o n or --order=n:     Sets the order to use, where n is a positive
	 non-zero integer. The default order is 2.
	-s r or --separator=r: Perl regex used to seperate records.
	 The default is '\n'.
```

The program seperates files into records, split using the 'seperator' variable.
Generally, you can expect the output to be roughly the same length as the input
records. The default is to split line by line ('\n').

LICENSE
-------

```
Copyright (c) Alex Kerr 2015
Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```
