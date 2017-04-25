module smells::NamingConvention

import IO;
import grammarlab::language::Grammar;
import GrammarUtils;
import List;
import Set;
import Relation;

data NamingClass
	= lowerCasedHyphed()
	| lowerCasedDashed()
	;
	
data FunctionClass
	= terminalDefinitions()
	;
	
bool lowerCaseHyphen(str n) = 
	/^[a-z0-9]+(-[a-z0-9]+)*$/ := n;
		
test bool lowerCaseHyphen1() = lowerCaseHyphen("abc-def");
test bool lowerCaseHyphen2() = !lowerCaseHyphen("abc-");
test bool lowerCaseHyphen3() = !lowerCaseHyphen("abc-Def");
test bool lowerCaseHyphen4() = lowerCaseHyphen("abc-3d");


bool lowerCaseDash(str n) =
	/^[a-z0-9]+(_[a-z0-9]+)*$/ := n;
	
test bool lowerCaseDash1() = lowerCaseDash("abc_def");
test bool lowerCaseDash2() = !lowerCaseDash("abc_");
test bool lowerCaseDash3() = !lowerCaseDash("abc_Def");
test bool lowerCaseDash4() = lowerCaseDash("abc_3d");

rel[NamingClass, bool(str)] namingClasses = 
	{ <lowerCasedHyphed(), lowerCaseHyphen>
	, <lowerCasedDashed(), lowerCaseDash>
	};
	
	
bool isTerminalDefinition(GGrammar g, str n) {
	set[GProd] ps = prodsForNonterminal(g,n);
	//TODO Is this exaustive? Should it contain labels etc. as well.
	return { production(z, terminal(y))} := ps;
}

rel[FunctionClass, bool(GGrammar g, str n)] functionClasses = 
	{ <terminalDefinitions(), isTerminalDefinition>
	}
	;
	

rel[NamingClass,str] buildNamingRelation(set[str] ns) {
	r = { <v,n> | n <- ns, <v,f> <- namingClasses, f(n)};
	if (size(domain(r)) <= 1) {
		return {};
	}
	
	return r;	
}


