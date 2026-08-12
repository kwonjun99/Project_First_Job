%% run_vehicle_control_final.m
% Integrated Longitudinal Vehicle Control - Final Automation
%
% 기능
% 1) Scenario 1~3 자동 실행
% 2) 주요 성능 지표 계산
% 3) Scenario별 CSV 저장
% 4) Supervisor mode transition CSV 저장
% 5) 포트폴리오용 PNG 그래프 자동 저장
% 6) 전체 Scenario 요약 CSV 및 비교 그래프 생성
%
% 필요한 To Workspace 변수 (Save format = Timeseries)
%   v_ego_log
%   v_target_log
%   d_rel_log
%   d_des_log
%   ttc_log
%   control_mode_log
%   a_cruise_log
%   a_acc_log
%   a_nominal_log
%   a_aeb_log
%   a_final_log
%   a_plant_input_log

close all;
clc;

%% 1. Project Path
scriptDir  = fileparts(mfilename('fullpath'));
projectDir = fileparts(scriptDir);

modelDir  = fullfile(projectDir, 'model');
imageDir  = fullfile(projectDir, 'images');
resultDir = fullfile(projectDir, 'results');

modelFile = fullfile(modelDir, 'Vehicle_Control.slx');
initFile  = fullfile(modelDir, 'init_vehicle_control.m');

if ~isfile(modelFile)
    error('Vehicle_Control.slx not found: %s', modelFile);
end

if ~isfile(initFile)
    error('init_vehicle_control.m not found: %s', initFile);
end

if ~isfolder(imageDir)
    mkdir(imageDir);
end

if ~isfolder(resultDir)
    mkdir(resultDir);
end

[~, modelName] = fileparts(modelFile);
load_system(modelFile);

disp('=============================================');
disp('  VEHICLE CONTROL FINAL RESULT EXPORT');
disp('=============================================');

fprintf('Model   : %s', modelFile); fprintf('%s', newline);
fprintf('Images  : %s', imageDir); fprintf('%s', newline);
fprintf('Results : %s', resultDir); fprintf('%s', newline);

%% 2. Scenario Information
scenarioIds = [1 2 3];

scenarioLabels = {
    'normal_acc_following'
    'target_hard_braking'
    'emergency_stationary_obstacle'
};

scenarioTitles = {
    'Scenario 1 - Normal ACC Following'
    'Scenario 2 - Target Hard Braking'
    'Scenario 3 - Emergency Stationary Obstacle'
};

allMetrics = cell(numel(scenarioIds), 1);

%% 3. Run All Scenarios
for k = 1:numel(scenarioIds)

    scenarioId    = scenarioIds(k);
    scenarioLabel = scenarioLabels{k};
    scenarioTitle = scenarioTitles{k};

    fprintf('%s', newline);
    disp('=============================================');
    fprintf('Running %s', scenarioTitle); fprintf('%s', newline);
    disp('=============================================');

    %% Initialize
    assignin('base', 'scenario_case', scenarioId);

    logNames = {
        'v_ego_log'
        'v_target_log'
        'd_rel_log'
        'd_des_log'
        'ttc_log'
        'control_mode_log'
        'a_cruise_log'
        'a_acc_log'
        'a_nominal_log'
        'a_aeb_log'
        'a_final_log'
        'a_plant_input_log'
    };

    for n = 1:numel(logNames)
        evalin('base', sprintf('clear %s', logNames{n}));
    end

    assignin('base', 'vehicle_control_init_file', initFile);
    evalin('base', 'run(vehicle_control_init_file);');
    evalin('base', 'clear vehicle_control_init_file');

    appliedScenario = evalin('base', 'scenario_case');

    if appliedScenario ~= scenarioId
        error(['init_vehicle_control.m changed scenario_case. ' ...
               'Do not use clear / clearvars / clear all in the init file.']);
    end

    Ts   = evalin('base', 'Ts');
    Tsim = evalin('base', 'Tsim');

    set_param(modelName, ...
        'SolverType', 'Fixed-step', ...
        'Solver', 'ode4', ...
        'FixedStep', num2str(Ts, '%.15g'), ...
        'StopTime', num2str(Tsim, '%.15g'));

    %% Simulation
    simOut = sim(modelName, ...
        'StopTime', num2str(Tsim, '%.15g'), ...
        'ReturnWorkspaceOutputs', 'on');

    %% Load Signals
    vEgoTs      = getSignal(simOut, 'v_ego_log');
    vTargetTs   = getSignal(simOut, 'v_target_log');
    dRelTs      = getSignal(simOut, 'd_rel_log');
    dDesTs      = getSignal(simOut, 'd_des_log');
    ttcTs       = getSignal(simOut, 'ttc_log');
    modeTs      = getSignal(simOut, 'control_mode_log');
    aCruiseTs   = getSignal(simOut, 'a_cruise_log');
    aACCTs      = getSignal(simOut, 'a_acc_log');
    aNominalTs  = getSignal(simOut, 'a_nominal_log');
    aAEBTs      = getSignal(simOut, 'a_aeb_log');
    aFinalTs    = getSignal(simOut, 'a_final_log');
    aPlantTs    = getSignal(simOut, 'a_plant_input_log');

    t = vEgoTs.Time(:);

    vEgo     = interpSignal(vEgoTs,      t, 'linear');
    vTarget  = interpSignal(vTargetTs,   t, 'linear');
    dRel     = interpSignal(dRelTs,      t, 'linear');
    dDes     = interpSignal(dDesTs,      t, 'linear');
    ttc      = interpSignal(ttcTs,       t, 'previous');
    mode     = round(interpSignal(modeTs, t, 'previous'));
    %% Remove initial Stateflow initialization value

