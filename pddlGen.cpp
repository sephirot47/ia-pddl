#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <vector>

using namespace std;

vector<string> bookNameParticles =
{
  "Harry",
  "Potter",
  "Peter",
  "Pan",
  "George",
  "Rocky",
  "Balboa",
  "Johnny",
};

vector<string> bookNameParticles1 =
{
    "el_viejo",
    "el_joven",
    "el_humilde",
    "el_malevolo",
    "el_verde",
    "el_cojo",
    "el_tuerto",
    "el_matarreyes",
    "el_gnomo",
    "el_agraciado",
    "el_ojoloco",
    "el_senor"
};

vector<string> bookNames;
vector<vector<bool>> reachables;
vector<vector<bool>> preds;

string head, body, tail;
int numBooks, numPreds, numParals, numWants;

void init()
{
    head = "\
            (define (problem problem01)\n\
            (:domain reading_plan)\n\
            ";

    body = "\
              (:init\n\
                (before jan feb)\n\
                (before jan mar)\n\
                (before jan apr)\n\
                (before jan may)\n\
                (before jan jun)\n\
                (before jan jul)\n\
                (before jan aug)\n\
                (before jan sep)\n\
                (before jan oct)\n\
                (before jan nov)\n\
                (before jan dec)\n\
                (before feb mar)\n\
                (before feb apr)\n\
                (before feb may)\n\
                (before feb jun)\n\
                (before feb jul)\n\
                (before feb aug)\n\
                (before feb sep)\n\
                (before feb oct)\n\
                (before feb nov)\n\
                (before feb dec)\n\
                (before mar apr)\n\
                (before mar may)\n\
                (before mar jun)\n\
                (before mar jul)\n\
                (before mar aug)\n\
                (before mar sep)\n\
                (before mar oct)\n\
                (before mar nov)\n\
                (before mar dec)\n\
                (before apr may)\n\
                (before apr jun)\n\
                (before apr jul)\n\
                (before apr aug)\n\
                (before apr sep)\n\
                (before apr oct)\n\
                (before apr nov)\n\
                (before apr dec)\n\
                (before may jun)\n\
                (before may jul)\n\
                (before may aug)\n\
                (before may sep)\n\
                (before may oct)\n\
                (before may nov)\n\
                (before may dec)\n\
                (before jun jul)\n\
                (before jun aug)\n\
                (before jun sep)\n\
                (before jun oct)\n\
                (before jun nov)\n\
                (before jun dec)\n\
                (before jul aug)\n\
                (before jul sep)\n\
                (before jul oct)\n\
                (before jul nov)\n\
                (before jul dec)\n\
                (before aug sep)\n\
                (before aug oct)\n\
                (before aug nov)\n\
                (before aug dec)\n\
                (before sep oct)\n\
                (before sep nov)\n\
                (before sep dec)\n\
                (before oct nov)\n\
                (before oct dec)\n\
                (before nov dec)\n\
                (right_before jan feb)\n\
                (right_before feb mar)\n\
                (right_before mar apr)\n\
                (right_before apr may)\n\
                (right_before may jun)\n\
                (right_before jun jul)\n\
                (right_before jul aug)\n\
                (right_before aug sep)\n\
                (right_before sep oct)\n\
                (right_before oct nov)\n\
                (right_before nov dec)\n\
    ";

    tail = "\n\
            )\n\
            (:goal\n\
              (and\n\
                  (forall (?b - book)\n\
                       (not (want ?b))\n\
                  )\n\
              )\n\
            )\n\
          )\n\
  ";
}

void coutBooks()
{
    bookNames = vector<string>(numBooks, "");
    for(int i = 0; i < bookNames.size(); ++i)
    {
        int p0 = rand() % bookNameParticles.size();
        int p1 = rand() % bookNameParticles1.size();

        bookNames[i] = bookNameParticles[p0] + "_" +
                       bookNameParticles1[p1];
        for(int j = 0; j < bookNames.size(); ++j)
            if(i != j && bookNames[j] == bookNames[i]) { --i; break; }
    }

    for(int i = 0; i < numBooks; ++i)
    {
        cout << bookNames[i] << " ";
    }
    cout << "- book";
}

