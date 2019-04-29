function [mkm,Pkm] = kf_prop(mkm1,Pkm1,F,Q,M)

%%%%
% DESCRIPTION
%   Kalman filter proagator
% 
% SYNTAX 
%   [MKM,PKM] = KF_PROP(MKM1,PKM1,OPTS,F,Q,M)
% 
% INPUTS
%   mkm1 - a Posteriori mean from previous time step       [nx1]
%   Pkm1 - a Posteriori covariance from previous time step [nxn]
%   F    - Dynamics modle                                  [nxn]
%   Q    - Process noise PSD                               [nxn]
%   M    - Process noise map                               [nxn]
% 
% OUTPUTS
%   mkm   - a Priori mean from current time step           [nx1]
%   Pkm   - a Priori Covariance from current time step     [nxn]
% 
% DEPENDENCIES
% 
% NOTES
%   State dimension is n
%   Time vector length is N
%
%%%%

    % Mean
    mkm = F*mkm1;
    % Covariance
    Pkm = F*Pkm1*F'+M*Q*M';
end