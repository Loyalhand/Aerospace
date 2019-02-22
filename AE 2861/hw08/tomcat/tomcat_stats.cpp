//Name: Gari Pahayo       //Date:
//Course ae 2861
//file: hw08
//Purpose: Calculates pr & tr

#include <fstream>
#include <iostream>
#include <cmath>
using namespace std;

//descript:
//pre;
//post
double term1(float rho);

//descript:
//pre;
//post
double term2(float rho);
/*-------------------------------------------------------*/
const short velocity_range = 751;//global variable
const double ta_slvl = 130000;
const float clmax = 2.8;
  const double w = 194621;
  const double cdo = .027;
  const double e = .9;
  const double pi = 3.14;
  const double s = 54.5;
  const double ar = 7.01;
  const float rho_slvl = 1.225;
/*--------------------------------------------------------*/
int main()
{
  long double tr[760];
  long double powreq[760];
  long double pa[750];
  float rho;
  float vstall;
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
  vstall = sqrt(2*w/(rho*s*clmax));

  for (int v=static_cast <int> (vstall);v<velocity_range;v++)
  {
    tr[v]= term1(rho)*v*v+term2(rho)/v/v;
    tom<<v<<"\t"<<tr[v] <<endl;
  }

  for (int v=static_cast <int> (vstall);v<velocity_range;v++)
  {
    powreq[v]= v*(term1(rho)*v*v+term2(rho)/v/v);
    pa[v] = v*ta_slvl*rho/rho_slvl;
    cat<<v<< "\t"<<powreq[v]<<"\t"<< pa[v] <<endl;
  }


  cout<< "Thrust and power required now in txt files, end of program!"<<endl;
  cout<< "v stall is: "<<vstall<<endl;


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

