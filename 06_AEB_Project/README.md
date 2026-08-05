# Autonomous Emergency Braking (AEB) Using MATLAB/Simulink

## 1. Project Overview

This project implements an **Autonomous Emergency Braking (AEB)** system using MATLAB/Simulink.

The final objective is to detect a collision risk with a target vehicle and automatically apply staged braking through the following modes:

1. `NORMAL`
2. `WARNING`
3. `PARTIAL_BRAKE`
4. `FULL_BRAKE`

The current development stage is the **open-loop vehicle-model validation phase**. No AEB controller is active yet. The ego vehicle approaches a stationary target at constant speed so that the vehicle dynamics, relative distance, closing speed, and collision time can be verified before adding TTC-based braking logic.

---

## 2. Current Development Status

### Completed

- Created the AEB Simulink project structure
- Implemented the target-vehicle model
- Implemented the ego-vehicle longitudinal model
- Calculated target and ego positions
- Calculated relative distance
- Calculated closing speed
- Added signal logging
- Verified the open-loop collision scenario

### Next Steps

- Add Time To Collision calculation
- Add collision-risk thresholds
- Implement Stateflow operating modes
- Add partial and full emergency braking
- Add multiple AEB scenarios
- Automate graph and CSV result export

---

## 3. Project Structure

```text
06_AEB_Project/
├── model/
│   ├── AEB_Project.slx
│   └── init_AEB.m
├── scripts/
├── images/
├── results/
├── docs/
└── README.md
```

---

## 4. System Architecture

```text
Target Speed Command
        |
        v
+---------------------+
|   Target Vehicle    |
|                     |
| v_target_cmd        |
|       |             |
|       +--> v_target |
|       |             |
|       +--> ∫ --> x_target
+---------------------+
        |        |
        |        +----------------------+
        |                               |
        |                               v
        |                         Relative Distance
        |                         d_rel = x_target
        |                               - x_ego
        |
        +----------------------+
                               |
                               v
                         Closing Speed
                         v_closing = v_ego
                                     - v_target

Test Acceleration Command
        |
        v
+---------------------+
|     Ego Vehicle     |
|                     |
| a_cmd               |
|   |                 |
| Saturation          |
|   |                 |
|   +--> ∫ --> v_ego  |
|             |       |
|             +--> ∫ --> x_ego
+---------------------+
```

---

## 5. Vehicle Models

### 5.1 Target Vehicle

The target vehicle receives a speed command and integrates the speed to calculate longitudinal position.

```text
v_target_cmd --> v_target
       |
       +--> Integrator --> x_target
```

The target-vehicle equation is:

```text
dx_target / dt = v_target
```

Initial condition:

```matlab
x_target(0) = x_target0
```

In the first scenario, the target vehicle is stationary.

```matlab
v_target0 = 0;
```

### 5.2 Ego Vehicle

The ego vehicle receives a longitudinal acceleration command.

```text
a_cmd --> Saturation --> Integrator --> v_ego --> Integrator --> x_ego
```

The ego-vehicle equations are:

```text
dv_ego / dt = a_cmd
dx_ego / dt = v_ego
```

Initial conditions:

```matlab
v_ego(0) = v_ego0
x_ego(0) = x_ego0
```

The speed Integrator has a lower output limit of `0 m/s` to prevent negative vehicle speed.

---

## 6. Relative Distance

Relative distance is defined as:

```text
d_rel = x_target - x_ego
```

Interpretation:

- `d_rel > 0`: the target is ahead of the ego vehicle
- `d_rel = 0`: ego and target positions are equal
- `d_rel < 0`: the ego vehicle has passed through the target position

In this simplified point-mass model, `d_rel <= 0` is treated as a collision.

---

## 7. Closing Speed

Closing speed is defined as:

```text
v_closing = v_ego - v_target
```

Interpretation:

- `v_closing > 0`: ego is approaching the target
- `v_closing = 0`: relative distance is constant
- `v_closing < 0`: target is moving away from ego

For the current scenario:

```text
v_closing = 20 - 0 = 20 m/s
```

---

## 8. Initial Parameters

```matlab
Ts   = 0.05;    % Simulation step [s]
Tsim = 8;       % Simulation time [s]

v_ego0 = 20;    % Ego initial speed [m/s]
x_ego0 = 0;     % Ego initial position [m]

v_target0 = 0;      % Target speed [m/s]
x_target0 = 100;    % Target initial position [m]

a_cmd_test = 0;     % Open-loop acceleration command [m/s^2]

a_max  = 2.0;       % Maximum acceleration [m/s^2]
a_full = -6.0;      % Full emergency braking [m/s^2]

TTC_warning = 4.0;  % Warning threshold [s]
TTC_partial = 3.0;  % Partial-brake threshold [s]
TTC_full    = 2.0;  % Full-brake threshold [s]

d_full = 15;        % Emergency distance threshold [m]
```

