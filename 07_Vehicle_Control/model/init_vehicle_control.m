%% init_vehicle_control.m
% Integrated Longitudinal Vehicle Control
%
% Cruise Control + ACC + AEB
%
% Scenario 1 : Normal ACC Following
% Scenario 2 : Target Hard Braking
% Scenario 3 : Emergency Stationary Obstacle
%
% 중요:
% clear / clearvars / clear all 사용 금지
% -> MATLAB에서 설정한 scenario_case가 삭제될 수 있음

close all;
clc;

fprintf("\n");
fprintf("============================================\n");
fprintf("     VEHICLE CONTROL INITIALIZATION\n");
fprintf("============================================\n");


%% =========================================================
% 1. Scenario Selection
% ==========================================================

% 외부에서 scenario_case를 지정하지 않았으면
% 기본적으로 Scenario 1 실행

if ~exist("scenario_case", "var")
    scenario_case = 1;
end


%% =========================================================
% 2. Common Simulation Settings
% ==========================================================

Ts = 0.05;                  % Sample time [s]


%% =========================================================
% 3. Ego Vehicle Parameters
% ==========================================================

m = 1600;                   % Vehicle mass [kg]

g = 9.81;                   % Gravity [m/s^2]

Cd  = 0.30;                 % Aerodynamic drag coefficient
A   = 2.2;                  % Frontal area [m^2]
rho = 1.225;                % Air density [kg/m^3]

Crr = 0.015;                % Rolling resistance coefficient


%% =========================================================
% 4. Driver / Cruise Settings
% ==========================================================

v_set = 25.0;               % Cruise target speed [m/s]


%% =========================================================
% 5. Vehicle Acceleration Limits
% ==========================================================

a_max       =  2.0;         % Maximum acceleration [m/s^2]
a_min       = -3.0;         % Normal braking limit [m/s^2]
a_emergency = -6.0;         % Emergency braking limit [m/s^2]


%% =========================================================
% 6. Vehicle Force Limits
% ==========================================================

F_drive_max = m * a_max;

F_brake_max = m * abs(a_emergency);


%% =========================================================
% 7. Cruise Controller Parameters
% ==========================================================

Kp_cruise = 0.80;
Ki_cruise = 0.15;


%% =========================================================
% 8. ACC Desired Distance Parameters
% ==========================================================

d0    = 5.0;                % Standstill distance [m]
T_gap = 1.8;                % Desired time gap [s]


%% =========================================================
% 9. ACC Controller Parameters
% ==========================================================

% ACC control:
%
% a_acc =
% Kp_acc * distance_error
% + Kv_acc * relative_speed

Kp_acc = 0.08;
Kv_acc = 0.40;


%% =========================================================
% 10. AEB Activation Thresholds
% ==========================================================

TTC_warning = 4.0;          % WARNING threshold [s]
TTC_partial = 3.0;          % PARTIAL BRAKE threshold [s]
TTC_full    = 2.0;          % FULL BRAKE threshold [s]

d_full = 15.0;              % Distance based FULL BRAKE [m]


%% =========================================================
% 11. AEB Release Thresholds
% ==========================================================

% Activation threshold와 Release threshold를 다르게 두어서
% Stateflow 모드가 경계값 근처에서 반복적으로 바뀌는 것을 방지

TTC_warning_release = 5.0;
TTC_partial_release = 4.0;
TTC_full_release    = 3.0;

d_full_release = 20.0;


%% =========================================================
% 12. AEB Braking Commands
% ==========================================================

% 현재 최종 arbitration은 MIN 블록을 사용한다.
%
% 따라서 NORMAL / WARNING에서는
% AEB가 Cruise / ACC를 방해하지 않도록
% 최대 허용 가속도 값을 출력한다.

a_aeb_normal  = a_max;      % +2.0 m/s^2
a_aeb_warning = a_max;      % +2.0 m/s^2

a_aeb_partial = -3.0;       % Partial braking
a_aeb_full    = -6.0;       % Full emergency braking


%% =========================================================
% 13. Open-loop Test Command
% ==========================================================

% Vehicle Plant 단독 테스트용
% 현재 통합 제어에서는 Ego Vehicle에 직접 연결하지 않음

a_cmd_test = 0.0;


%% =========================================================
% 14. Scenario Definition
% ==========================================================

