%% run_AEB_final.m
% AEB Project - Final Simulation / Result Export
%
% 저장 위치:
%   06_AEB_Project/scripts/run_AEB_final.m
%
% 필요한 To Workspace 변수 (Save format = Timeseries):
%   v_target_log, v_ego_log, d_rel_log, v_closing_log
%   ttc_log, aeb_mode_log, a_cmd_log

close all;
clc;

%% 1. Project path

scriptDir  = fileparts(mfilename('fullpath'));
projectDir = fileparts(scriptDir);

modelDir  = fullfile(projectDir, 'model');
imageDir  = fullfile(projectDir, 'images');
resultDir = fullfile(projectDir, 'results');

modelFile = fullfile(modelDir, 'AEB_Project.slx');
initFile  = fullfile(modelDir, 'init_AEB.m');

if ~isfile(modelFile)
    error('AEB model not found: %s', modelFile);
end

if ~isfile(initFile)
    error('init_AEB.m not found: %s', initFile);
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
disp('         AEB FINAL RESULT EXPORT');
disp('=============================================');
fprintf('Model   : %s', modelFile); fprintf('%s', newline);
fprintf('Images  : %s', imageDir); fprintf('%s', newline);
fprintf('Results : %s', resultDir); fprintf('%s', newline);

%% 2. Scenario information

scenarioIds = [1 2 3];

scenarioLabels = {
    'stationary_target'
    'slow_target'
    'hard_braking'
};

scenarioTitles = {
    'Scenario 1 - Stationary Target'
    'Scenario 2 - Slow Target'
    'Scenario 3 - Target Hard Braking'
};

allMetrics = cell(numel(scenarioIds), 1);

%% 3. Run all scenarios