The TTC parameters are defined in advance but are not yet connected to the controller.

---

## 9. Open-Loop Baseline Scenario

| Parameter | Value |
|---|---:|
| Ego initial speed | 20 m/s |
| Target speed | 0 m/s |
| Initial distance | 100 m |
| Ego acceleration command | 0 m/s² |
| Simulation time | 8 s |

Expected collision time:

```text
collision time = initial distance / closing speed
               = 100 / 20
               = 5 s
```

---

## 10. Baseline Simulation Results

```text
Target speed range: 0.000 ~ 0.000 m/s
Ego speed range: 20.000 ~ 20.000 m/s
Closing speed range: 20.000 ~ 20.000 m/s
Relative distance range: -60.000 ~ 100.000 m
Open-loop collision: YES
Collision time: 5.000 s
```

### Result Interpretation

The simulation result matches the theoretical prediction.

- The stationary target remains at `0 m/s`.
- The ego vehicle maintains `20 m/s`.
- Closing speed remains constant at `20 m/s`.
- Relative distance decreases linearly from `100 m`.
- Relative distance reaches `0 m` at `5 s`.
- The model correctly identifies the open-loop collision.

This collision is not a model failure. It is the required **baseline result before AEB intervention**.

---

## 11. Validation Summary

| Validation Item | Expected | Result | Status |
|---|---:|---:|---|
| Target speed | 0 m/s | 0 m/s | PASS |
| Ego speed | 20 m/s | 20 m/s | PASS |
| Closing speed | 20 m/s | 20 m/s | PASS |
| Initial relative distance | 100 m | 100 m | PASS |
| Collision time | 5 s | 5 s | PASS |
| Open-loop collision | YES | YES | PASS |

All baseline vehicle-model checks passed.

---

## 12. Logged Signals

All Simulink `To Workspace` blocks use:

```text
Save format: Timeseries
```

| Signal | Workspace Variable |
|---|---|
| Target speed | `v_target_log` |
| Target position | `x_target_log` |
| Ego speed | `v_ego_log` |
| Ego position | `x_ego_log` |
| Relative distance | `d_rel_log` |
| Closing speed | `v_closing_log` |
| Acceleration command | `a_cmd_log` |

---

## 13. Solver Configuration

```text
Solver type: Fixed-step
Solver: ode4 (Runge-Kutta)
Fixed-step size: Ts
Stop time: Tsim
```

Current simulation step:

```matlab
Ts = 0.05;
```

---

## 14. How to Run

Set the MATLAB current folder:

```matlab
cd("/Users/jun_mac/Documents/Project_First_Job/06_AEB_Project")
```

Run initialization:

```matlab
run("model/init_AEB.m");
```

Run the model:

```matlab
out = sim("AEB_Project");
```

Load logged signals:

```matlab
vTarget = out.get("v_target_log");
vEgo    = out.get("v_ego_log");
xTarget = out.get("x_target_log");
xEgo    = out.get("x_ego_log");
dRel    = out.get("d_rel_log");
vClose  = out.get("v_closing_log");
aCmd    = out.get("a_cmd_log");
```

Check baseline results:

```matlab
fprintf("\n===== AEB BASE VEHICLE MODEL =====\n");

fprintf("Target speed range: %.3f ~ %.3f m/s\n", ...
    min(vTarget.Data(:)), max(vTarget.Data(:)));

fprintf("Ego speed range: %.3f ~ %.3f m/s\n", ...
    min(vEgo.Data(:)), max(vEgo.Data(:)));

fprintf("Closing speed range: %.3f ~ %.3f m/s\n", ...
    min(vClose.Data(:)), max(vClose.Data(:)));

fprintf("Relative distance range: %.3f ~ %.3f m\n", ...
    min(dRel.Data(:)), max(dRel.Data(:)));

collisionIndex = find(dRel.Data(:) <= 0, 1, "first");

if isempty(collisionIndex)
    disp("Open-loop collision: NO");
else
    fprintf("Open-loop collision: YES\n");
    fprintf("Collision time: %.3f s\n", ...
        dRel.Time(collisionIndex));
end
```

---

## 15. Next Development Stage

The next phase adds TTC calculation.

```text
TTC = d_rel / v_closing
```

Initial AEB mode thresholds:

| TTC Range | AEB Mode |
|---|---|
| `TTC > 4.0 s` | `NORMAL` |
| `3.0 s < TTC <= 4.0 s` | `WARNING` |
| `2.0 s < TTC <= 3.0 s` | `PARTIAL_BRAKE` |
| `TTC <= 2.0 s` | `FULL_BRAKE` |

Initial braking commands:

```text
NORMAL        ->  0.0 m/s²
WARNING       ->  0.0 m/s²
PARTIAL_BRAKE -> -3.0 m/s²
FULL_BRAKE    -> -6.0 m/s²
```

The open-loop collision at `5.000 s` will be used as the reference result for evaluating the final AEB controller.