switch scenario_case


    %% -----------------------------------------------------
    % Scenario 1
    % Normal ACC Following
    %
    % Ego:
    %   initial speed = 20 m/s
    %
    % Target:
    %   constant speed = 18 m/s
    %   initial distance = 80 m
    %
    % 목적:
    % Cruise로 가속하다가 선행차에 접근하면
    % ACC가 개입하여 안전거리 유지
    %
    % AEB는 정상적으로 개입하지 않는 것이 목표
    % ------------------------------------------------------

    case 1

        scenario_name = "Normal ACC Following";

        Tsim = 20;

        % Ego
        v_ego0 = 20;
        x_ego0 = 0;

        % Target
        x_target0 = 80;

        targetTime = [
            0
            Tsim
        ];

        targetSpeed = [
            18
            18
        ];


    %% -----------------------------------------------------
    % Scenario 2
    % Target Hard Braking
    %
    % Ego / Target 모두 22 m/s로 주행
    %
    % 2초부터 Target 감속 시작
    % 3초에 Target = 5 m/s
    %
    % 목적:
    % ACC가 먼저 대응하고
    % 위험이 커지면 AEB가 Override 하는지 검증
    % ------------------------------------------------------

    case 2

        scenario_name = "Target Hard Braking";

        Tsim = 15;

        % Ego
        v_ego0 = 22;
        x_ego0 = 0;

        % Target
        x_target0 = 65;

        targetTime = [
            0
            2
            3
            Tsim
        ];

        targetSpeed = [
            22
            22
             5
             5
        ];


    %% -----------------------------------------------------
    % Scenario 3
    % Emergency Stationary Obstacle
    %
    % Ego:
    %   20 m/s
    %
    % Target:
    %   stationary
    %   initial distance = 45 m
    %
    % Initial TTC:
    %
    % 45 / 20 = 2.25 s
    %
    % 시작부터 위험도가 높은 상황
    %
    % 목적:
    % AEB PARTIAL / FULL 개입 및
    % 충돌 회피 성능 검증
    % ------------------------------------------------------

    case 3

        scenario_name = "Emergency Stationary Obstacle";

        Tsim = 10;

        % Ego
        v_ego0 = 20;
        x_ego0 = 0;

        % Target
        x_target0 = 45;

        targetTime = [
            0
            Tsim
        ];

        targetSpeed = [
            0
            0
        ];


    otherwise

        error( ...
            "Invalid scenario_case: %d. Use 1, 2, or 3.", ...
            scenario_case);

end


%% =========================================================
% 15. Target Vehicle Speed Profile
% ==========================================================

% Simulink From Workspace 블록에서 사용
%
% From Workspace:
%
% Data = v_target_ts

v_target_ts = timeseries( ...
    targetSpeed, ...
    targetTime);


% Scenario 2에서 Target 속도가
% 2~3초 사이에 선형적으로 감소하도록 설정

v_target_ts.DataInfo.Interpolation = ...
    tsdata.interpolation("linear");


%% =========================================================
% 16. Compatibility / Initial Variables
% ==========================================================

% 초기 Target 속도

v_target0 = targetSpeed(1);


% 초기 상대거리

d_rel0 = x_target0 - x_ego0;


% ACC에서 사용하는 초기 상대속도
%
% 음수:
% Ego가 Target보다 빠름

v_rel0 = v_target0 - v_ego0;


% AEB에서 사용하는 Closing Speed
%
% 양수:
% Ego가 Target에 접근

v_closing0 = v_ego0 - v_target0;


%% =========================================================
% 17. Initial Desired Distance
% ==========================================================

d_des0 = d0 + T_gap * v_ego0;

distance_error0 = d_rel0 - d_des0;


%% =========================================================
% 18. Initial TTC
% ==========================================================

if d_rel0 <= 0

    TTC0 = 0;

elseif v_closing0 > 0.1

    TTC0 = d_rel0 / v_closing0;

else

    TTC0 = 99;

end


%% =========================================================
% 19. Initial Vehicle Resistance
% ==========================================================

F_aero0 = ...
    0.5 * rho * Cd * A * v_ego0^2;

F_roll0 = ...
    Crr * m * g;

F_resistance0 = ...
    F_aero0 + F_roll0;


%% =========================================================
% 20. Print Initialization Information
% ==========================================================

fprintf("\n");

fprintf("Scenario %d\n", ...
    scenario_case);

fprintf("%s\n", ...
    scenario_name);

fprintf("--------------------------------------------\n");


%% Simulation

fprintf("\nSimulation\n");

fprintf("Sample time          : %.3f s\n", ...
    Ts);

fprintf("Simulation time      : %.2f s\n", ...
    Tsim);


%% Ego / Target

fprintf("\nInitial Vehicle State\n");

fprintf("Ego speed            : %.2f m/s\n", ...
    v_ego0);

fprintf("Target speed         : %.2f m/s\n", ...
    v_target0);

fprintf("Initial distance     : %.2f m\n", ...
    d_rel0);

fprintf("Relative speed       : %.2f m/s\n", ...
    v_rel0);

fprintf("Closing speed        : %.2f m/s\n", ...
    v_closing0);


%% ACC

fprintf("\nACC\n");

fprintf("Desired distance     : %.2f m\n", ...
    d_des0);

fprintf("Distance error       : %.2f m\n", ...
    distance_error0);

fprintf("Time gap             : %.2f s\n", ...
    T_gap);


%% AEB

fprintf("\nAEB\n");

fprintf("Initial TTC          : %.2f s\n", ...
    TTC0);

fprintf("TTC WARNING          : %.2f s\n", ...
    TTC_warning);

fprintf("TTC PARTIAL          : %.2f s\n", ...
    TTC_partial);

fprintf("TTC FULL             : %.2f s\n", ...
    TTC_full);


%% Control limits

fprintf("\nControl Limits\n");

fprintf("Maximum acceleration : %.2f m/s^2\n", ...
    a_max);

fprintf("Normal braking       : %.2f m/s^2\n", ...
    a_min);

fprintf("AEB partial braking  : %.2f m/s^2\n", ...
    a_aeb_partial);

fprintf("AEB full braking     : %.2f m/s^2\n", ...
    a_aeb_full);


%% Vehicle model

fprintf("\nVehicle Resistance at Initial Speed\n");

fprintf("Aerodynamic drag     : %.2f N\n", ...
    F_aero0);

fprintf("Rolling resistance   : %.2f N\n", ...
    F_roll0);

fprintf("Total resistance     : %.2f N\n", ...
    F_resistance0);


fprintf("============================================\n");