%% ACC Project Initialization

clc;

if ~exist("scenario_case", "var")
    scenario_case = 1;
end

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

a_max = 2.0;          % 최대 가속도 [m/s^2]
a_min = -4.0;         % Baseline 모델 최대 감속 [m/s^2]

a_follow_min = -3.0;  % 일반 ACC 추종 시 최대 감속 [m/s^2]
a_emergency  = -6.0;  % Emergency 모드 감속 명령 [m/s^2]

%% Lead Vehicle Scenario Selection

switch scenario_case

    case 1
        % Normal ACC scenario
        x_lead0 = 60;

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

    case 2
        % Emergency braking test scenario
        x_lead0 = 55;

        leadTime = [
             0
             8
             9
            20
            60
        ];

        leadSpeed = [
            22
            22
             5
             5
             5
        ];

    otherwise
        error("scenario_case must be 1 or 2.");
end

v_lead_ts = timeseries(leadSpeed, leadTime);
v_lead_ts.DataInfo.Interpolation = ...
    tsdata.interpolation("linear");
%% ACC mode-logic parameters

follow_on_margin  = 5;      % FOLLOWING 진입 여유 거리 [m]
follow_off_margin = 12;     % CRUISE 복귀 여유 거리 [m]

d_emergency  = 8;           % 비상제동 거리 기준 [m]
TTC_emergency = 1.5;        % 비상제동 진입 TTC [s]
TTC_release   = 2.5;        % 비상제동 해제 TTC [s]

a_follow_min = -3.0;        % 일반 추종 최대 감속 [m/s^2]
a_emergency  = -6.0;        % 비상제동 명령 [m/s^2]