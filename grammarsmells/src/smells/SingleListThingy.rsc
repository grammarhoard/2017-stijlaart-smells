module smells::SingleListThingy


import grammarlab::language::Grammar;
import GrammarUtils;
import Set;
import IO;
import Map;
import Relation;
import Map::Extra;
import List;


list[GProd] violations(grammarInfo(grammar(_,ps,_), grammarData(_, _, _, _, _), _)) =
	[ p
	| p <- ps
	, production(lhs, rhs) := p
	, /sequence([_]) := rhs || /choice([_]) := rhs
	];
