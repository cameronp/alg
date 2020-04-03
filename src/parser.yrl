Nonterminals
document
term
expression.

Terminals
int float '(' ')' var '+' '-' '*' '/' '^' '='.

Rootsymbol document.

Left 300 '+'.
Left 300 '-'.
Left 400 '*'.
Left 400 '/'.
Right 500 '^'.
Nonassoc 600 '(' ')'.
Nonassoc 200 '='.


document -> expression : flatten('$1').

expression -> expression '+' expression : {expression, {plus, '$1', '$3'}}.
expression -> expression '-' expression : {expression, {minus, '$1', '$3'}}.
expression -> expression '/' expression : {expression, {divide, '$1', '$3'}}.
expression -> expression '*' expression : {expression, {times, '$1', '$3'}}.
expression -> expression '^' expression : {expression, {power, '$1', '$3'}}.
expression -> expression '=' expression : {expression, {eq, '$1', '$3'}}.


expression -> '(' expression ')' : '$2'.
expression -> term : '$1'.

term -> int : {term, {int, unwrap('$1')}}.
term -> float : {term, {float, unwrap('$1')}}.
term -> var : {term, {var, unwrap('$1')}}.

Erlang code.

unwrap({_,_,V}) -> V.

flatten({expression, Expression}) -> flatten(Expression);
flatten({Op, A, B}) -> {Op, flatten(A), flatten(B)};
flatten({term, Term}) -> Term.
