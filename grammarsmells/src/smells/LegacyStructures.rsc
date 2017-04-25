module smells::LegacyStructures


import grammarlab::language::Grammar;
import GrammarUtils;
import Set;
import IO;
import Map;
import Map::Extra;
import List;

data LegacyUsage
	= legacyOptional(str n)
	| legacyPlus(str n)
	| legacyStar(str n)
	;
	
set[LegacyUsage] violations(g) =
	  { legacyOptional(n)
	  | n <- legacyOptionalViolations(g)
	  } 
	+ { legacyPlus(n)
	  | n <- legacyIterationPlusViolations(g)
	  }
    + { legacyStar(n)
	  | n <- legacyIterationStarViolations(g)
	  }
	  ;
	  
set[str] legacyOptionalViolations(g:grammar(ns,ps,ss)) =
	grammarContainsOptional(g) ? legacyOptionals(g) : {};
	
set[str] legacyIterationPlusViolations(g:grammar(ns,ps,ss)) =
	grammarContainsPlusIteration(g) ? legacyPlusIterations(g) : {};

set[str] legacyIterationStarViolations(g:grammar(ns,ps,ss)) =
	grammarContainsStarIteration(g) ? legacyStarIterations(g) : {};
	
	
bool grammarContainsOptional(g:grammar(ns,ps,ss)) =
	size({ lhs 
		 | production(lhs,rhs) <- ps
		 , /optional(_) := rhs
		 })
 	> 0;
	
bool grammarContainsPlusIteration(g:grammar(ns,ps,ss)) =
	size({ lhs 
		 | production(lhs,rhs) <- ps
		 , /plus(_) := rhs
		 })
 	> 0;
 	
bool grammarContainsStarIteration(g:grammar(ns,ps,ss)) =
	size({ lhs 
		 | production(lhs,rhs) <- ps
		 , /star(_) := rhs
		 })
 	> 0;
set[str] legacyOptionals(g:grammar(ns,ps,ss)) =
	{ n
    | n <- ns
    , pns := prodsForNonterminal(g, n)
    , {production(_,choice([_,epsilon()]))} := pns 
      || {production(_,_), production(_,epsilon())} := pns
	};

set[str] legacyStarIterations(g:grammar(ns,ps,ss)) {
	return { n
		   | n <- ns
		   , pns := prodsForNonterminal(g, n)
		   ,     { production(_, choice([epsilon(), sequence([nonterminal(n), a, b*])]))} := pns
		      || { production(_, choice([sequence([nonterminal(n), a, b*]), epsilon()]))} := pns
		      || { production(_, sequence([nonterminal(n), a, b*]))
		    	 , production(_, epsilon())
		    	 } := pns
	    	  || { production(_, sequence([a, b*, nonterminal(n)]))
		    	 , production(_, epsilon())
		    	 } := pns
		   };
}

set[str] legacyPlusIterations(g:grammar(ns,ps,ss)) {
	return { n
		    | n <- ns
		    , pns := prodsForNonterminal(g, n)
		    ,    { production(_, choice([a, sequence([nonterminal(n), a])]))} := pns
		      || { production(_, choice([sequence([a, b*]), sequence([nonterminal(n), a, b*])]))} := pns
		      || { production(_, choice([a, sequence([a, nonterminal(n)])]))} := pns
		      || { production(_, choice([sequence([a, b*]), sequence([a, b*, nonterminal(n)])]))} := pns
		      || { production(_, choice([sequence([nonterminal(n), a]), a]))} := pns
		      || { production(_, choice([sequence([nonterminal(n), sequence([a, b*]) ]), sequence(a, b*)]))} := pns
		      || { production(_, choice([sequence([a, nonterminal(n)]), a]))} := pns
		      || { production(_, choice([sequence([a, b*, nonterminal(n)]), sequence([a, b*]) ]))} := pns
		      || { production(_, sequence([nonterminal(n), a]))
		    	 , production(_, a)
		    	 } := pns
	    	  || { production(_, sequence([nonterminal(n), a, b*]))
		    	 , production(_, sequence([a, b*]))
		    	 } := pns
	    	  || { production(_, sequence([a, nonterminal(n)]))
		    	 , production(_, a)
		    	 } := pns
	    	  || { production(_, sequence([a, b*, nonterminal(n)]))
		    	 , production(_, sequence([a, b*]))
		    	 } := pns
		    	 
			};
}
