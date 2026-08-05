%% AEB Project Initialization
% MATLAB/Simulink Autonomous Emergency Braking Project

close all;
clc;

%% Simulation settings

Ts   = 0.05;    % Simulation step [s]
Tsim = 8;       % Simulation time [s]

%% Ego vehicle initial condition

v_ego0 = 20;    % Initial ego speed [m/s]
x_ego0 = 0;     % Initial ego position [m]

%% Target vehicle initial condition

v_target0 = 0;      % Stationary target vehicle [m/s]
x_target0 = 100;    % Initial target position [m]

%% Test acceleration command
% AEB controller is not implemented yet.
% The ego vehicle maintains constant speed.

a_cmd_test = 0;     % [m/s^2]

%% Vehicle limits

a_max  = 2.0;       % Maximum acceleration [m/s^2]
a_full = -6.0;      % Full emergency braking [m/s^2]

%% AEB threshold parameters
% These parameters will be used in the next modeling step.

TTC_warning = 4.0;      % [s]
TTC_partial = 3.0;      % [s]
TTC_full    = 2.0;      % [s]

d_full = 15;            % Emergency distance threshold [m]

fprintf("====================================\n");
fprintf("AEB INITIALIZATION\n");
fprintf("====================================\n");
fprintf("Ego initial speed    : %.1f m/s\n", v_ego0);
fprintf("Target initial speed : %.1f m/s\n", v_target0);
fprintf("Initial distance     : %.1f m\n", ...
    x_target0 - x_ego0);
fprintf("Expected collision   : %.1f s\n", ...
    (x_target0 - x_ego0) / ...
    max(v_ego0 - v_target0, 0.1));