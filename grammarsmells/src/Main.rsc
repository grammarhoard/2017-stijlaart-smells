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
import smells::EntryPoint;
import smells::MixedTop;
import smells::DisconnectedNonterminalGraph;

void run() {
	x = Input::extractedGrammarLocationsInDir(|project://grammarsmells/input/zoo|);
		
	for (loc y <- drop(0, x)) {
		GGrammar theGrammar = readBGF(y);
		iprintln(y);
		grammar(n,p,s) = theGrammar;
		
		//set[str] a = smells::MixedTop::violations(theGrammar);
		//set[str] b = smells::EntryPoint::violations(theGrammar);
		set[str] result = smells::DisconnectedNonterminalGraph::violations(theGrammar);
		//iprintln(c);
		//iprintln(b);
		iprintln(result);
		//if (size(result) > 0) {
			//iprintln(result);
			//return;
		//}
		//return;
	}
}