firstValidModeIdx = find( ...
    mode >= 1 & mode <= 4, ...
    1, ...
    'first');

if ~isempty(firstValidModeIdx)

    mode(1:firstValidModeIdx-1) = ...
        mode(firstValidModeIdx);

end

    aCruise  = interpSignal(aCruiseTs,   t, 'previous');
    aACC     = interpSignal(aACCTs,      t, 'previous');
    aNominal = interpSignal(aNominalTs,  t, 'previous');
    aAEB     = interpSignal(aAEBTs,      t, 'previous');
    aFinal   = interpSignal(aFinalTs,    t, 'previous');
    aPlant   = interpSignal(aPlantTs,    t, 'previous');

    %% Collision
    collisionMask = dRel <= 0;
    collisionOccurred = any(collisionMask);

    if collisionOccurred
        collisionIdx   = find(collisionMask, 1, 'first');
        collisionTime  = t(collisionIdx);
        collisionSpeed = vEgo(collisionIdx);
    else
        collisionTime  = NaN;
        collisionSpeed = 0;
    end

    %% TTC
    validTTC = ttc(isfinite(ttc) & ttc >= 0 & ttc < 90);

    if isempty(validTTC)
        minimumTTC = NaN;
    else
        minimumTTC = min(validTTC);
    end

    %% Mode Entry Times
    warningEntry = firstModeTime(t, mode, 2);
    partialEntry = firstModeTime(t, mode, 3);
    fullEntry    = firstModeTime(t, mode, 4);

    %% Mode Durations
    normalDuration  = modeDuration(t, mode, 1);
    warningDuration = modeDuration(t, mode, 2);
    partialDuration = modeDuration(t, mode, 3);
    fullDuration    = modeDuration(t, mode, 4);

    %% Stop Information
    stopIdx = find(vEgo <= 0.05, 1, 'first');

    if isempty(stopIdx)
        stopTime = NaN;
        relativeDistanceAtStop = NaN;
    else
        stopTime = t(stopIdx);
        relativeDistanceAtStop = dRel(stopIdx);
    end

    %% Command Consistency
    commandTrackingError = max(abs(aFinal - aPlant));

    %% Mode Transition Table
    changeIdx = [1; find(diff(mode) ~= 0) + 1];
    transitionMode = mode(changeIdx);

    modeNames = strings(numel(changeIdx), 1);

    for i = 1:numel(changeIdx)
        modeNames(i) = modeName(transitionMode(i));
    end

    transitionTable = table( ...
        t(changeIdx), ...
        transitionMode, ...
        modeNames, ...
        'VariableNames', {'Time_s', 'Mode', 'ModeName'});

    writetable( ...
        transitionTable, ...
        fullfile(resultDir, sprintf('%s_mode_transitions.csv', scenarioLabel)));

    %% Metrics Table
    metrics = table( ...
        scenarioId, ...
        string(scenarioTitle), ...
        min(vEgo), ...
        max(vEgo), ...
        vEgo(end), ...
        min(vTarget), ...
        max(vTarget), ...
        vTarget(end), ...
        dRel(1), ...
        min(dRel), ...
        dRel(end), ...
        dDes(end), ...
        dRel(end) - dDes(end), ...
        minimumTTC, ...
        min(aCruise), ...
        max(aCruise), ...
        min(aACC), ...
        max(aACC), ...
        min(aNominal), ...
        max(aNominal), ...
        min(aAEB), ...
        max(aAEB), ...
        min(aFinal), ...
        max(aFinal), ...
        min(aPlant), ...
        max(aPlant), ...
        commandTrackingError, ...
        warningEntry, ...
        partialEntry, ...
        fullEntry, ...
        normalDuration, ...
        warningDuration, ...
        partialDuration, ...
        fullDuration, ...
        stopTime, ...
        relativeDistanceAtStop, ...
        collisionOccurred, ...
        collisionTime, ...
        collisionSpeed, ...
        'VariableNames', { ...
            'Scenario', ...
            'ScenarioName', ...
            'MinimumEgoSpeed_mps', ...
            'MaximumEgoSpeed_mps', ...
            'FinalEgoSpeed_mps', ...
            'MinimumTargetSpeed_mps', ...
            'MaximumTargetSpeed_mps', ...
            'FinalTargetSpeed_mps', ...
            'InitialRelativeDistance_m', ...
            'MinimumRelativeDistance_m', ...
            'FinalRelativeDistance_m', ...
            'FinalDesiredDistance_m', ...
            'FinalDistanceError_m', ...
            'MinimumTTC_s', ...
            'MinimumCruiseCommand_mps2', ...
            'MaximumCruiseCommand_mps2', ...
            'MinimumACCCommand_mps2', ...
            'MaximumACCCommand_mps2', ...
            'MinimumNominalCommand_mps2', ...
            'MaximumNominalCommand_mps2', ...
            'MinimumAEBCommand_mps2', ...
            'MaximumAEBCommand_mps2', ...
            'MinimumFinalCommand_mps2', ...
            'MaximumFinalCommand_mps2', ...
            'MinimumPlantInput_mps2', ...
            'MaximumPlantInput_mps2', ...
            'MaxCommandTrackingError_mps2', ...
            'WarningEntryTime_s', ...
            'PartialBrakeEntryTime_s', ...
            'FullBrakeEntryTime_s', ...
            'NormalDuration_s', ...
            'WarningDuration_s', ...
            'PartialBrakeDuration_s', ...
            'FullBrakeDuration_s', ...
            'StopTime_s', ...
            'RelativeDistanceAtStop_m', ...
            'CollisionOccurred', ...
            'CollisionTime_s', ...
            'CollisionSpeed_mps'});

    allMetrics{k} = metrics;

    writetable( ...
        metrics, ...
        fullfile(resultDir, sprintf('%s_metrics.csv', scenarioLabel)));

    %% Portfolio Figures
    exportSpeedFigure( ...
        t, vEgo, vTarget, scenarioTitle, ...
        fullfile(imageDir, sprintf('%s_speed.png', scenarioLabel)));

    exportDistanceFigure( ...
        t, dRel, dDes, scenarioTitle, ...
        fullfile(imageDir, sprintf('%s_distance.png', scenarioLabel)));

    exportTTCFigure( ...
        t, ttc, scenarioTitle, ...
        fullfile(imageDir, sprintf('%s_ttc.png', scenarioLabel)));

    exportCommandFigure( ...
        t, aCruise, aACC, aAEB, aFinal, scenarioTitle, ...
        fullfile(imageDir, sprintf('%s_control_commands.png', scenarioLabel)));

    exportModeFigure( ...
        t, mode, scenarioTitle, ...
        fullfile(imageDir, sprintf('%s_supervisor_mode.png', scenarioLabel)));

    %% Console Summary
    fprintf('%s', newline);
    fprintf('Scenario %d summary', scenarioId); fprintf('%s', newline);
    fprintf('Ego final speed           : %.3f m/s', vEgo(end)); fprintf('%s', newline);
    fprintf('Target final speed        : %.3f m/s', vTarget(end)); fprintf('%s', newline);
    fprintf('Minimum relative distance : %.3f m', min(dRel)); fprintf('%s', newline);
    fprintf('Final relative distance   : %.3f m', dRel(end)); fprintf('%s', newline);
    fprintf('Minimum TTC               : %.3f s', minimumTTC); fprintf('%s', newline);
    fprintf('Final command range       : %.3f ~ %.3f m/s^2', min(aFinal), max(aFinal)); fprintf('%s', newline);
    fprintf('Plant input range         : %.3f ~ %.3f m/s^2', min(aPlant), max(aPlant)); fprintf('%s', newline);
    fprintf('Command tracking error    : %.6f m/s^2', commandTrackingError); fprintf('%s', newline);
    fprintf('Modes observed            : ');
    fprintf('%g ', unique(mode)); fprintf('%s', newline);

    if collisionOccurred
        fprintf('Collision                 : YES'); fprintf('%s', newline);
        fprintf('Collision time            : %.3f s', collisionTime); fprintf('%s', newline);
    else
        fprintf('Collision                 : NO'); fprintf('%s', newline);
    end
