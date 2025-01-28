% MATLAB Script to generate Bode plot for closed-loop phase noise

% Given parameters
I_cp = 400e-6;               % Charge pump current (A)
Kvco = 12.57e9;              % VCO gain (rad/(V*s))
C1 = 1000e-12;               % Capacitance C1 (F)
C2 = 100e-12;                % Capacitance C2 (F)
R1 = 1e3;                    % Resistance R1 (Ohms)
N = 40;                      % Divider value
f_ripple = 156.25e6;         % Ripple frequency

% Define Laplace variable
s = tf('s');

% Calculate Z(s)
Z_s = (1/(s*(C1 + C2))) * ((1 + s*R1*C1) / (1 + s*R1*C1*C2/(C1 + C2)));

% Transfer function for phase noise closed loop
theta_n_cl_over_theta_n = (N * s) / (N * s + Kvco * Z_s * I_cp / (2 * pi));

% Bode plot
figure;
bode(theta_n_cl_over_theta_n);
grid on;
title('Bode Plot of Phase Noise Closed Loop Transfer Function');
