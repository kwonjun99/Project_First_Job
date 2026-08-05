%% ACC Project Initialization
clearvars;
clc;

%% Simulation settings
Ts   = 0.05;     % Simulation step [s]
Tsim = 60;       % Simulation time [s]

%% Ego vehicle initial conditions
v_ego0 = 20;     % Initial ego speed [m/s]
x_ego0 = 0;      % Initial ego position [m]

%% Lead vehicle initial conditions
x_lead0 = 60;    % Initial lead position [m]

%% ACC settings
v_set = 25;      % Set speed [m/s], 90 km/h
d0    = 10;      % Minimum standstill distance [m]
T_gap = 1.5;     % Desired time gap [s]

%% Speed controller gains
Kp_v = 0.6;
Ki_v = 0.08;

%% Distance controller gains
Kp_d = 0.25;
Kd_d = 0.8;

%% Acceleration limits
a_max = 2.0;     % Maximum acceleration [m/s^2]
a_min = -4.0;    % Maximum braking [m/s^2]

%% Lead vehicle speed scenario
% 0~10 s  : 22 m/s
% 10~15 s : 22 -> 15 m/s
% 15~30 s : 15 m/s
% 30~35 s : 15 -> 25 m/s
% 35~45 s : 25 m/s
% 45~50 s : 25 -> 18 m/s
% 50~60 s : 18 m/s

leadTime = [
     0
    10
    15
    30
    35
    45
    50
    60
];

leadSpeed = [
    22
    22
    15
    15
    25
    25
    18
    18
];

v_lead_ts = timeseries(leadSpeed, leadTime);
v_lead_ts.DataInfo.Interpolation = tsdata.interpolation('linear');

disp("ACC initialization completed.");
disp("Set speed: " + v_set * 3.6 + " km/h");
disp("Desired time gap: " + T_gap + " s");