for k = 1:numel(scenarioIds)

    scenarioId    = scenarioIds(k);
    scenarioLabel = scenarioLabels{k};
    scenarioTitle = scenarioTitles{k};

    fprintf('%s', newline);
    disp('=============================================');
    fprintf('Running %s', scenarioTitle); fprintf('%s', newline);
    disp('=============================================');

    %% 3-1. Initialize

    assignin('base', 'scenario_case', scenarioId);

    logNames = {
        'v_target_log'
        'v_ego_log'
        'd_rel_log'
        'v_closing_log'
        'ttc_log'
        'aeb_mode_log'
        'a_cmd_log'
    };

    for n = 1:numel(logNames)
        evalin('base', sprintf('clear %s', logNames{n}));
    end

    assignin('base', 'aeb_init_file', initFile);
    evalin('base', 'run(aeb_init_file);');
    evalin('base', 'clear aeb_init_file');

    appliedScenario = evalin('base', 'scenario_case');

    if appliedScenario ~= scenarioId
        error(['init_AEB.m changed scenario_case. ' ...
               'Do not use clear / clearvars / clear all in init_AEB.m.']);
    end

    Ts   = evalin('base', 'Ts');
    Tsim = evalin('base', 'Tsim');

    set_param(modelName, ...
        'SolverType', 'Fixed-step', ...
        'Solver', 'ode4', ...
        'FixedStep', num2str(Ts, '%.15g'), ...
        'StopTime', num2str(Tsim, '%.15g'));

    %% 3-2. Simulation

    simOut = sim(modelName, ...
        'StopTime', num2str(Tsim, '%.15g'), ...
        'ReturnWorkspaceOutputs', 'on');

    %% 3-3. Load signals

    vTargetTs  = getSignal(simOut, 'v_target_log');
    vEgoTs     = getSignal(simOut, 'v_ego_log');
    dRelTs     = getSignal(simOut, 'd_rel_log');
    vClosingTs = getSignal(simOut, 'v_closing_log');
    ttcTs      = getSignal(simOut, 'ttc_log');
    modeTs     = getSignal(simOut, 'aeb_mode_log');
    aCmdTs     = getSignal(simOut, 'a_cmd_log');

    t = vEgoTs.Time(:);

    vTarget  = interpSignal(vTargetTs,  t, 'linear');
    vEgo     = interpSignal(vEgoTs,     t, 'linear');
    dRel     = interpSignal(dRelTs,     t, 'linear');
    vClosing = interpSignal(vClosingTs, t, 'linear');
    ttc      = interpSignal(ttcTs,      t, 'previous');
    mode     = round(interpSignal(modeTs, t, 'previous'));
    aCmd     = interpSignal(aCmdTs,     t, 'previous');

    %% 3-4. Collision check

    collisionMask = dRel <= 0;
    collisionOccurred = any(collisionMask);

    if collisionOccurred
        firstCollisionIdx  = find(collisionMask, 1, 'first');
        firstCollisionTime = t(firstCollisionIdx);
        impactSpeed         = vEgo(firstCollisionIdx);
    else
        firstCollisionTime = NaN;
        impactSpeed         = 0;
    end

    %% 3-5. TTC metric

    validTTC = ttc(isfinite(ttc) & ttc >= 0 & ttc < 90);

    if isempty(validTTC)
        minimumTTC = NaN;
    else
        minimumTTC = min(validTTC);
    end

    %% 3-6. Entry times

    warningEntry = firstModeTime(t, mode, 2);
    partialEntry = firstModeTime(t, mode, 3);
    fullEntry    = firstModeTime(t, mode, 4);

    %% 3-7. Mode durations

    normalDuration  = modeDuration(t, mode, 1);
    warningDuration = modeDuration(t, mode, 2);
    partialDuration = modeDuration(t, mode, 3);
    fullDuration    = modeDuration(t, mode, 4);

    %% 3-8. Stopping information

    stopIdx = find(vEgo <= 0.05, 1, 'first');

    if isempty(stopIdx)
        stopTime = NaN;
        stoppingDistance = NaN;
        distanceAtStop = NaN;
    else
        stopTime = t(stopIdx);
        stoppingDistance = trapz(t(1:stopIdx), vEgo(1:stopIdx));
        distanceAtStop = dRel(stopIdx);
    end

    %% 3-9. Mode transition table

    changeIdx = [1; find(diff(mode) ~= 0) + 1];
    modeNames = strings(numel(changeIdx), 1);

    for i = 1:numel(changeIdx)
        modeNames(i) = modeName(mode(changeIdx(i)));
    end

    transitionTable = table( ...
        t(changeIdx), ...
        mode(changeIdx), ...
        modeNames, ...
        'VariableNames', {'Time_s', 'Mode', 'ModeName'});

    writetable( ...
        transitionTable, ...
        fullfile(resultDir, sprintf('%s_mode_transitions.csv', scenarioLabel)));

    %% 3-10. Metrics

    metrics = table( ...
        scenarioId, ...
        string(scenarioTitle), ...
        min(vTarget), ...
        max(vTarget), ...
        min(vEgo), ...
        max(vEgo), ...
        min(vClosing), ...
        max(vClosing), ...
        min(dRel), ...
        minimumTTC, ...
        min(aCmd), ...
        max(aCmd), ...
        warningEntry, ...
        partialEntry, ...
        fullEntry, ...
        normalDuration, ...
        warningDuration, ...
        partialDuration, ...
        fullDuration, ...
        stopTime, ...
        stoppingDistance, ...
        distanceAtStop, ...
        collisionOccurred, ...
        firstCollisionTime, ...
        impactSpeed, ...
        'VariableNames', { ...
            'Scenario', ...
            'ScenarioName', ...
            'MinimumTargetSpeed_mps', ...
            'MaximumTargetSpeed_mps', ...
            'MinimumEgoSpeed_mps', ...
            'MaximumEgoSpeed_mps', ...
            'MinimumClosingSpeed_mps', ...
            'MaximumClosingSpeed_mps', ...
            'MinimumRelativeDistance_m', ...
            'MinimumTTC_s', ...
            'MinimumAcceleration_mps2', ...
            'MaximumAcceleration_mps2', ...
            'WarningEntryTime_s', ...
            'PartialBrakeEntryTime_s', ...
            'FullBrakeEntryTime_s', ...
            'NormalDuration_s', ...
            'WarningDuration_s', ...
            'PartialBrakeDuration_s', ...
            'FullBrakeDuration_s', ...
            'StopTime_s', ...
            'StoppingDistance_m', ...
            'RelativeDistanceAtStop_m', ...
            'CollisionOccurred', ...
            'FirstCollisionTime_s', ...
            'ImpactSpeed_mps'});

    allMetrics{k} = metrics;

    writetable( ...
        metrics, ...
        fullfile(resultDir, sprintf('%s_metrics.csv', scenarioLabel)));

    %% 3-11. Raw result MAT

    save( ...
        fullfile(resultDir, sprintf('%s_results.mat', scenarioLabel)), ...
        't', 'vTarget', 'vEgo', 'dRel', 'vClosing', ...
        'ttc', 'mode', 'aCmd', 'metrics', 'transitionTable');

    %% 3-12. Portfolio figures

    exportSpeedFigure(t, vTarget, vEgo, scenarioTitle, ...
        fullfile(imageDir, sprintf('%s_speed.png', scenarioLabel)));

    exportDistanceFigure(t, dRel, scenarioTitle, ...
        fullfile(imageDir, sprintf('%s_distance.png', scenarioLabel)));

    exportTTCFigure(t, ttc, scenarioTitle, ...
        fullfile(imageDir, sprintf('%s_ttc.png', scenarioLabel)));

    exportBrakeFigure(t, aCmd, scenarioTitle, ...
        fullfile(imageDir, sprintf('%s_braking.png', scenarioLabel)));

    exportModeFigure(t, mode, scenarioTitle, ...
        fullfile(imageDir, sprintf('%s_mode.png', scenarioLabel)));

    %% 3-13. Console summary

    fprintf('%s', newline);
    fprintf('Modes observed: ');
    fprintf('%g ', unique(mode));
    fprintf('%s', newline);

    fprintf('Target speed range       : %.3f ~ %.3f m/s', min(vTarget), max(vTarget));
    fprintf('%s', newline);

    fprintf('Ego speed range          : %.3f ~ %.3f m/s', min(vEgo), max(vEgo));
    fprintf('%s', newline);

    fprintf('Acceleration range       : %.3f ~ %.3f m/s^2', min(aCmd), max(aCmd));
    fprintf('%s', newline);

    fprintf('Minimum relative distance: %.3f m', min(dRel));
    fprintf('%s', newline);

    if collisionOccurred
        fprintf('Collision                : YES'); fprintf('%s', newline);
        fprintf('First collision time     : %.3f s', firstCollisionTime); fprintf('%s', newline);
        fprintf('Impact speed             : %.3f m/s', impactSpeed); fprintf('%s', newline);
    else
        fprintf('Collision                : NO'); fprintf('%s', newline);
    end

    fprintf('%s', newline);
    disp('Mode transitions:');
    disp(transitionTable);

