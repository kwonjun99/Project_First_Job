% Parameter initialization file for lateral vehicle model

% Simuliation Parameter
T_final = 252;

% Tire Parameters
Calpha = 39000;
mu = 0.9;
Kalpha = 19;

% Vehicle parameters 
m = 2045;
Izz = 5428;
lf = 1.488;
lr = 1.712;
l = lf + lr;

% Initial Values
yaw_rate0 = 0;
Vy0 = 0;
Yaw0 = 0;
X0 = 0;
Y0 = 0;

% Controller Parameters
Ke = 6000;
Cf = 38925;
Cr = 38255;
Tc = 0.1;
max_steer = 30 * pi/180;
