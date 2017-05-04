module smells::Size

import grammarlab::language::Grammar;
import IO;
import util::Math;
import List;
import GrammarInformation;
import Set;
import PowerMaloy;

data GrammarSize =
	grammarSize(list[ProductionInfo] productionInfos, int hal);
	
data NonterminalProductionInfo 
	= nonterminalProductionInfo(int total, list[str] items)
	;
data TerminalProductionInfo
	= terminalProductionInfo(int total, list[str] items)
	;
data PreterminalProductionInfo
	= preterminalProductionInfo(int total, list [GValue] items)
	;
data MetasymbolProductionInfo
	= metasymbolProductionInfo(int total, list [MetaSymbolUsage] items)
	;
	
data ProductionInfo
	= productionInfo
		( NonterminalProductionInfo npi
		, TerminalProductionInfo tpi
		, PreterminalProductionInfo ppi
		, MetasymbolProductionInfo mpi
		, int cc
		)
	;

data MetaSymbolUsage = 
	useStar() | usePlus() | useConj() | useOptional() | useDisj() | useEpsilon();
	
GrammarSize stuff(gi:grammarInfo(grammar(ns, ps, _), grammarData(_, _, expressionIndex, tops, _), facts)) {
	list[ProductionInfo] pinfos = [ buildProductionInfo(p, facts) | p <- ps ];
	return 
		grammarSize
			( pinfos
			, halsteadEffort(pinfos, gi)
			);
}



ProductionInfo buildProductionInfo(p:production(lhs,rhs), Facts facts) {
	int nonterminals = 0;
	list[str] ns = [];
	
	int terminals = 0;
	list[str] ts = [];
	
	int metasymbols = 0;
	list[MetaSymbolUsage] metasymbolUsages = [];
	
	int cc = mccabe(p);
	int noPreterminals = 0;
	list[GValue] pts = [];
	
	visit(rhs) {
		case terminal(t): {
			terminals = terminals + 1;
			ts = ts + t;
		}
		case nonterminal(x): { 
			nonterminals = nonterminals + 1;
			ns = ns + x;
		}
		case val(x): {
			noPreterminals = noPreterminals + 1;
			pts = pts + x;
		}
		case mark(_,_): {};
		case label(_,_): {};
		case anything(): {}; //TODO Is this a metasymbol?
		case epsilon(): {
			metasymbols = metasymbols + 1;
			metasymbolUsages = metasymbolUsages + useEpsilon();
		}
		case sequence(xs): {
			metasymbols = metasymbols + 1;
			metasymbolUsages = metasymbolUsages + [ useConj() | _ <- [1..size(xs)] ];
		}
		case choice(xs): {
			metasymbols = metasymbols + 1; 
			metasymbolUsages = metasymbolUsages + [ useDisj() | _ <- [1..size(xs)] ];
		}
		case optional(_): {
			metasymbols = metasymbols + 1;
			metasymbolUsages = metasymbolUsages + useOptional();
		}
		case plus(_): {
			metasymbols = metasymbols + 1;
			metasymbolUsages = metasymbolUsages + usePlus();
		}
		case star(_): {
			metasymbols = metasymbols + 1;
			metasymbolUsages = metasymbolUsages + useStar();
		}
		case GExpr a : {
			println(a);
		}
	}
	return 
		productionInfo
			( nonterminalProductionInfo(nonterminals, ns)
			, terminalProductionInfo(terminals, ts)
			, preterminalProductionInfo(noPreterminals, pts)
			, metasymbolProductionInfo(metasymbols, metasymbolUsages)
			, cc
			);
}


int mccabe(production(_, rhs)) {
	int cc = 0;
	visit(rhs) {
		case choice(xs): {
			cc = cc + min(size(xs) - 1, 0); 
		}
		case optional(_): {
			cc = cc + 1;
		}
		case plus(_): {
			cc = cc + 1;
		}
		case star(_): {
			cc = cc + 1;
		}
	}
	
	return cc;
}

int halsteadEffort(list[ProductionInfo] pInfos, grammarInfo(grammar(ns, ps, _), grammarData(_, _, expressionIndex, tops, _), facts)) {
 	int operators = size(( {} | it + toSet(x.mpi.items) | x <- pInfos ));
 	int operands =  size(toSet(ns)) + size(( {} | it + toSet(x.tpi.items) | x <- pInfos ));
 	int occurencesOperators = sum([0] + [ size(x.mpi.items) | x <- pInfos ]);
 	int occurencesOperands =
	 	sum([0] + [ size(x.npi.items) | x <- pInfos ]) +
	 	sum([0] + [ size(x.tpi.items) | x <- pInfos ]) +
	 	sum([0] + [ size(x.ppi.items) | x <- pInfos ]); 
 	 	
	return 
		round(
			(operators * operands * ( occurencesOperators + occurencesOperands) * log2(operators + operands))
			/ (2 * operands)
		);
}
