//Name: Gari Pahayo       //Date:
//Course ae 2861
//file: hw08
//Purpose: Calculates performance of p51

#include <fstream>
#include <iostream>
#include <cmath>
using namespace std;

//descript:calculates first term of thrust req equation
//pre;
//post
double term1(float rho);

//descript: calculates second term of thrust req equation
//pre;
//post
double term2(float rho);

//descript:makes thrust text
//pre;
//post
void get_thrust (float rho,long double tr[]);

//descript:  powers given is in hp. hint multiply by 550 to get standard units
//pre;
//post
void get_power (float rho,long double tr[],long double powreq[],long double pa[]);

//descript:makes rc txt
//pre:
//post:
void get_rc (float rho,long double powreq[],long double pa[],long double rc[]);

//descript:  finds the max rc
//pre:
//post:
double find_maxrc (long double rc[],double & maxrc);

//descript:
//pre:
//post:
void get_hodo (long double rc[],long double v_horizontal[]);

//descript:
//pre:
//post:
void get_theta (long double rc[]);


/*----------------------- specs ---------------------------*/
const short velocity_range = 751;//global variable
const long double brake_pow = 819500;//in foot *lb/s
const double w = 9800;//lbf
const double cdo = .0163;//parasite
const double e = .8; //oswald eff
const double pi = 3.14;
const double s = 233.19; // planform area ft^2
const double ar = 5.88;
const double rho_slvl = .002376;
const float clmax = 2.09;
const float prop_eff = .83;
float vstall;
/*---------------------------------------------------------*/
ofstream mus;
ofstream tang;
ofstream r_c;
ofstream hood;
ofstream theta;

int main()
{
  long double tr[760];
  long double powreq[760];
  long double pa[750];
  long double rc[760];
  float rho;
  double maxrc;
  long double v_horizontal[760];

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

  do
  {
    r_c.clear();
    r_c.open("rc.txt");
  }
  while (!r_c);

  do
  {
    hood.clear();
    hood.open("hood.txt");
  }
  while (!hood);


  do
  {
    theta.clear();
    theta.open("theta.txt");
  }
  while (!theta);

  cout << "enter rho: ";
  cin>>rho;

  vstall = sqrt(2*w/(rho*s*clmax));
  get_thrust(rho,tr);
  get_power(rho,tr,powreq,pa);
  get_rc(rho,powreq,pa,rc);
  find_maxrc(rc,maxrc);
  get_hodo(rc,v_horizontal);
  get_theta(rc);

  cout<< "Thrust and power required now in txt files, end of program!"<<endl;
  cout<< "v stall is: "<<vstall<<endl;
  cout<< "max rc is: " <<maxrc<<endl;
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
void get_thrust(float rho,long double tr[])
{
   for (int v=static_cast <int> (vstall);v<velocity_range;v++)
  {
    tr[v]= term1(rho)*v*v+term2(rho)/v/v;
    mus<<v<<"\t"<<tr[v] <<endl;
  }
  return;
}

void get_power (float rho,long double tr[],long double powreq[],long double pa[])
{
  for (int v=static_cast <int> (vstall);v<velocity_range;v++)
  {
    powreq[v]= v*(term1(rho)*v*v+term2(rho)/v/v);
    pa[v] = brake_pow*prop_eff*rho/rho_slvl;
    tang<<v<< "\t"<<powreq[v]/550<<"\t"<< pa[v]/550<<endl;
  }
  return;
}

void get_rc (float rho,long double powreq[],long double pa[],long double rc[])
{
  for (int v=static_cast <int> (vstall);v<velocity_range;v++)
  {
    rc[v] = (-powreq[v] + pa[v])/w; // outputs in ft/s
    r_c<<v<<"\t"<<rc[v]<<endl;
  }
  return;
}

double find_maxrc (long double rc[],double & maxrc)
{
  double temp = rc[static_cast <int> (vstall)];

  for (int v=static_cast <int> (vstall);v<velocity_range;v++)
  {

   if (temp < rc[v])
   {
     temp = rc[v];
     maxrc = temp;
   }
  }
  return maxrc;
}

void get_hodo (long double rc[],long double v_horizontal[])
{
  for (int v=static_cast <int> (vstall);v<velocity_range;v++)
  {
    v_horizontal[v] = sqrt(pow(v,2)-pow(rc[v],2)); // outputs in ft/s
    hood<<v_horizontal[v]<<"\t"<<rc[v]<<endl;
  }
  return;
}

void get_theta(long double rc[])
{
  for (int v=static_cast <int> (vstall);v<velocity_range;v++)
  {
    theta<< v<< "\t"<<asin(rc[v]/v)<<endl;
  }
  return;
}


