module smells::SingleListThingy


import grammarlab::language::Grammar;
import GrammarUtils;
import Set;
import IO;
import Map;
import Relation;
import Map::Extra;
import List;


list[GProd] violations(GGrammar g:grammar(ns,ps,ss)) =
	[ p
	| p <- ps
	, production(lhs, rhs) := p
	, /sequence([_]) := rhs || /choice([_]) := rhs
	];
