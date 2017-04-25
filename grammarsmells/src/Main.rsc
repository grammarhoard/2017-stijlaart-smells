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

void run() {
	x = Input::extractedGrammarLocationsInDir(|project://grammarsmells/input/zoo|);
		
	for (loc y <- drop(0, x)) {
		iprintln(y);
		GGrammar theGrammar = readBGF(y);
		grammar(n,p,s) = theGrammar;
		
		set[str] result = smells::EntryPoint::violations(theGrammar);
		if (size(result) > 0) {
			iprintln(result);
			//return;
		}
		//return;
	}
}
