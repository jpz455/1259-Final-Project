%% MAIN %%

% Clear Previous Data
clc
clear
close all

% Prompt User and Error Check
fprintf("Welcome to our Coaxial Cable Design Tool!\nWould you like to:\n\t1. Design your own cable\n\t2. Verify the software")
choice = input("Please enter 1 or 2: ");
while choice ~= 1 && choice ~= 2
    choice = input("Please enter 1 or 2: ");
end

% Design Choice
if choice == 1

    % Cable Geometry
    geom.a = input("Inner conductor radius (mm): ");
    geom.b = input("Dielectric conductor radius (mm): ");
    geom.c = input("Outer conductor radius (mm): ");
    geom.length = input("Cable length (m): ");

    % Material Properties
        fprintf("\nConductor options:\n\t")

        fprintf("\nDielectric options:\n\t")

    material.sigma_ci = findMaterial(input("Inner conductor material (see above): ","s"));
    material.er = findMaterial(input("Dielectric material (see above): ","s"));
    material.sigma_d = 0;
    material.sigma_co = findMaterial(input("Outer conductor material (see above): ","s"));

    % Cable Operation
    operating.f = input("Cable operating frequency (Hz): ");
    operating.V = input("Cable operating voltage (V): ");

% Verification Choice
elseif choice == 2
catalog = readtable('Coaxial Cable Catalog.csv')
catalog(1,2).Variables

geom.a = 0.001;                 % inner conductor radius
geom.b = 0.005;                 % dielectric radius
geom.c =                        % outer conductor radius
geom.length = 5;                % cable length
material.er = 2.3;              % dieletric permittivity
%material.tan_delta = 0.0002;    % loss tangent
material.sigma_ci = 5.8e7;      % inner conductor conductivity
%materal.sigma_co =              % outer conductor conductivity
material.sigma_d = 0;           % dielectric conductivity
operating.f = 1e9;  % 1 GHz     % operating frequency
operating.V = 1.28;             % operating voltage

end
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
