//Name: Gari Pahayo       //Date:
//Course ae 2861
//file: hw08
//Purpose: Calculates performance of p51
//change specs and txt file names for different plane

#include <iostream>
#include <cmath>

float get_vstall(float rho);

//descript:
//pre:
//post:
double get_cl_cube_sqrt_over_cd();

//descript:
//pre:
//post:
double get_cl_over_cd();

//descript:
//pre:
//post:
double get_range();

//descript:
//pre:
//post:
double get_endurace(double clcd32,float rho);



/*----------------------- specs ---------------------------*/
const short velocity_range = 751;//global variable
const long double brake_pow = 819500;//in foot *lb/s
const double W_n = 9800;//lbf
const double cdo = .0163;//parasite
const double e = .8; //oswald eff
const double pi = 3.14;
const double s = 233.19; // planform area ft^2
const double ar = 5.88;
const double rho_lvl = .002376;
const float clmax = 2.09;
const float prop_eff = .83;
const float wing_span = 37.04;
const double w_max = 11800;
const double w_empty = 6985;
const double Max_fuel_cap = 1511; // in lbf
const long double sfc = 3*pow(10,-7);
/*---------------------------------------------------------*/

int main()
{
  float rho;
  double clcd32;

  std::cout<< "enter rho: ";
  std::cin>>rho;
  std::cout<< "v stall is: "<<get_vstall(rho)<<std::endl;

  clcd32 = get_cl_cube_sqrt_over_cd();
  std::cout<< "endurance is: "<<get_cl_over_cd();


  return 0;
}
float get_vstall(float rho)
{
  float vstall;
  vstall = sqrt(2*w_max/(rho*s*clmax));
  return vstall;
}

double get_cl_over_cd()
{
  double value;
  value = sqrt(cdo*pi*e*ar)/(2*cdo);
  return value;
}

double get_cl_cube_sqrt_over_cd()
{
  double value;
  value = 1/pow(3*cdo*pi*ar,4)/(4*cdo);
  return value;
}

double get_endurace(double clcd32,float rho)
{
  double value;
/*  value = prop_eff*clcd32*sqrt(2*rho*s)*(1/(sqrt(w_max)-pow(w_max-Max_fuel_cap,.5))/(sfc);
  return value;*/
}
