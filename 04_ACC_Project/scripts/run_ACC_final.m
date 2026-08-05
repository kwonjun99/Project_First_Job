%% Run and export final ACC results
% Place this file in:
%   04_ACC_Project/scripts/run_ACC_final.m
%
% Required model:
%   model/ACC_Project_ModeLogic.slx
%
% Required To Workspace variables:
%   v_set_log, v_lead_log, v_ego_log
%   d_rel_log, d_ref_log, a_cmd_log
%   mode_log, ttc_log
%
% Save format for every To Workspace block:
%   Timeseries

close all;
clc;

scriptDir  = fileparts(mfilename('fullpath'));
projectDir = fileparts(scriptDir);
modelDir   = fullfile(projectDir, 'model');
imageDir   = fullfile(projectDir, 'images');
resultDir  = fullfile(projectDir, 'results');

if ~exist(imageDir, 'dir'), mkdir(imageDir); end
if ~exist(resultDir, 'dir'), mkdir(resultDir); end

modelName = 'ACC_Project_ModeLogic';
modelFile = fullfile(modelDir, [modelName '.slx']);
initFile  = fullfile(modelDir, 'init_ACC.m');

assert(isfile(modelFile), 'Model not found: %s', modelFile);
assert(isfile(initFile),  'Initialization script not found: %s', initFile);

load_system(modelFile);

caseIds   = [1 2];
caseNames = ["normal", "emergency"];

for k = 1:numel(caseIds)
    caseId   = caseIds(k);
    caseName = caseNames(k);

    fprintf('\n========================================\n');
    fprintf('Running ACC case %d: %s\n', caseId, caseName);
    fprintf('========================================\n');

    assignin('base', 'scenario_case', caseId);
    evalin('base', sprintf('run(''%s'');', escapeSingleQuotes(initFile)));

    appliedCase = evalin('base', 'scenario_case');
    assert(appliedCase == caseId, ...
        ['init_ACC.m reset scenario_case. Remove "scenario_case = 1;" and ' ...
         'use "clearvars -except scenario_case" at the top.']);

    simOut = sim(modelName);

    vSetTs  = getSignal(simOut, 'v_set_log');
    vLeadTs = getSignal(simOut, 'v_lead_log');
    vEgoTs  = getSignal(simOut, 'v_ego_log');
    dRelTs  = getSignal(simOut, 'd_rel_log');
    dRefTs  = getSignal(simOut, 'd_ref_log');
    aCmdTs  = getSignal(simOut, 'a_cmd_log');
    modeTs  = getSignal(simOut, 'mode_log');
    ttcTs   = getSignal(simOut, 'ttc_log');

    t = vEgoTs.Time(:);

    vSet  = resampleTs(vSetTs,  t, 'previous');
    vLead = resampleTs(vLeadTs, t, 'linear');
    vEgo  = resampleTs(vEgoTs,  t, 'linear');
    dRel  = resampleTs(dRelTs,  t, 'linear');
    dRef  = resampleTs(dRefTs,  t, 'linear');
    aCmd  = resampleTs(aCmdTs,  t, 'linear');
    mode  = resampleTs(modeTs,  t, 'previous');
    ttc   = resampleTs(ttcTs,   t, 'previous');

    save(fullfile(resultDir, caseName + "_results.mat"), ...
        't', 'vSet', 'vLead', 'vEgo', 'dRel', 'dRef', ...
        'aCmd', 'mode', 'ttc');

    fig = figure('Visible', 'off');
    plot(t, vSet*3.6,  'LineWidth', 1.4); hold on;
    plot(t, vLead*3.6, 'LineWidth', 1.4);
    plot(t, vEgo*3.6,  'LineWidth', 1.4);
    grid on;
    xlabel('Time (s)');
    ylabel('Speed (km/h)');
    title("ACC Speed Response - " + upper(caseName));
    legend('Set speed', 'Lead vehicle', 'Ego vehicle', 'Location', 'best');
    exportgraphics(fig, fullfile(imageDir, caseName + "_speed_response.png"), 'Resolution', 200);
    close(fig);

    fig = figure('Visible', 'off');
    plot(t, dRel, 'LineWidth', 1.4); hold on;
    plot(t, dRef, '--', 'LineWidth', 1.4);
    yline(0, ':');
    grid on;
    xlabel('Time (s)');
    ylabel('Distance (m)');
    title("ACC Distance Response - " + upper(caseName));
    legend('Relative distance', 'Desired distance', 'Location', 'best');
    exportgraphics(fig, fullfile(imageDir, caseName + "_distance_response.png"), 'Resolution', 200);
    close(fig);

    fig = figure('Visible', 'off');
    plot(t, aCmd, 'LineWidth', 1.4);
    grid on;
    xlabel('Time (s)');
    ylabel('Acceleration command (m/s^2)');
    title("ACC Acceleration Command - " + upper(caseName));
    yline(0, '--');
    exportgraphics(fig, fullfile(imageDir, caseName + "_acceleration_response.png"), 'Resolution', 200);
    close(fig);

    fig = figure('Visible', 'off');
    stairs(t, mode, 'LineWidth', 1.5);
    grid on;
    ylim([0.5 3.5]);
    yticks([1 2 3]);
    yticklabels({'CRUISE', 'FOLLOWING', 'EMERGENCY'});
    xlabel('Time (s)');
    ylabel('ACC mode');
    title("ACC Operating Mode - " + upper(caseName));
    exportgraphics(fig, fullfile(imageDir, caseName + "_mode.png"), 'Resolution', 200);
    close(fig);

    fig = figure('Visible', 'off');
    ttcPlot = min(ttc, 10);
    plot(t, ttcPlot, 'LineWidth', 1.5);
    grid on;
    xlabel('Time (s)');
    ylabel('TTC (s)');
    title("Time to Collision - " + upper(caseName));
    if evalin('base', "exist('TTC_emergency','var')")
        threshold = evalin('base', 'TTC_emergency');
        yline(threshold, '--', 'Emergency threshold');
    end
    ylim([0 10]);
    exportgraphics(fig, fullfile(imageDir, caseName + "_ttc_response.png"), 'Resolution', 200);
    close(fig);

    finiteTTC = ttc(isfinite(ttc) & ttc < 90);
    if isempty(finiteTTC)
        minTTC = NaN;
    else
        minTTC = min(finiteTTC);
    end

    metrics = table( ...
        min(dRel), ...
        minTTC, ...
        sqrt(mean((dRel-dRef).^2)), ...
        max(abs(vSet-vEgo)), ...
        min(aCmd), ...
        max(aCmd), ...
        modeDuration(t, mode, 1), ...
        modeDuration(t, mode, 2), ...
        modeDuration(t, mode, 3), ...
        any(dRel <= 0), ...
        'VariableNames', { ...
            'MinimumRelativeDistance_m', ...
            'MinimumTTC_s', ...
            'RMSDistanceError_m', ...
            'MaximumSpeedError_mps', ...
            'MinimumAcceleration_mps2', ...
            'MaximumAcceleration_mps2', ...
            'CruiseDuration_s', ...
            'FollowingDuration_s', ...
            'EmergencyDuration_s', ...
            'CollisionOccurred'});

    writetable(metrics, fullfile(resultDir, caseName + "_metrics.csv"));

    fprintf('Modes observed: ');
    fprintf('%g ', unique(mode));
    fprintf('\n');
    disp(metrics);

    if caseId == 1
        warningIf(~any(mode == 2), 'Normal case did not enter FOLLOWING mode.');
    else
        warningIf(~any(mode == 3), 'Emergency case did not enter EMERGENCY mode.');
        warningIf(any(dRel <= 0), 'Collision occurred in emergency case. Review braking threshold or scenario.');
    end
