#include <iostream>
#include <stdlib.h>
#include <algorithm>
#include <vector>
using namespace std;

#define UNDEF -1
#define TRUE 1
#define FALSE 0

uint numVars;
uint numClauses;
vector<vector<int> > clauses;
vector<int> model;
vector<int> modelStack;
uint indexOfNextLitToPropagate;
uint decisionLevel;

vector<pair<int, int> > puntuacio;
//puntuacio: first = punts, second = lit
vector<int> posicio;
//per cada posicio[i], indica la posicio del lit i al vector puntuacio.
vector<vector<int> > clauses_per_lit;
//per cada literal indiquem a quines clausules es troba
//de la pos 1 a la numVars estan els lits negatius (negats),
//a partir de la pos numVars+1 estan els positius.

void incrementar_puntuacio(int lit) {
	int index = posicio[lit];
	puntuacio[index].first++;
	pair <int, int> aux;
	while (index<numVars
		and puntuacio[index].first > puntuacio[index+1].first) {
		posicio[puntuacio[index].second]++;
		posicio[puntuacio[index+1].second]--;

		aux = puntuacio[index+1];
		puntuacio[index+1] = puntuacio[index];
		puntuacio[index] = aux;

		index++;
	}
}

void readClauses(){
  // Skip comments
  char c = cin.get();
  while (c == 'c') {
    while (c != '\n') c = cin.get();
    c = cin.get();
  }  
  // Read "cnf numVars numClauses"
  string aux;
  cin >> aux >> numVars >> numClauses;
  clauses.resize(numClauses);
  puntuacio.resize(numVars+1);
  posicio.resize(numVars+1);
  clauses_per_lit.resize(2*numVars+1);
  for (uint i = 0; i < numVars+1; i++) {
  	puntuacio[i].first = 0;
  	puntuacio[i].second = i;
  	posicio[i] = i;
  }
  // Read clauses
  for (uint i = 0; i < numClauses; ++i) {
    int lit;
    while (cin >> lit and lit != 0) {
    	clauses[i].push_back(lit);
    	incrementar_puntuacio(abs(lit));
    	if (lit < 0) clauses_per_lit[abs(lit)].push_back(i);
    	else clauses_per_lit[lit+numVars].push_back(i);
    }
  }
}

int currentValueInModel(int lit){
  if (lit >= 0) return model[lit];
  else {
    if (model[-lit] == UNDEF) return UNDEF;
    else return 1 - model[-lit];
  }
}

void setLiteralToTrue(int lit){
  modelStack.push_back(lit);
  if (lit > 0) model[lit] = TRUE;
  else model[-lit] = FALSE;		
}

bool propagateGivesConflict ( ) {
  while ( indexOfNextLitToPropagate < modelStack.size() ) {
  	int lit = modelStack[indexOfNextLitToPropagate];
    ++indexOfNextLitToPropagate;
    //agafem la pos del lt en negatiu
    if (lit < 0) lit = abs(lit)+numVars;

    // nomes visitar clauses que contenen el literal negat  
    for (uint i = 0; i < clauses_per_lit[lit].size(); ++i) {
      int p = clauses_per_lit[lit][i];
      
      bool someLitTrue = false;
      int numUndefs = 0;
      int lastLitUndef = 0;
      for (uint k = 0; not someLitTrue and k < clauses[p].size(); ++k) {
      	int val = currentValueInModel(clauses[p][k]);
      	if (val == TRUE) someLitTrue = true;
      	else if (val == UNDEF){
      		++numUndefs;
      		lastLitUndef = clauses[p][k];
      	}
      }
      if (not someLitTrue and numUndefs == 0) {
		for (uint j=0; j<clauses[p].size(); j++) {
          int aux = abs(clauses[p][j]);
          incrementar_puntuacio(aux);
        }
        return true; // conflict! all lits false
      }
      else if (not someLitTrue and numUndefs == 1) setLiteralToTrue(lastLitUndef);	
    }    
  }
  return false;
}

void backtrack(){
  uint i = modelStack.size() -1;
  int lit = 0;
  while (modelStack[i] != 0){ // 0 is the DL mark
    lit = modelStack[i];
    model[abs(lit)] = UNDEF;
    modelStack.pop_back();
    --i;
  }
  // at this point, lit is the last decision
  modelStack.pop_back(); // remove the DL mark
  --decisionLevel;
  indexOfNextLitToPropagate = modelStack.size();
  setLiteralToTrue(-lit);  // reverse last decision
}

int getNextDecisionLiteral() {// Heuristic for finding the next decision literal:
  for (uint i = numVars; i >= 1; --i)// stupid heuristic:
    if (model[puntuacio[i].second] == UNDEF) return puntuacio[i].second;  // returns first UNDEF var, positively
  return 0; // reurns 0 when all literals are defined
}

void checkmodel(){
  for (uint i = 0; i < numClauses; ++i){
    bool someTrue = false;
    for (uint j = 0; not someTrue and j < clauses[i].size(); ++j)
      someTrue = (currentValueInModel(clauses[i][j]) == TRUE);
    if (not someTrue) {
      cout << "Error in model, clause is not satisfied:";
      for (uint j = 0; j < clauses[i].size(); ++j) cout << clauses[i][j] << " ";
      cout << endl;
      exit(1);
    }
  }  
}

int main(){ 
  readClauses(); // reads numVars, numClauses and clauses
  model.resize(numVars+1,UNDEF);
  indexOfNextLitToPropagate = 0;  
  decisionLevel = 0;
  
  // Take care of initial unit clauses, if any
  for (uint i = 0; i < numClauses; ++i)
    if (clauses[i].size() == 1) {
      int lit = clauses[i][0];
      int val = currentValueInModel(lit);
      if (val == FALSE) {cout << "UNSATISFIABLE" << endl; return 10;}
      else if (val == UNDEF) setLiteralToTrue(lit);
    }
  
  // DPLL algorithm
  while (true) {
    while ( propagateGivesConflict() ) {
      if ( decisionLevel == 0) { cout << "UNSATISFIABLE" << endl; return 10; }
      backtrack();
    }
    int decisionLit = getNextDecisionLiteral();
    if (decisionLit == 0) { checkmodel(); cout << "SATISFIABLE" << endl; return 20; }
    // start new decision level:
    modelStack.push_back(0);  // push mark indicating new DL
    ++indexOfNextLitToPropagate;
    ++decisionLevel;
    setLiteralToTrue(decisionLit);    // now push decisionLit on top of the mark
  }
}  