end

%% 4. Save All Scenario Summary
summaryTable = vertcat(allMetrics{:});

summaryFile = fullfile(resultDir, 'all_scenarios_metrics.csv');
writetable(summaryTable, summaryFile);

%% 5. Final Comparison Figures
exportMinimumDistanceComparison( ...
    summaryTable, ...
    fullfile(imageDir, 'comparison_minimum_distance.png'));

exportMinimumTTCComparison( ...
    summaryTable, ...
    fullfile(imageDir, 'comparison_minimum_ttc.png'));

exportFinalSpeedComparison( ...
    summaryTable, ...
    fullfile(imageDir, 'comparison_final_speed.png'));

%% 6. Final Console Output
fprintf('%s', newline);
disp('=============================================');
disp(' VEHICLE CONTROL FINAL EXPORT COMPLETED');
disp('=============================================');

disp(summaryTable(:, { ...
    'Scenario', ...
    'ScenarioName', ...
    'FinalEgoSpeed_mps', ...
    'MinimumRelativeDistance_m', ...
    'MinimumTTC_s', ...
    'MinimumFinalCommand_mps2', ...
    'CollisionOccurred'}));

fprintf('%s', newline);
fprintf('Saved images : %s', imageDir); fprintf('%s', newline);
fprintf('Saved results: %s', resultDir); fprintf('%s', newline);
fprintf('Summary CSV  : %s', summaryFile); fprintf('%s', newline);

