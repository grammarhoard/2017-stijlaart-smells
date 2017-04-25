module smells::LegacyStructures


import grammarlab::language::Grammar;
import GrammarUtils;
import Set;
import IO;
import Map;
import Map::Extra;
import List;


set[str] legacyOptionalViolations(g:grammar(ns,ps,ss)) =
	grammarContainsOptional(g) ? legacyOptionals(g) : {};
	

set[str] legacyIterationViolations(g:grammar(ns,ps,ss)) =
	grammarContainsPlusItereration(g) ? legacyPlusIterations(g) : {};

bool grammarContainsOptional(g:grammar(ns,ps,ss)) =
	size({ lhs 
		 | production(lhs,rhs) <- ps
		 , /optional(_) := rhs
		 })
 	> 0;
	
bool grammarContainsPlusItereration(g:grammar(ns,ps,ss)) =
	size({ lhs 
		 | production(lhs,rhs) <- ps
		 , /plus(_) := rhs
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
		   
		   };
}

set[str] legacyPlusIterations(g:grammar(ns,ps,ss)) {
	return { n
		    | n <- ns
		    , pns := prodsForNonterminal(g, n)
		    ,    { production(_, choice([a, sequence([nonterminal(n), a])]))} := pns
		      || { production(_, choice([sequence([nonterminal(n), a]), a]))} := pns
		      || { production(_, sequence([nonterminal(n), a]))
		    	 , production(_, a)
		    	 } := pns
			};
}
