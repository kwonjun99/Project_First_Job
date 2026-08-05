# Adaptive Cruise Control (ACC) Using MATLAB/Simulink

## 1. Project Overview

This project implements a baseline Adaptive Cruise Control (ACC) system using MATLAB/Simulink.

The controller has two objectives:

1. Track the driver-selected cruising speed when the lead vehicle is sufficiently far away.
2. Maintain a safe following distance when the ego vehicle approaches the lead vehicle.

The final acceleration command is selected conservatively from the speed-control and distance-control commands and is limited by predefined acceleration and braking bounds.

---

## 2. System Architecture

The model consists of the following subsystems:

- **Lead Vehicle**: Generates the lead-vehicle speed scenario and integrates speed to obtain longitudinal position.
- **Ego Vehicle**: Applies the acceleration command and integrates it to obtain ego speed and position.
- **ACC Controller**: Calculates the desired following distance and generates the longitudinal acceleration command.
- **Metrics**: Reserved for quantitative performance evaluation.

```text
Lead Vehicle Speed Scenario
          |
          v
   Lead Vehicle Model ---------> x_lead
          |                         |
          v                         v
       v_lead                 Relative Distance
                                  d_rel
                                    |
                                    v
v_set -----> ACC Controller -----> a_cmd -----> Ego Vehicle Model
                ^                                  |
                |                                  +----> v_ego
                +----------------------------------+----> x_ego
```

![ACC system architecture](images/system_architecture.png)

---

## 3. Control Strategy

### 3.1 Desired Following Distance

The desired distance is calculated using a constant-time-headway policy:

```text
d_ref = d0 + T_gap * v_ego
```

Where:

- `d0`: minimum standstill distance
- `T_gap`: desired time gap
- `v_ego`: ego-vehicle speed

### 3.2 Speed Controller

The speed controller tracks the selected cruising speed:

```text
e_speed = v_set - v_ego
```

A PI controller generates the speed-control acceleration command:

```text
a_speed = Kp_v * e_speed + Ki_v * integral(e_speed)
```

### 3.3 Distance Controller

The distance error and relative velocity are defined as:

```text
e_gap = d_rel - d_ref
v_rel = v_lead - v_ego
```

The distance-control command is:

```text
a_gap = Kp_d * e_gap + Kd_d * v_rel
```

### 3.4 Acceleration Command Selection

The controller chooses the more conservative command:

```text
a_cmd = min(a_speed, a_gap)
```

The command is then limited by:

```text
a_min <= a_cmd <= a_max
```

This allows the ego vehicle to follow the selected speed when the road ahead is clear and to decelerate when the lead vehicle becomes too close.

---

## 4. Default Parameters

| Parameter | Description | Default value |
|---|---|---:|
| `Ts` | Simulation step | 0.05 s |
| `Tsim` | Simulation time | 60 s |
| `v_ego0` | Initial ego speed | 20 m/s |
| `x_lead0` | Initial lead position | 60 m |
| `v_set` | Selected cruising speed | 25 m/s |
| `d0` | Minimum distance | 10 m |
| `T_gap` | Desired time gap | 1.5 s |
| `a_max` | Maximum acceleration | 2.0 m/s² |
| `a_min` | Maximum braking command | -4.0 m/s² |

Controller gains are defined in `model/init_ACC.m`.

---

## 5. Lead-Vehicle Scenario

| Time interval | Lead-vehicle behavior |
|---|---|
| 0–10 s | Maintains 22 m/s |
| 10–15 s | Decelerates from 22 m/s to 15 m/s |
| 15–30 s | Maintains 15 m/s |
| 30–35 s | Accelerates from 15 m/s to 25 m/s |
| 35–45 s | Maintains 25 m/s |
| 45–50 s | Decelerates from 25 m/s to 18 m/s |
| 50–60 s | Maintains 18 m/s |

---

## 6. Repository Structure

```text
04_ACC_Project/
├── model/
│   ├── ACC_Project.slx
│   └── init_ACC.m
├── scripts/
│   └── analyze_ACC_results.m
├── images/
│   ├── system_architecture.png
│   ├── speed_response.png
│   ├── distance_response.png
│   ├── acceleration_response.png
│   └── time_gap.png
├── results/
│   └── baseline_metrics.csv
└── README.md
```

---

## 7. How to Run

1. Open MATLAB and set the current folder to `04_ACC_Project`.
2. Run `model/init_ACC.m`.
3. Open `model/ACC_Project.slx`.
4. Run the simulation.
5. Run `scripts/analyze_ACC_results.m`.
6. Check the generated figures in `images/` and performance metrics in `results/`.

---

## 8. Simulation Results

### 8.1 Vehicle Speed Response

![Vehicle speed response](images/speed_response.png)

### 8.2 Relative and Desired Distance

![Distance response](images/distance_response.png)

### 8.3 Acceleration Command

![Acceleration response](images/acceleration_response.png)

### 8.4 Time Gap

![Time-gap response](images/time_gap.png)

---

## 9. Baseline Performance Metrics

The analysis script automatically generates `results/baseline_metrics.csv`.

| Metric | Result |
|---|---:|
| Minimum relative distance | TBD |
| Minimum time gap | TBD |
| RMS distance error | TBD |
| Maximum speed-tracking error | TBD |
| Maximum acceleration | TBD |
| Maximum deceleration | TBD |
| Final speed error | TBD |

---

## 10. Key Contributions

- Built a complete longitudinal ACC simulation model from scratch.
- Implemented selected-speed tracking using a PI controller.
- Implemented safe-distance control using distance error and relative speed.
- Applied a constant-time-headway distance policy.
- Limited acceleration and braking commands using saturation.
- Designed a variable lead-vehicle speed scenario.
- Automated result plotting and quantitative performance evaluation.

---

## 11. Current Limitations

- The ego vehicle is modeled as an ideal longitudinal point-mass system.
- Sensor delay, sensor noise, road grade, aerodynamic drag, and actuator lag are not yet included.
- The baseline controller uses minimum-command selection rather than an explicit mode state machine.
- Emergency braking logic has not yet been implemented.

---

## 12. Future Work

- Add `CRUISE`, `FOLLOWING`, and `EMERGENCY` mode logic using Stateflow.
- Add emergency braking based on distance and time-to-collision.
- Add acceleration-rate limits for improved ride comfort.
- Add actuator delay and sensor noise.
- Compare baseline and improved controller performance.
- Add CAN-style signal interfaces and fault-handling logic.