%% Local Functions

function ts = getSignal(simOut, signalName)

    ts = [];

    try
        ts = simOut.get(signalName);
    catch
        ts = [];
    end

    if isempty(ts)
        existsInBase = evalin( ...
            'base', ...
            sprintf('exist(''%s'', ''var'')', signalName));

        if existsInBase
            ts = evalin('base', signalName);
        end
    end

    if isempty(ts)
        error('Signal "%s" not found. Check the To Workspace block.', signalName);
    end

    if ~isa(ts, 'timeseries')
        error(['Signal "%s" must use Save format = Timeseries. ' ...
               'Current type: %s'], signalName, class(ts));
    end
end

function y = interpSignal(ts, queryTime, method)

    sourceTime = ts.Time(:);
    sourceData = squeeze(ts.Data);
    sourceData = sourceData(:);

    [sourceTime, idx] = unique(sourceTime, 'last');
    sourceData = sourceData(idx);

    if numel(sourceTime) == 1
        y = repmat(sourceData(1), size(queryTime));
    else
        y = interp1(sourceTime, sourceData, queryTime, method, 'extrap');
    end

    y = y(:);
end

function entryTime = firstModeTime(t, mode, targetMode)

    idx = find(mode == targetMode, 1, 'first');

    if isempty(idx)
        entryTime = NaN;
    else
        entryTime = t(idx);
    end
end

function duration = modeDuration(t, mode, targetMode)

    if numel(t) < 2
        duration = 0;
        return;
    end

    dt = diff(t);
    duration = sum(dt(mode(1:end-1) == targetMode));
end

function name = modeName(modeValue)

    switch round(modeValue)
        case 1
            name = "NORMAL";
        case 2
            name = "AEB_WARNING";
        case 3
            name = "AEB_PARTIAL";
        case 4
            name = "AEB_FULL";
        otherwise
            name = "INVALID";
    end
end

function exportSpeedFigure(t, vEgo, vTarget, titleText, fileName)

    fig = figure('Visible', 'off', 'Color', 'w', 'Position', [100 100 1000 550]);

    plot(t, vEgo * 3.6, 'LineWidth', 1.8);
    hold on;
    plot(t, vTarget * 3.6, 'LineWidth', 1.8);

    grid on;
    xlabel('Time (s)');
    ylabel('Speed (km/h)');
    title([titleText ' - Vehicle Speed']);

    legend('Ego Vehicle', 'Target Vehicle', 'Location', 'best');

    exportgraphics(fig, fileName, 'Resolution', 200);
    close(fig);
end

