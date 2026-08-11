%% init_AEB.m
% Autonomous Emergency Braking Project
%
% Scenario 1 : 정지 차량 접근
% Scenario 2 : 저속 선행 차량 접근
% Scenario 3 : 선행 차량 급제동
%
% 주의:
% clear / clearvars / clear all 사용 금지
% -> 외부에서 설정한 scenario_case가 삭제될 수 있음

close all;
clc;

fprintf("\n");
fprintf("========================================\n");
fprintf("        AEB PROJECT INITIALIZATION\n");
fprintf("========================================\n");


%% =========================================================
% 1. Scenario Selection
% ==========================================================

% 외부에서 scenario_case를 지정하지 않았으면
% 기본값으로 Scenario 1 사용

if ~exist("scenario_case", "var")
    scenario_case = 1;
end


%% =========================================================
% 2. Simulation Settings
% ==========================================================

Ts   = 0.05;     % 제어 및 시뮬레이션 기본 주기 [s]
Tsim = 10;       % 전체 시뮬레이션 시간 [s]


%% =========================================================
% 3. Ego Vehicle Common Initial Condition
% ==========================================================

x_ego0 = 0;      % Ego 초기 위치 [m]


%% =========================================================
% 4. Vehicle Limits
% ==========================================================

a_max = 2.0;     % 최대 가속도 [m/s^2]

% AEB Brake Command 기준값
a_normal  =  0.0;    % NORMAL
a_warning =  0.0;    % WARNING
a_partial = -3.0;    % PARTIAL_BRAKE
a_full    = -6.0;    % FULL_BRAKE

% Open-loop baseline 확인용
% 현재 Closed-loop AEB에서는 Ego Vehicle에 직접 연결하지 않음
a_cmd_test = 0.0;


%% =========================================================
% 5. AEB Activation Thresholds
% ==========================================================

% TTC가 작아질수록 충돌 위험 증가

TTC_warning = 4.0;       % WARNING 진입 [s]
TTC_partial = 3.0;       % PARTIAL_BRAKE 진입 [s]
TTC_full    = 2.0;       % FULL_BRAKE 진입 [s]

% TTC 외에 거리 기반 FULL BRAKE 조건
d_full = 15.0;           % [m]


%% =========================================================
% 6. AEB Release Thresholds
% ==========================================================

% 진입 조건과 해제 조건을 다르게 설정하여
% Stateflow 모드가 반복적으로 바뀌는 현상을 줄임
%
% 예:
% FULL 진입 TTC <= 2.0
% FULL 해제 TTC >= 3.0

TTC_warning_release = 5.0;    % WARNING -> NORMAL [s]
TTC_partial_release = 4.0;    % PARTIAL -> WARNING [s]
TTC_full_release    = 3.0;    % FULL -> PARTIAL [s]

d_full_release = 20.0;        % FULL 해제 최소 상대거리 [m]


%% =========================================================
% 7. Scenario Definition
% ==========================================================

switch scenario_case

    %% -----------------------------------------------------
    % Scenario 1
    % 정지 차량 접근
    %
    % Ego    : 20 m/s
    % Target : 0 m/s
    % 초기거리: 100 m
    %
    % Open-loop에서는 약 5초에 충돌
    % ------------------------------------------------------

    case 1

        scenario_name = "Stationary Target";

        v_ego0    = 20;
        x_target0 = 100;

        targetTime = [
            0
            Tsim
        ];

        targetSpeed = [
            0
            0
        ];


    %% -----------------------------------------------------
    % Scenario 2
    % 저속 선행 차량 접근
    %
    % Ego    : 25 m/s
    % Target : 10 m/s
    % 초기거리: 80 m
    % ------------------------------------------------------

    case 2

        scenario_name = "Slow Target";

        v_ego0    = 25;
        x_target0 = 80;

        targetTime = [
            0
            Tsim
        ];

        targetSpeed = [
            10
            10
        ];


    %% -----------------------------------------------------
    % Scenario 3
    % 선행 차량 급제동
    %
    % Ego와 Target 모두 22 m/s로 주행
    % 2초부터 Target이 감속 시작
    % 3초에 Target 속도 5 m/s
    % 이후 5 m/s 유지
    % ------------------------------------------------------

    case 3

        scenario_name = "Target Hard Braking";

        v_ego0    = 22;
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


    otherwise

        error( ...
            "Invalid scenario_case: %d. Use 1, 2, or 3.", ...
            scenario_case);

end


%% =========================================================
% 8. Target Vehicle Speed Profile
% ==========================================================

% From Workspace 블록에서 사용할 Timeseries
%
% Simulink:
% From Workspace
% Data = v_target_ts

v_target_ts = timeseries( ...
    targetSpeed, ...
    targetTime);

% 급제동 Scenario에서 속도가 계단처럼 순간적으로 변하지 않고
% 지정된 시간 동안 선형적으로 감소하도록 설정

v_target_ts.DataInfo.Interpolation = ...
    tsdata.interpolation('linear');


%% =========================================================
% 9. Compatibility Variables
% ==========================================================

% 첫 Target 속도를 별도 변수로 저장
% 다른 블록 또는 분석 코드에서 사용할 수 있음

v_target0 = targetSpeed(1);

% 초기 상대거리

d_rel0 = x_target0 - x_ego0;

% 초기 Closing Speed

v_closing0 = v_ego0 - v_target0;


%% =========================================================
% 10. Initial TTC
% ==========================================================

if d_rel0 <= 0

    TTC0 = 0;

elseif v_closing0 > 0.1

    TTC0 = d_rel0 / v_closing0;

else

    TTC0 = 99;

end


%% =========================================================
% 11. Print Initialization Information
% ==========================================================

fprintf("\n");
fprintf("Scenario %d : %s\n", ...
    scenario_case, scenario_name);

fprintf("----------------------------------------\n");

fprintf("Simulation time     : %.2f s\n", Tsim);
fprintf("Sample time         : %.3f s\n", Ts);

fprintf("\n");

fprintf("Ego initial speed   : %.2f m/s\n", ...
    v_ego0);

fprintf("Target initial speed: %.2f m/s\n", ...
    v_target0);

fprintf("Initial distance    : %.2f m\n", ...
    d_rel0);

fprintf("Closing speed       : %.2f m/s\n", ...
    v_closing0);

fprintf("Initial TTC         : %.2f s\n", ...
    TTC0);

fprintf("\n");

fprintf("AEB TTC Thresholds\n");
fprintf("WARNING             : %.2f s\n", TTC_warning);
fprintf("PARTIAL BRAKE       : %.2f s\n", TTC_partial);
fprintf("FULL BRAKE          : %.2f s\n", TTC_full);

fprintf("\n");

fprintf("Brake Commands\n");
fprintf("NORMAL              : %.2f m/s^2\n", a_normal);
fprintf("WARNING             : %.2f m/s^2\n", a_warning);
fprintf("PARTIAL BRAKE       : %.2f m/s^2\n", a_partial);
fprintf("FULL BRAKE          : %.2f m/s^2\n", a_full);

fprintf("========================================\n");