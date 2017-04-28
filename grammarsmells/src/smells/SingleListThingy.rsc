module smells::SingleListThingy


import grammarlab::language::Grammar;
import GrammarUtils;
import Set;
import IO;
import Map;
import Relation;
import Map::Extra;
import List;
import Violations;

set[Violation] violations(grammarInfo(grammar(_,ps,_), grammarData(_, _, _, _, _), _)) =
	{ <violatingProduction(p), singleListThingy(e)>
	| p <- ps
	, production(lhs, rhs) := p
	, /e:sequence([_]) := rhs || /e:choice([_]) := rhs
	};