end

%% 4. Save all scenario metrics

summaryTable = vertcat(allMetrics{:});
summaryFile = fullfile(resultDir, 'all_scenarios_metrics.csv');
writetable(summaryTable, summaryFile);

%% 5. Final comparison figure

exportComparisonFigure(summaryTable, ...
    fullfile(imageDir, 'aeb_scenario_comparison.png'));

%% 6. Final output

fprintf('%s', newline);
disp('=============================================');
disp('         AEB FINAL EXPORT COMPLETED');
disp('=============================================');

disp(summaryTable(:, { ...
    'Scenario', ...
    'ScenarioName', ...
    'MinimumRelativeDistance_m', ...
    'MinimumAcceleration_mps2', ...
    'CollisionOccurred'}));

fprintf('%s', newline);
fprintf('Saved images : %s', imageDir); fprintf('%s', newline);
fprintf('Saved results: %s', resultDir); fprintf('%s', newline);
fprintf('Summary CSV  : %s', summaryFile); fprintf('%s', newline);

%% Local functions

function ts = getSignal(simOut, signalName)

    ts = [];

    try
        ts = simOut.get(signalName);
    catch
        ts = [];
    end

    if isempty(ts)
        existsInBase = evalin('base', sprintf('exist(''%s'', ''var'')', signalName));
        if existsInBase
            ts = evalin('base', signalName);
        end
    end

    if isempty(ts)
        error('Signal "%s" not found. Check the To Workspace block name.', signalName);
    end

    if ~isa(ts, 'timeseries')
        error('Signal "%s" must use Save format = Timeseries. Current type: %s', ...
            signalName, class(ts));
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
            name = "WARNING";
        case 3
            name = "PARTIAL_BRAKE";
        case 4
            name = "FULL_BRAKE";
        otherwise
            name = "INVALID";
    end
