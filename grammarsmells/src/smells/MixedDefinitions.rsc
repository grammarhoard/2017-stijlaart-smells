module smells::MixedDefinitions


import grammarlab::language::Grammar;
import GrammarUtils;
import Set;
import IO;
import Map;
import Map::Extra;
import List;
import GrammarInformation;
import Violations;

data DefinitionDirection
	= horizontal(str s)
	| vertical(str s)
	| zigZag(str s)	
	| undecided(str s)
	;


set[Violation] violations(GrammarInfo info) =
	{ <violatingNonterminal(y),mixedDefinition()> | x <- definitionStyles(info), zigZag(y) := x};

set[DefinitionDirection] definitionStyles(grammarInfo(grammar(ns,_,_), grammarData(_, nprods, _,_,_), _)) {
	set[str] horizontals = { k | k <- nprods, anyHorizontal(nprods[k])};
	set[str] verticals = { k | k <- nprods, size(nprods[k]) > 1};
	set [str] zigZags = (verticals & horizontals);
	
	return { zigZag(s) | s <- zigZags }
		 + { horizontal(s) | s <- (horizontals - zigZags)}
		 + { vertical(s) | s <- (verticals - zigZags)}
		 + { undecided(s) | s <- (ns - horizontals - verticals) }
		 ;
}

bool anyHorizontal(set[GProd] items) =
	any(i <- items, horizontal(i));

bool horizontal(production(lhs, rhs)) =
	choice(xs) := rhs;