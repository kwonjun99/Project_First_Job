%% Analyze ACC Mode Logic and TTC
% Required To Workspace variables:
% mode_log, ttc_log
% Save format: Timeseries
%
% This script accepts signals either directly in the base workspace
% or inside a Simulink.SimulationOutput object named "out".

close all;
clc;

scriptDir = fileparts(mfilename('fullpath'));
projectDir = fileparts(scriptDir);
imageDir = fullfile(projectDir, 'images');
resultDir = fullfile(projectDir, 'results');

if ~exist(imageDir, 'dir')
    mkdir(imageDir);
end

if ~exist(resultDir, 'dir')
    mkdir(resultDir);
end

modeTs = getLoggedSignal('mode_log');
ttcTs  = getLoggedSignal('ttc_log');

assert(isa(modeTs, 'timeseries'), 'mode_log must be a timeseries.');
assert(isa(ttcTs, 'timeseries'),  'ttc_log must be a timeseries.');

tMode = modeTs.Time(:);
modeData = squeeze(modeTs.Data);
modeData = modeData(:);

tTTC = ttcTs.Time(:);
ttcData = squeeze(ttcTs.Data);
ttcData = ttcData(:);

% Replace very large "no collision risk" values for easier plotting.
ttcPlot = min(ttcData, 10);

%% Mode plot
fig = figure('Name', 'ACC Operating Mode');
stairs(tMode, modeData, 'LineWidth', 1.5);
grid on;
ylim([0.5 3.5]);
yticks([1 2 3]);
yticklabels({'CRUISE', 'FOLLOWING', 'EMERGENCY'});
xlabel('Time (s)');
ylabel('ACC mode');
title('ACC Operating Mode');
exportgraphics(fig, fullfile(imageDir, 'acc_mode.png'), ...
    'Resolution', 200);

%% TTC plot
fig = figure('Name', 'Time to Collision');
plot(tTTC, ttcPlot, 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('TTC (s)');
title('Time to Collision');
if evalin('base', "exist('TTC_emergency','var')")
    threshold = evalin('base', 'TTC_emergency');
    yline(threshold, '--', 'Emergency threshold');
end
ylim([0 10]);
exportgraphics(fig, fullfile(imageDir, 'ttc_response.png'), ...
    'Resolution', 200);

%% Mode duration metrics
simulationDuration = max(tMode) - min(tMode);
cruiseDuration = calculateModeDuration(tMode, modeData, 1);
followingDuration = calculateModeDuration(tMode, modeData, 2);
emergencyDuration = calculateModeDuration(tMode, modeData, 3);

finiteTTC = ttcData(isfinite(ttcData) & ttcData < 90);
if isempty(finiteTTC)
    minimumTTC = NaN;
else
    minimumTTC = min(finiteTTC);
end

metrics = table( ...
    simulationDuration, ...
    cruiseDuration, ...
    followingDuration, ...
    emergencyDuration, ...
    minimumTTC, ...
    'VariableNames', { ...
        'SimulationDuration_s', ...
        'CruiseDuration_s', ...
        'FollowingDuration_s', ...
        'EmergencyDuration_s', ...
        'MinimumTTC_s'});

writetable(metrics, fullfile(resultDir, 'mode_metrics.csv'));

disp(' ');
disp('===== ACC Mode Metrics =====');
disp(metrics);
disp("Figures saved to: " + imageDir);
disp("Metrics saved to: " + resultDir);

%% Local functions
function duration = calculateModeDuration(time, modeData, targetMode)
    if numel(time) < 2
        duration = 0;
        return;
    end

    dt = diff(time);
    active = modeData(1:end-1) == targetMode;
    duration = sum(dt(active));
end

function signal = getLoggedSignal(variableName)
    if evalin('base', sprintf("exist('%s','var')", variableName))
        signal = evalin('base', variableName);
        return;
    end

    if evalin('base', "exist('out','var')")
        simOut = evalin('base', 'out');
        try
            signal = simOut.get(variableName);
            return;
        catch
            % Continue to error below.
        end
    end

    error(['Signal "%s" was not found. Add a To Workspace block, ' ...
        'set Variable name to "%s", and set Save format to Timeseries.'], ...
        variableName, variableName);
end