function exportDistanceFigure(t, dRel, dDes, titleText, fileName)

    fig = figure('Visible', 'off', 'Color', 'w', 'Position', [100 100 1000 550]);

    plot(t, dRel, 'LineWidth', 1.8);
    hold on;
    plot(t, dDes, '--', 'LineWidth', 1.6);
    yline(0, '--', 'Collision Boundary');

    grid on;
    xlabel('Time (s)');
    ylabel('Distance (m)');
    title([titleText ' - Relative / Desired Distance']);

    legend('Relative Distance', 'Desired Distance', 'Collision Boundary', 'Location', 'best');

    exportgraphics(fig, fileName, 'Resolution', 200);
    close(fig);
end

function exportTTCFigure(t, ttc, titleText, fileName)

    fig = figure('Visible', 'off', 'Color', 'w', 'Position', [100 100 1000 550]);

    ttcPlot = min(ttc, 10);

    plot(t, ttcPlot, 'LineWidth', 1.8);
    hold on;
    yline(4, '--', 'WARNING');
    yline(3, '--', 'PARTIAL');
    yline(2, '--', 'FULL');

    grid on;
    ylim([0 10]);

    xlabel('Time (s)');
    ylabel('TTC (s)');
    title([titleText ' - Time To Collision']);

    exportgraphics(fig, fileName, 'Resolution', 200);
    close(fig);
end

function exportCommandFigure(t, aCruise, aACC, aAEB, aFinal, titleText, fileName)

    fig = figure('Visible', 'off', 'Color', 'w', 'Position', [100 100 1000 550]);

    stairs(t, aCruise, 'LineWidth', 1.5);
    hold on;
    stairs(t, aACC, 'LineWidth', 1.5);
    stairs(t, aAEB, 'LineWidth', 1.5);
    stairs(t, aFinal, 'LineWidth', 2.0);
    yline(0, '--');

    grid on;
    xlabel('Time (s)');
    ylabel('Acceleration Command (m/s^2)');
    title([titleText ' - Control Commands']);

    legend('Cruise', 'ACC', 'AEB', 'Final', 'Location', 'best');

    exportgraphics(fig, fileName, 'Resolution', 200);
    close(fig);
end

function exportModeFigure(t, mode, titleText, fileName)

    fig = figure('Visible', 'off', 'Color', 'w', 'Position', [100 100 1000 550]);

    stairs(t, mode, 'LineWidth', 1.8);

    grid on;
    ylim([0.5 4.5]);
    yticks([1 2 3 4]);
    yticklabels({'NORMAL', 'WARNING', 'PARTIAL', 'FULL'});

    xlabel('Time (s)');
    ylabel('Supervisor Mode');
    title([titleText ' - Supervisor Mode']);

    exportgraphics(fig, fileName, 'Resolution', 200);
    close(fig);
end

function exportMinimumDistanceComparison(summaryTable, fileName)

    fig = figure('Visible', 'off', 'Color', 'w', 'Position', [100 100 1000 550]);

    bar(summaryTable.MinimumRelativeDistance_m);

    grid on;
    xticks(1:height(summaryTable));
    xticklabels({'Normal ACC', 'Hard Braking', 'Emergency Obstacle'});

    ylabel('Minimum Relative Distance (m)');
    title('Integrated Vehicle Control - Minimum Relative Distance');

    exportgraphics(fig, fileName, 'Resolution', 200);
    close(fig);
end

function exportMinimumTTCComparison(summaryTable, fileName)

    fig = figure('Visible', 'off', 'Color', 'w', 'Position', [100 100 1000 550]);

    bar(summaryTable.MinimumTTC_s);

    grid on;
    xticks(1:height(summaryTable));
    xticklabels({'Normal ACC', 'Hard Braking', 'Emergency Obstacle'});

    ylabel('Minimum TTC (s)');
    title('Integrated Vehicle Control - Minimum TTC');

    exportgraphics(fig, fileName, 'Resolution', 200);
    close(fig);
end

function exportFinalSpeedComparison(summaryTable, fileName)

    fig = figure('Visible', 'off', 'Color', 'w', 'Position', [100 100 1000 550]);

    values = [
        summaryTable.FinalEgoSpeed_mps, ...
        summaryTable.FinalTargetSpeed_mps
    ] * 3.6;

    bar(values);

    grid on;
    xticks(1:height(summaryTable));
    xticklabels({'Normal ACC', 'Hard Braking', 'Emergency Obstacle'});

    ylabel('Final Speed (km/h)');
    title('Integrated Vehicle Control - Final Speed');

    legend('Ego Vehicle', 'Target Vehicle', 'Location', 'best');

    exportgraphics(fig, fileName, 'Resolution', 200);
    close(fig);
end
