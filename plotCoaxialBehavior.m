%% plotCoaxialBehavior FUNCTION %%
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