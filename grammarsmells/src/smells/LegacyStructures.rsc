module smells::LegacyStructures

import GrammarInformation;
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
	
set[LegacyUsage] violations(GrammarInfo info) =
	  { legacyOptional(n)
	  | n <- legacyOptionalViolations(info)
	  } 
	+ { legacyPlus(n)
	  | n <- legacyIterationPlusViolations(info)
	  }
    + { legacyStar(n)
	  | n <- legacyIterationStarViolations(info)
	  }
	  ;
	  
set[str] legacyOptionalViolations(grammarInfo(g, gData, facts)) =
	facts[containsOptional()] ? legacyOptionals(g, gData) : {};
	
set[str] legacyIterationPlusViolations(grammarInfo(g, gData, facts)) =
	facts[containsPlus()] ? legacyPlusIterations(g, gData) : {};

set[str] legacyIterationStarViolations(grammarInfo(g, gData, facts)) =
	facts[containsStar()] ? legacyStarIterations(g, gData) : {};
	

set[str] legacyOptionals(g:grammar(ns,ps,ss), grammarData(_, nprods, expressionIndex,_,_)) =
	{ n
    | n <- ns
    , pns := nprods[n]
    , {production(_,choice([_,epsilon()]))} := pns 
      || {production(_,_), production(_,epsilon())} := pns
	};

set[str] legacyStarIterations(g:grammar(ns,ps,ss), grammarData(_, nprods, expressionIndex,_,_)) {
	return { n
		   | n <- ns
		   , pns := nprods[n]
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

set[str] legacyPlusIterations(g:grammar(ns,ps,ss), grammarData(_, nprods, expressionIndex,_,_)) {
	return { n
		    | n <- ns
		    , pns := nprods(g, n)
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
