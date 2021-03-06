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
int numBooks, numPreds, numParals, numWants,numReads;

void init()
{
    head = "\
            (define (problem problem01)\n\
            (:domain reading_plan)\n\
            ";

    body = "\
              (:init\n\
                (current jan)\n\
                \n\
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
            \t(= (pgm jan) 0)\n\
            \t(= (pgm feb) 0)\n\
            \t(= (pgm mar) 0)\n\
            \t(= (pgm apr) 0)\n\
            \t(= (pgm may) 0)\n\
            \t(= (pgm jun) 0)\n\
            \t(= (pgm jul) 0)\n\
            \t(= (pgm aug) 0)\n\
            \t(= (pgm sep) 0)\n\
            \t(= (pgm oct) 0)\n\
            \t(= (pgm nov) 0)\n\
            \t(= (pgm dec) 0)\n\n\
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
        cout << bookNames[rBook0] << " ";
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
        cout << bookNames[rBook0] << " ";
        for(int i = bookNames[rBook0].size(); i < 20; ++i)
            cout << " "; //tab manual a tomar por culo
        cout << bookNames[rBook1] << ")" << endl;

        addReachability(rBook0, rBook1);
        preds[rBook0][rBook1] = true;
        ++paralsDone;
    }
}

void coutPGMs()
{
  for(int i = 0; i < bookNames.size(); ++i)
  {
    cout << "\t\t(= (pgb ";
    cout << bookNames[i] + ") ";
    cout << to_string(rand() % 800 + 1) << ")" << endl;
  }
}

vector<bool> wants(numBooks, false);
void coutWants()
{
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

void coutReads()
{
    vector<bool> reads(numBooks, false);
    int readsDone = 0, tries = 0;
    while(readsDone < numReads && ++tries < 99999)
    {
        int r = rand() % numBooks;
        if(wants[r] || reads[r]) continue;

        cout << "\t\t(want  ";
        cout << bookNames[r] << ")" << endl;

        reads[r] = true;
        ++readsDone;
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
    if(argc <= 5) { usage(); exit(-1); }
    numBooks  = atoi(args[1]);
    numPreds  = atoi(args[2]);
    numParals = atoi(args[3]);
    numWants  = atoi(args[4]);
    numReads  = atoi(args[5]);
    if(numPreds >= numBooks)
      { cout << "Too many preds" << endl; exit(-1); }
    if(numPreds + numParals >= numBooks)
      { cout << "Too many parals" << endl; exit(-1); }
    if(numWants > numBooks)
      { cout << "Too many wants" << endl; exit(-1); }
    if(numWants + numReads > numBooks)
      { cout << "Too many reads" << endl; exit(-1); }


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
    coutReads(); cout << endl;
    coutPGMs(); cout << endl;
    cout << tail << endl;
    return 0;
}

