%% coaxialDesignTool FUNCTION %%
function result = coaxialDesignTool(geom, material, operating)
    % Constants
    mu0 = 4*pi*1e-7;
    eps0 = 8.854e-12;

    % Inputs
    a = geom.a;  % inner conductor radius (m)
    b = geom.b;  % outer conductor radius (m)
    length = geom.length; % length of coax (m)
    er = material.er;
    %tan_delta = material.tan_delta;
    sigma_ci = material.sigma_ci;
    sigma_co = material.sigma_co;
    sigma_d = material.sigma_d;

    f = operating.f;               % operating frequency (Hz)
    V = operating.V;               % operating voltage (Volts)
    omega = 2 * pi * f;

    % Derived constants
    mu_r = 1;       % assume nonmagnetic materials
    mu = mu0 * mu_r;
    eps = eps0 * er;

    % Distributed parameters
    L = (mu / (2 * pi)) * log(b / a);          % H/m
    C = (2 * pi * eps) / log(b / a);           % F/m
    %R = (1/2*pi)*((1/a)+(1/b))*sqrt((pi*f*mu)/sigma_c);      % Ohms/m
    R = ( (1 / (a * sqrt(sigma_ci))) + (1 / (b * sqrt(sigma_co)))) * (1 / (2*pi*sqrt(2 / (omega*mu0))));  % Ohms/m
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
    result.input_power = V^2/2/abs(result.Z0_dist);
    result.supplied_power = V^2*exp(-2*result.alpha*length)/2/abs(result.Z0_dist);
    result.power_loss = result.supplied_power/result.input_power;
end
