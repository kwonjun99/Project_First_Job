%% Analyze ACC Baseline Results
% Required To Workspace variables:
% v_set_log, v_lead_log, v_ego_log, d_rel_log, d_ref_log, a_cmd_log
% Save format: Timeseries

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

%% Load signals from base workspace or SimulationOutput object "out"
vSetTs  = getLoggedSignal('v_set_log');
vLeadTs = getLoggedSignal('v_lead_log');
vEgoTs  = getLoggedSignal('v_ego_log');
dRelTs  = getLoggedSignal('d_rel_log');
dRefTs  = getLoggedSignal('d_ref_log');
aCmdTs  = getLoggedSignal('a_cmd_log');

assert(isa(vSetTs, 'timeseries'),  'v_set_log must be a timeseries.');
assert(isa(vLeadTs, 'timeseries'), 'v_lead_log must be a timeseries.');
assert(isa(vEgoTs, 'timeseries'),  'v_ego_log must be a timeseries.');
assert(isa(dRelTs, 'timeseries'),  'd_rel_log must be a timeseries.');
assert(isa(dRefTs, 'timeseries'),  'd_ref_log must be a timeseries.');
assert(isa(aCmdTs, 'timeseries'),  'a_cmd_log must be a timeseries.');

%% Use ego-speed time vector as the common time base
t = vEgoTs.Time(:);
vEgo = squeeze(vEgoTs.Data);
vEgo = vEgo(:);

% Constant signals may contain only one logged sample, and some logged
% signals may contain repeated time stamps. Use a robust resampling helper.
vSet  = resampleTimeseries(vSetTs,  t, 'previous');
vLead = resampleTimeseries(vLeadTs, t, 'linear');
dRel  = resampleTimeseries(dRelTs,  t, 'linear');
dRef  = resampleTimeseries(dRefTs,  t, 'linear');
aCmd  = resampleTimeseries(aCmdTs,  t, 'linear');

vSet  = vSet(:);
vLead = vLead(:);
dRel  = dRel(:);
dRef  = dRef(:);
aCmd  = aCmd(:);

%% Derived signals
gapError = dRel - dRef;
speedError = vSet - vEgo;
timeGap = dRel ./ max(vEgo, 0.1);

%% Plot 1: Speed response
fig = figure('Name', 'ACC Speed Response');
plot(t, vSet * 3.6, 'LineWidth', 1.4);
hold on;
plot(t, vLead * 3.6, 'LineWidth', 1.4);
plot(t, vEgo * 3.6, 'LineWidth', 1.4);
grid on;
xlabel('Time (s)');
ylabel('Speed (km/h)');
title('ACC Vehicle Speed Response');
legend('Set speed', 'Lead vehicle', 'Ego vehicle', 'Location', 'best');
exportgraphics(fig, fullfile(imageDir, 'speed_response.png'), ...
    'Resolution', 200);

%% Plot 2: Distance response
fig = figure('Name', 'ACC Distance Response');
plot(t, dRel, 'LineWidth', 1.4);
hold on;
plot(t, dRef, '--', 'LineWidth', 1.4);
grid on;
xlabel('Time (s)');
ylabel('Distance (m)');
title('Relative Distance and Desired Distance');
legend('Relative distance', 'Desired distance', 'Location', 'best');
exportgraphics(fig, fullfile(imageDir, 'distance_response.png'), ...
    'Resolution', 200);

%% Plot 3: Acceleration command
fig = figure('Name', 'ACC Acceleration Command');
plot(t, aCmd, 'LineWidth', 1.4);
grid on;
xlabel('Time (s)');
ylabel('Acceleration command (m/s^2)');
title('ACC Acceleration Command');
yline(0, '--');
exportgraphics(fig, fullfile(imageDir, 'acceleration_response.png'), ...
    'Resolution', 200);

%% Plot 4: Time gap
fig = figure('Name', 'ACC Time Gap');
plot(t, timeGap, 'LineWidth', 1.4);
grid on;
xlabel('Time (s)');
ylabel('Time gap (s)');
title('ACC Time-Gap Response');
exportgraphics(fig, fullfile(imageDir, 'time_gap.png'), ...
    'Resolution', 200);

%% Quantitative metrics
metrics = table( ...
    min(dRel), ...
    min(timeGap), ...
    sqrt(mean(gapError.^2)), ...
    max(abs(speedError)), ...
    max(aCmd), ...
    min(aCmd), ...
    abs(speedError(end)), ...
    'VariableNames', { ...
        'MinimumRelativeDistance_m', ...
        'MinimumTimeGap_s', ...
        'RMSDistanceError_m', ...
        'MaximumSpeedError_mps', ...
        'MaximumAcceleration_mps2', ...
        'MaximumDeceleration_mps2', ...
        'FinalSpeedError_mps'});

writetable(metrics, fullfile(resultDir, 'baseline_metrics.csv'));

disp(' ');
disp('===== ACC Baseline Metrics =====');
disp(metrics);
disp("Figures saved to: " + imageDir);
disp("Metrics saved to: " + resultDir);

%% Local functions
function yQuery = resampleTimeseries(ts, queryTime, method)
    sampleTime = ts.Time(:);
    sampleData = squeeze(ts.Data);
    sampleData = sampleData(:);
    queryTime = queryTime(:);

    if numel(sampleTime) ~= numel(sampleData)
        error('Time and data lengths do not match for signal "%s".', ts.Name);
    end

    valid = isfinite(sampleTime) & isfinite(sampleData);
    sampleTime = sampleTime(valid);
    sampleData = sampleData(valid);

    if isempty(sampleTime)
        error('Signal "%s" contains no finite samples.', ts.Name);
    end

    % A Constant block can be logged as a single sample.
    if numel(sampleTime) == 1
        yQuery = repmat(sampleData(1), size(queryTime));
        return;
    end

    % interp1 requires distinct sample points. Retain the last value
    % when multiple values share the same simulation time.
    [sampleTime, uniqueIndex] = unique(sampleTime, 'last');
    sampleData = sampleData(uniqueIndex);

    if numel(sampleTime) == 1
        yQuery = repmat(sampleData(1), size(queryTime));
        return;
    end

    yQuery = interp1(sampleTime, sampleData, queryTime, method, 'extrap');
    yQuery = yQuery(:);
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
