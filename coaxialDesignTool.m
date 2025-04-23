function result = coaxialDesignTool(geom, material, operating)
    % Constants
    mu0 = 4*pi*1e-7;
    eps0 = 8.854e-12;

    % Inputs
    a = geom.a;  % inner conductor radius (m)
    b = geom.b;  % outer conductor radius (m)
    er = material.er;
    tan_delta = material.tan_delta;
    sigma_c = material.sigma_c;
    sigma_d = material.sigma_d;

    f = operating.f;               % operating frequency (Hz)
    omega = 2 * pi * f;

    % Derived constants
    mu_r = 1;       % assume nonmagnetic materials
    mu = mu0 * mu_r;
    eps = eps0 * er;

    % Distributed parameters
    L = (mu / (2 * pi)) * log(b / a);          % H/m
    C = (2 * pi * eps) / log(b / a);           % F/m
    R = (1/2*pi)*((1/a)+(1/b))*sqrt((pi*f*mu)/sigma_c);      % Ohms/m
    G = (2*pi*sigma_d)/log(b/a);               % S/m

    % Propagation constant
    gamma = sqrt((R + 1j*omega*L) * (G + 1j*omega*C));
    alpha = real(gamma);                       % Np/m
    beta = imag(gamma);                        % rad/m
    alpha_dB_per_m = 8.686 * alpha;            % dB/m

    %propogation velocity 
    u_p = omega/beta;                          % m/s
    
    % Characteristic impedance (lossy)
    Z0_dist = sqrt((R + 1j*omega*L) / (G + 1j*omega*C)); %ohms

    % Lossless versions for comparison
    Z0_lossless = sqrt(L / C);
    beta_lossless = omega * sqrt(L * C);
    u_p_lossless = 1/sqrt(L*C);
    % Wavelength
    lambda = 2 * pi / beta;  % m

    % Store results in a struct
    result.R_per_m = R;
    result.L_per_m = L;
    result.C_per_m = C;
    result.G_per_m = G;
    result.Z0_dist = Z0_dist;
    result.Z0_lossless = Z0_lossless;
    result.gamma = gamma;
    result.alpha = alpha;
    result.alpha_dB_per_m = alpha_dB_per_m;
    result.beta = beta;
    result.beta_lossless = beta_lossless;
    result.u_p = u_p;
    result.u_p_lossless = u_p_lossless;
    result.lambda=lambda;
end


function plotCoaxialBehavior(geom, material, f_range)
    n = length(f_range);
    alpha_dB = zeros(1, n);
    Z0_real = zeros(1, n);
    Z0_imag = zeros(1, n);
    lambda = zeros(1, n);

    for i = 1:n
        operating.f = f_range(i);
        result = coaxialDesignTool(geom, material, operating);
        alpha_dB(i) = result.alpha_dB_per_m;
        Z0_real(i) = real(result.Z0_dist);
        Z0_imag(i) = imag(result.Z0_dist);
        lambda(i) = result.lambda;
    end

    % Plot Attenuation
    figure;
    semilogx(f_range, alpha_dB, 'LineWidth', 2);
    grid on;
    title('Attenuation vs Frequency');
    xlabel('Frequency (Hz)');
    ylabel('Attenuation (dB/m)');

    % Plot Characteristic Impedance
    figure;
    semilogx(f_range, Z0_real, 'b-', 'LineWidth', 2); hold on;
    semilogx(f_range, Z0_imag, 'r--', 'LineWidth', 2);
    grid on;
    title('Characteristic Impedance vs Frequency');
    xlabel('Frequency (Hz)');
    ylabel('Impedance (Ohms)');
    legend('Re(Z_0)', 'Im(Z_0)');

    % Plot Wavelength
    figure;
    semilogx(f_range, lambda, 'LineWidth', 2);
    grid on;
    title('Wavelength vs Frequency');
    xlabel('Frequency (Hz)');
    ylabel('Wavelength (m)');
end


function plotSmith(Gamma)
    theta = linspace(0, 2*pi, 500);
    figure; 
    hold on; 
    axis equal;
    plot(cos(theta), sin(theta), 'k'); % unit circle

    % Plot reflection coefficient
    plot(real(Gamma), imag(Gamma), 'ro', 'MarkerSize', 8, 'LineWidth', 2);
    xlim([-1.2 1.2]); ylim([-1.2 1.2]);
    title('Smith Chart Mapping');
    xlabel('Real(\Gamma)'); ylabel('Imag(\Gamma)');
    grid on;
end


function C_match = matchLoadWithShuntCap(ZL, Z0, f)
    Y_L = 1 / ZL;
    Y0 = 1 / Z0;
    B_match = imag(Y0 - Y_L);
    C_match = B_match / (2 * pi * f);
    fprintf('To match the load using a shunt capacitor:\n');
    fprintf('Add C = %.3e F (%.3f pF)\n', C_match, C_match*1e12);
end


geom.a = 0.001;
geom.b = 0.005;
material.er = 2.3;
material.tan_delta = 0.0002;
material.sigma_c = 5.8e7;
material.sigma_d = 0;
operating.f = 1e9;  % 1 GHz

result = coaxialDesignTool(geom, material, operating);

disp(result.Z0_dist)
disp(result.alpha)
disp(result.beta)
fprintf('Attenuation: %.4f dB/m\n', result.alpha_dB_per_m);


f_range = logspace(6, 10, 200); % 1 MHz to 10 GHz
plotCoaxialBehavior(geom, material, f_range);


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
