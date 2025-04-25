clc
clear

geom.a = 0.001;
geom.b = 0.005;
geom.length = 5;
material.er = 2.3;
material.tan_delta = 0.0002;
material.sigma_c = 5.8e7;
material.sigma_d = 0;
operating.f = 1e9;  % 1 GHz
operating.V = 1.28;

result = coaxialDesignTool(geom, material, operating);

disp(result.Z0_dist)
disp(result.alpha)
disp(result.beta)
fprintf('Attenuation: %.4f dB/m\n', result.alpha_dB_per_m);


f_range = logspace(6, 10, 200); % 1 MHz to 10 GHz
plotCoaxialBehavior(geom, material, operating, f_range);


% input load impedance for smith chart plotting
ZL = 75 + 25j;  
Z0 = result.Z0_dist;
% Normalize and calculate reflection coefficient
z = ZL / Z0;
Gamma = (z - 1) / (z + 1);

% Plot on Smith Chart
plotSmith(Gamma);

Z0 = result.Z0_dist;     
ZL = 75 + 25j;           % load to match
f = operating.f;
C_match = matchLoadWithShuntCap(ZL, Z0, f);
%maybe add in inductor matching



% plot input Impedance along tline
l_vals = linspace(0, result.lambda, 200);
Zin = zeros(size(l_vals));

for k = 1:length(l_vals)
    l = l_vals(k);
    beta = result.beta;
    Zin(k) = Z0 * (ZL + 1j*Z0*tan(beta*l)) / (Z0 + 1j*ZL*tan(beta*l));
end

figure;
plot(l_vals, real(Zin), 'b', l_vals, imag(Zin), 'r--');
xlabel('Distance from load (m)'); ylabel('Z_{in} (Ohms)');
title('Input Impedance vs Distance Along Line');
legend('Re(Z_{in})','Im(Z_{in})'); grid on;