void coutObjects()
{
    cout << "(:objects ";
    coutBooks();
    cout << endl;
    cout << "jan feb mar apr may jun jul aug sep oct nov dec - month)";
    cout << endl;
}

void addReachability(int fromBook, int toBook)
{
    reachables[fromBook][toBook] = true;
    reachables[toBook][fromBook] = true;

    for(int i = 0; i < reachables[toBook].size(); ++i)
    {
        reachables[fromBook][i] = reachables[fromBook][i] ||
                                  reachables[toBook][i];
    }
}

void coutPreds()
{
    int predsDone = 0, tries = 0;
    while(predsDone < numPreds && ++tries < 99999)
    {
        int rBook0 = rand() % numBooks;
        int rBook1 = rand() % numBooks;
        if(rBook0 == rBook1) continue;
        if(reachables[rBook0][rBook1]) continue; //avoid deadlock

        cout << "\t\t(pred   ";
        cout << bookNames[rBook0];
        for(int i = bookNames[rBook0].size(); i < 21; ++i)
            cout << " "; //tab manual a tomar por culo
        cout << bookNames[rBook1] << ")" << endl;

        addReachability(rBook0, rBook1);
        preds[rBook0][rBook1] = true;
        ++predsDone;
    }
}

void coutParals()
{
    int paralsDone = 0, tries = 0;
    while(paralsDone < numParals && ++tries < 99999)
    {
        int rBook0 = rand() % numBooks;
        int rBook1 = rand() % numBooks;
        if(rBook0 == rBook1) continue;
        if(reachables[rBook0][rBook1]) continue; //avoid deadlock

        cout << "\t\t(paral  ";
        cout << bookNames[rBook0];
        for(int i = bookNames[rBook0].size(); i < 20; ++i)
            cout << " "; //tab manual a tomar por culo
        cout << bookNames[rBook1] << ")" << endl;

        addReachability(rBook0, rBook1);
        preds[rBook0][rBook1] = true;
        ++paralsDone;
    }
}

void coutWants()
{
    vector<bool> wants(numBooks, false);
    int wantsDone = 0, tries = 0;
    while(wantsDone < numWants && ++tries < 99999)
    {
        int r = rand() % numBooks;
        if(wants[r]) continue;

        cout << "\t\t(want  ";
        cout << bookNames[r] << ")" << endl;

        wants[r] = true;
        ++wantsDone;
    }
}

void usage()
{
    cout << "ERROR. Wrong parameters." << endl;
    cout << "Usage: ./pddlGen numLlibres numPreds numParals numWants";
    cout << endl;
}

int main(int argc, char** args)
{
    if(argc <= 4) { usage(); exit(-1); }
    numBooks  = atoi(args[1]);
    numPreds  = atoi(args[2]);
    numParals = atoi(args[3]);
    numWants  = atoi(args[4]);
    if(numPreds >= numBooks)
      { cout << "Too many preds" << endl; exit(-1); }
    if(numPreds + numParals >= numBooks)
      { cout << "Too many parals" << endl; exit(-1); }
    if(numWants >= numBooks)
      { cout << "Too many wants" << endl; exit(-1); }


    srand(time(0));

    reachables = vector<vector<bool>>(numBooks,
                                      vector<bool>(numBooks, false));
    preds = vector<vector<bool>>(numBooks,
                                 vector<bool>(numBooks, false));

    init();
    cout << head << endl;
    coutObjects();
    cout << body << endl;
    coutPreds(); cout << endl;
    coutParals(); cout << endl;
    coutWants(); cout << endl;
    cout << tail << endl;
    return 0;
}

