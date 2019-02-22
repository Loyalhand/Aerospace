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

const short velocity_range = 751;//global variable
const long double brake_pow = 819500;//in foot *lb/s
const double w = 9800;//lbf
const double cdo = .0163;//parasite
const double e = .8; //oswald eff
const double pi = 3.14;
const double s = 233.19; // planform area ft^2
const double ar = 5.88;

int main()
{
  const float prop_eff = .83;
  long double tr[760];
  long double powreq[760];
  long double pa[750];
  float rho;
  ofstream mus;
  ofstream tang;
  /*------------------------------------------------------*/

  do
  {
    mus.clear();
    mus.open("thrust_req.txt");
  }
  while (!mus);

  do
  {
    tang.clear();
    tang.open("pow_req.txt");
  }
  while (!tang);
  /*------------------------------------------------------*/

  cout << "enter rho: ";
  cin>>rho;
  /*------------------------------------------------------*/

  for (int v=0;v<velocity_range;v++)
  {
    tr[v]= term1(rho)*v*v+term2(rho)/v/v;
    mus<<v<<"\t"<<tr[v] <<endl;
  }

  for (int v=0;v<velocity_range;v++)
  {
    powreq[v]= v*(term1(rho)*v*v+term2(rho)/v/v);
    pa[v] = brake_pow*prop_eff;
    tang<<v<< "\t"<<powreq[v]/550<<"\t"<< pa[v]/550<<endl;
  }

  cout<< "Thrust and power required now in txt files, end of program!";

  /*------------------------------------------------------*/

  return 0;
}
/*------------------------------------------------------*/
double term1(float rho)
{
  long double term1;

  term1 = .5*rho*s*cdo;

  return term1;
}
/*------------------------------------------------------*/
double term2(float rho)
{
  long double term2;

  term2 = w*w/(.5*rho*s*pi*e*ar);

  return term2;
}

