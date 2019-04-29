function [mkp,Pkp] = kf_update(mkm,Pkm,zk,Hk,Rk,Lk)

%%%%
% DESCRIPTION
%   Kalman filter update
% 
% SYNTAX 
%   [MKP,PKP] = KF_PROP(MKM,PKM,HK,ZK,LK,RK)
% 
% INPUTS
%   mkm - a Posteriori mean from previous time step        [nx1]
%   Pkm - a Posteriori covariance from previous time step  [nxn] 
%   zk  - Measurement                                      [1x1]
%   Hk  - Measurement model                                [1xn]
%   Rk  - Measurement noise                                [1x1]
%   Lk  - Measurement nosie map                            [1x1]
% 
% OUTPUTS
%   mkp   - a Posteriori mean from current time step       [nx1]
%   Pkp   - a Posteriori covariance from current time step [nxn]
% 
% DEPENDENCIES
%   CAR_EOMS - eoms for constant acceleration of a car
% 
% NOTES
%   State dimension is n
%   Time vector length is N
%
%%%%

    % Measurement estimate
    ek = Hk*mkm;
    % Innovation covariance
    Wk = Hk*Pkm*Hk'+Lk+Rk+Lk';
    % Cross covariance
    Ck= Pkm*Hk';
    % Kalman gain
    Kk = Pkm*Hk'/Wk;
    % Mean update
    mkp = mkm+Kk*(zk-ek);
    % Covariance update
    Pkp = Pkm-Ck*Kk'-Kk*Ck'+Kk*Wk*Kk';
    
end