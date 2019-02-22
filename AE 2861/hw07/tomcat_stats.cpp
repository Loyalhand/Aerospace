//Name: Gari Pahayo       //Date:
//Course ae 2861
//file: hw08
//Purpose: Calculates pr & tr

#include <fstream>
#include <iostream>
using namespace std;

//descript:
//pre;
//post
double term1(float rho);

//descript:
//pre;
//post
double term2(float rho);

//descript: calculates min thrust required
//pre:
//post: cout min thrust required
/*void mintr();*/

int main()
{
  long double tr[760];
  long double powreq[760];
  float rho;
  ofstream tom;
  ofstream cat;
  /*------------------------------------------------------*/

  do
  {
    tom.clear();
    tom.open("thrust_req.txt");
  }
  while (!tom);

  do
  {
    cat.clear();
    cat.open("pow_req.txt");
  }
  while (!cat);
  /*------------------------------------------------------*/

  cout << "enter rho: ";
  cin>>rho;
  /*------------------------------------------------------*/

  for (int v=0;v<755;v++)
  {
    tr[v]= term1(rho)*v*v+term2(rho)/v/v;
    tom<<v<<"\t"<<tr[v] <<endl;
  }

  for (int v=0;v<755;v++)
  {
    powreq[v]= v*(term1(rho)*v*v+term2(rho)/v/v);
    cat<<v<< "\t"<<powreq[v] <<endl;
  }

  cout<< "Thrust and power required now in txt files, end of program!";

  /*------------------------------------------------------*/

  return 0;
}
/*------------------------------------------------------*/
double term1(float rho)
{
  const double w = 271737;
  const double cdo = .027;
  const double e = .9;
  const double pi = 3.14;
  const double s = 54.5;
  const double ar = 7.01;
  long double term1;

  term1 = .5*rho*s*cdo;

  return term1;
}
/*------------------------------------------------------*/
double term2(float rho)
{
  const double w = 271737;
  const double cdo = .027;
  const double e = .9;
  const double pi = 3.14;
  const double s = 54.5;
  const double ar = 7.01;
  long double term2;

  term2 = w*w/(.5*rho*s*pi*e*ar);

  return term2;
}
