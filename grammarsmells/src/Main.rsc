module Main

import IO;
import grammarlab::io::read::BGF;
import List;
import Input;
import grammarlab::language::Grammar;
import GrammarUtils;
import Map;
import Set;
import util::Math;

import smells::ReferenceDistance;
import smells::UpDownReferences;
import smells::ProxyNonterminals;
import smells::NamingConvention;
import smells::FakeOneOrMore;
import smells::Duplication;
import smells::ImproperResponsibility;
import smells::MixedDefinitions;
import smells::LegacyStructures;

void run() {

	x = Input::extractedGrammarLocationsInDir(|project://grammarsmells/input/zoo|);
	int counter = 0;
	list[value] someBag = [];
	
	for (loc y <- drop(100,x)) {
		iprintln(y);
		GGrammar theGrammar = readBGF(y);
		grammar(n,p,s) = theGrammar;
		//set[str] x = smells::ProxyNonterminals::violations(theGrammar);
		//iprintln(x);
		//iprintln(size(x));		

		//set[str] result = smells::MixedDefinitions::violations(theGrammar);
		//iprintln(result);
		//iprintln(smells::LegacyStructures::legacyOptionalViolations(theGrammar));
		set[str] result = smells::LegacyStructures::legacyIterationViolations(theGrammar);
		if (size(result) > 0) {
			iprintln(result);
			//return;
		} 

		//set[str] prods = { m | m <- n, size(prodsForNonterminal(theGrammar, m)) > 1};
		//if (size(prods) > 0) {
		//	//iprintln("Found! <prods>");
		//	iprintln("Found");
		//}
		//counter += size(result);
		//if (size(result) > 0 ) {
		//	someBag += y;
		//}
		//result = languageLevels(theGrammar);
		//iprintln({ k// : expressionMap[k]
		//	|  k <- expressionMap
		//	, size(expressionMap[k]) > 1
		//	});
		//iprintln(size(
		//	{ k //: expressionMap[k]
		//	| k <- expressionMap
		//	, size(expressionMap[k]) > 1
		//	}
		//));
		//smells::Duplication::duplications(theGrammar);
		//return;
	
	}
	
	//iprintln(counter);
	//iprintln(someBag);
}
