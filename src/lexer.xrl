Definitions.

Whitespace = [\s\t]
Terminator = \n|\r\n|\r
Digit = [0-9]
NonZeroDigit = [1-9]
Negative = [\-]
FractionalPart = \.{Digit}+
IntegerPart = {Negative}?0|{Negative}?{NonZeroDigit}{Digit}*
IntValue = {IntegerPart}
FloatValue = {IntegerPart}{FractionalPart}
Number = {IntValue}|{FloatValue}
Operator = {Negative}|\+|\*|\/|\^|\=
Lowercase = [a-z]
Uppercase = [A-Z]
Character = [A-Za-z]
NamedVar = {Uppercase}{Character}*
LetterVars = {Lowercase}+
Coeff = {IntValue}{LetterVars}|{IntValue}{NamedVar}|{IntValue}\(
Paren = [\(\)]




Rules.

{Whitespace} : skip_token.
{Terminator} : skip_token.
{Coeff} : handle_coeff(TokenChars,TokenLine).
{IntValue} : {token, {int, TokenLine, list_to_integer(TokenChars)}}.
{FloatValue} : {token, {float, TokenLine, list_to_float(TokenChars)}}.
{Operator} : {token, {list_to_atom(TokenChars), TokenLine, TokenChars}}.
{NamedVar} : {token, {var, TokenLine, TokenChars}}.
{LetterVars} : handle_letter_vars(TokenChars,TokenLine).
{Paren} : {token, {list_to_atom(TokenChars), TokenLine, TokenChars}}.


Erlang code.

handle_letter_vars([SingleChar], TokenLine) ->
    {token, {var, TokenLine, [SingleChar]}};

handle_letter_vars([H | T], TokenLine) ->
    {token, {var, TokenLine, [H]}, [$* | T]}.

handle_coeff(TokenChars, TokenLine) ->
    {Token, Number, Rest} = list_to_num_token(TokenChars),
    {token, {Token, TokenLine, Number}, [$* | Rest]}.

list_to_num_token(L) ->
    case string:list_to_float(L) of
        {error, no_float} -> 
            {I, Rest} = string:list_to_integer(L),
            {int, I, Rest};
        {F, Rest} -> {float, F, Rest}
    end.