end

function exportSpeedFigure(t, vTarget, vEgo, titleText, fileName)

    fig = figure('Visible', 'off', 'Color', 'w', 'Position', [100 100 1000 550]);
    plot(t, vTarget * 3.6, 'LineWidth', 1.8);
    hold on;
    plot(t, vEgo * 3.6, 'LineWidth', 1.8);
    grid on;
    xlabel('Time (s)');
    ylabel('Speed (km/h)');
    title([titleText ' - Speed Response']);
    legend('Target Vehicle', 'Ego Vehicle', 'Location', 'best');
    exportgraphics(fig, fileName, 'Resolution', 200);
    close(fig);
end

function exportDistanceFigure(t, dRel, titleText, fileName)

    fig = figure('Visible', 'off', 'Color', 'w', 'Position', [100 100 1000 550]);
    plot(t, dRel, 'LineWidth', 1.8);
    hold on;
    yline(0, '--', 'Collision Boundary');
    grid on;
    xlabel('Time (s)');
    ylabel('Relative Distance (m)');
    title([titleText ' - Relative Distance']);
    exportgraphics(fig, fileName, 'Resolution', 200);
    close(fig);
end

function exportTTCFigure(t, ttc, titleText, fileName)

    fig = figure('Visible', 'off', 'Color', 'w', 'Position', [100 100 1000 550]);
    ttcPlot = min(ttc, 8);
    plot(t, ttcPlot, 'LineWidth', 1.8);
    hold on;
    yline(4, '--', 'WARNING');
    yline(3, '--', 'PARTIAL');
    yline(2, '--', 'FULL');
    grid on;
    ylim([0 8]);
    xlabel('Time (s)');
    ylabel('TTC (s)');
    title([titleText ' - Time To Collision']);
    exportgraphics(fig, fileName, 'Resolution', 200);
    close(fig);
end

function exportBrakeFigure(t, aCmd, titleText, fileName)

    fig = figure('Visible', 'off', 'Color', 'w', 'Position', [100 100 1000 550]);
    stairs(t, aCmd, 'LineWidth', 1.8);
    hold on;
    yline(0, '--');
    grid on;
    xlabel('Time (s)');
    ylabel('Acceleration Command (m/s^2)');
    title([titleText ' - AEB Braking Command']);
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
    ylabel('AEB Mode');
    title([titleText ' - Stateflow Mode']);
    exportgraphics(fig, fileName, 'Resolution', 200);
    close(fig);
end

function exportComparisonFigure(summaryTable, fileName)

    fig = figure('Visible', 'off', 'Color', 'w', 'Position', [100 100 1000 550]);
    bar(summaryTable.MinimumRelativeDistance_m);
    grid on;
    xticks(1:height(summaryTable));
    xticklabels({'Stationary Target', 'Slow Target', 'Hard Braking'});
    ylabel('Minimum Relative Distance (m)');
    title('AEB Scenario Comparison - Minimum Relative Distance');
    exportgraphics(fig, fileName, 'Resolution', 200);
    close(fig);
end