end

save_system(modelName);

fprintf('\nFinal ACC result export completed.\n');
fprintf('Images:  %s\n', imageDir);
fprintf('Results: %s\n', resultDir);

function signal = getSignal(simOut, name)
    try
        signal = simOut.get(name);
    catch
        error(['Signal "%s" was not found in SimulationOutput. ' ...
            'Check the To Workspace block name and connection.'], name);
    end
    assert(isa(signal, 'timeseries'), ...
        'Signal "%s" must use Save format: Timeseries.', name);
end

function y = resampleTs(ts, tq, method)
    tx = ts.Time(:);
    x  = squeeze(ts.Data);
    x  = x(:);
    tq = tq(:);

    valid = isfinite(tx) & isfinite(x);
    tx = tx(valid);
    x  = x(valid);

    assert(~isempty(tx), 'A logged signal contains no finite data.');

    if numel(tx) == 1
        y = repmat(x(1), size(tq));
        return;
    end

    [tx, idx] = unique(tx, 'last');
    x = x(idx);

    if numel(tx) == 1
        y = repmat(x(1), size(tq));
    else
        y = interp1(tx, x, tq, method, 'extrap');
        y = y(:);
    end
end

function duration = modeDuration(t, mode, target)
    if numel(t) < 2
        duration = 0;
        return;
    end
    dt = diff(t);
    duration = sum(dt(mode(1:end-1) == target));
end

function warningIf(condition, message)
    if condition
        warning('%s', message);
    end
end

function escaped = escapeSingleQuotes(text)
    escaped = strrep(text, '''', '''''');
end
