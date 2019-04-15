function [Tk,mk,rk,Pk] = kf_storage(Tk,mk,rk,Pk,T,mkm,mkp,Pkm,Pkp,xk,k) 

%%%%
% DESCRIPTION
%   Stores some stuff for the Kalman filter
% 
% SYNTAX 
%   [TK,MK,PK] = STORAGE(T,MKM,MKP,PKM,PKP) 
% 
% INPUTS
%   T   - Time                    [1x1]
%   mkm - a priori mean           [nx1]
%   mkp - a posteriori mean       [nx1]
%   Pkm - a priori covariance     [nxn]
%   Pkp - a posteriori covariance [nxn]
% 
% OUTPUTS
%   Tk - Time                     [1x2N]
%   mk - Mean                     [nx2N]
%   rk - State error              [nx2N]
%   Pk - Variance                 [nx2N]
% 
% NOTES
%   State dimension is n
%   Time vector length is N
% 
% DEPENDENCIES
% 
% NOTES
%
%%%%

% Time
Tk(:,2*k)   = T(k+1);
Tk(:,2*k+1) = T(k+1);
% Mean
mk(:,2*k)   = mkm;
mk(:,2*k+1) = mkp;
% State estimate error
rk(:,2*k)   = xk - mkm;
rk(:,2*k+1) = xk - mkp;
% Variance
Pk(:,2*k)   = diag(Pkm);
Pk(:,2*k+1) = diag(Pkp);

return