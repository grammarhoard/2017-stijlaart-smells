module Facts

import IO;
import grammarlab::language::Grammar;
import GrammarUtils;
import List;
import Set;
import Relation;

bool containsStar(GGrammar g)
	= getOneFrom({ l | k <- buildExpressionIndex(g), fullExpr(l) := k, star(_) := l})?;