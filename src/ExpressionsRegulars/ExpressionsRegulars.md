# Expressions Regulars

\  suppress the special meaning of a character when matching. 
	For example:\$ matches the character `$’.

^ matches the starting of a string, or the starting position of a line. For example: ^chapter matches `c’.

$	matches the end of a string, or the end position of a line. For example: p$ matches a record that ends with a `p’.

.	The period, or dot, matches any single character. For example: .P matches any single character followed by a `P' in a string.

[...] matches characters enclosed in the square brackets. For example: [MVX] matches any one of the characters `M', `V', or `X'. [0-9] matches any digit.  [A-Za-z0-9] matches all alphanumeric characters.

[^ ...] f.e.:[^0-9] matches any string starting with a number.

|	specifies alternatives. For example:^P|[0-9] matches any string that matches either `^P' or `[0-9]'. This means it matches any string that starts with `P' or contains a digit.

(...) used for concatenate regular expressions. For example, `@(samp|code)\{[^}]+\}'matches both `@code{foo}' and `@samp{bar}’. 

*	the preceding regular expression is to be repeated as many times as necessary to find a match. For example: ph* applies the `*' symbol to the preceding `h' and looks for matches of 	one `p' followed by any number (>=0) of `h's. 

+	similar to `*', but the preceding expression must be matched  	at least once. For example: wh+y match `why' and `whhy’.

{n}{n,}{n,m} interval expression. If there is one number (n) in the braces, the preceding regular expression is repeated n times. If there are two numbers separated by a comma, the preceding  regular expression is repeated n to m times. If there is one number (n) followed by a comma, then the preceding regular expression is repeated at least n times.
    wh{3}y matches `whhhy’ 
    wh{3,5}y matches `whhhy' or `whhhhy' or `whhhhhy’
    wh{2,}y matches `whhy' or `whhhy', and so on.
    
    ----------------------
