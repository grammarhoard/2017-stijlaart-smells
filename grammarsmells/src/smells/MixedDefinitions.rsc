module smells::MixedDefinitions


import grammarlab::language::Grammar;
import GrammarUtils;
import Set;
import IO;
import Map;
import Map::Extra;
import List;

data DefinitionDirection
	= horizontal(str s)
	| vertical(str s)
	| zigZag(str s)	
	| undecided(str s)
	;


set[DefinitionDirection] definitionStyles(GGrammar g:grammar(ns, ps, _)) {
	map[str,set[GProd]] index = nonterminalProdMap(g);
	
	set[str] horizontals = { k | k <- index, anyHorizontal(index[k])};
	set[str] verticals = { k | k <- index, size(index[k]) > 1};
	set [str] zigZags = (verticals & horizontals);
	
	return { zigZag(s) | s <- zigZags }
		 + { horizontal(s) | s <- (horizontals - zigZags)}
		 + { vertical(s) | s <- (verticals - zigZags)}
		 + { undecided(s) | s <- (ns - horizontals - verticals) }
		 ;
}

set[str] violations(GGrammar g) =
	{ y | x <- definitionStyles(g), zigZag(y) := x};


bool anyHorizontal(set[GProd] items) =
	any(i <- items, horizontal(i));

bool horizontal(production(lhs, rhs)) =
	choice(xs) := rhs;