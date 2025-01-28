% MATLAB Script to generate Bode plot

% Given parameters
I_cp = 400e-6;               % Charge pump current (A)
Kvco = 12.57e9;              % VCO gain (rad/(V*s))
C1 = 1000e-12;               % Capacitance C1 (F)
C2 = 100e-12;                % Capacitance C2 (F)
R1 = 1e3;                    % Resistance R1 (Ohms)
N = 40;                      % Divider value
f_ripple = 156.25e6;         % Ripple frequency

% Calculate Z(s) components
s = tf('s');                 % Define Laplace variable

Z_s = (1/(s*(C1+C2))) * ((1 + s*R1*C1) / (1 + s*R1*C1*C2/(C1+C2)));

% Open-loop transfer function H_ol(s)
H_ol = (I_cp / (2*pi)) * Z_s * (Kvco / s) * (1/N);

% Closed-loop transfer function H_cl(s)
H_cl = ((I_cp / (2*pi)) * Z_s * (Kvco / s)) / (1 + (I_cp / (2*pi)) * Z_s * (Kvco / s) * (1/N));

% Generate Bode plot for open-loop
figure;
bode(H_ol,{1, 1e9});
grid on;
title('Bode Plot of Open Loop Transfer Function H_{ol}(s)');

% Calculate and display phase margin and gain margin for open-loop
[gm_ol, pm_ol, wg_ol, wp_ol] = margin(H_ol);
fprintf('Open-loop Gain Margin: %.2f dB\n', 20*log10(gm_ol));
fprintf('Open-loop Phase Margin: %.2f degrees\n', pm_ol);
fprintf('Open-loop Gain Crossover Frequency: %.2f Hz\n', wg_ol / (2*pi));
fprintf('Open-loop Phase Crossover Frequency: %.2f Hz\n', wp_ol / (2*pi));

% Generate Bode plot for closed-loop
figure;
bode(H_cl,{1, 1e9});
grid on;
title('Bode Plot of Closed Loop Transfer Function H_{cl}(s)');

% Calculate and display closed-loop bandwidth
[mag, ~, w] = bode(H_cl, {1, 1e9});
mag = squeeze(mag);
mag_at_0 = mag(1); % Magnitude at f = 0 Hz
half_mag_idx = find(mag <= (mag_at_0 / sqrt(2)), 1); % -3 dB point relative to f = 0 Hz
if ~isempty(half_mag_idx)
    bw = w(half_mag_idx) / (2*pi); % Convert rad/s to Hz
    fprintf('Closed-loop Bandwidth: %.2f MHz\n', bw/(1e6));
else
    fprintf('Closed-loop Bandwidth could not be determined.\n');
end

% Calculate magnitude of closed-loop response at f_ripple
omega_ripple = 2 * pi * f_ripple; % Convert f_ripple to angular frequency
[mag_ripple, ~] = bode(H_cl, omega_ripple);
mag_ripple_db = 20 * log10(squeeze(mag_ripple)); % Convert magnitude to dB
fprintf('Magnitude of Closed-loop Response at %.2f MHz: %.2f dB\n', f_ripple / 1e6, mag_ripple_db);