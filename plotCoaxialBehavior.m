%% plotCoaxialBehavior FUNCTION %%
function plotCoaxialBehavior(geom, material, operating, f_range)
    result_from_input = coaxialDesignTool(geom,material,operating);
    input_geom = geom;
    input_material = material;
    input_operating = operating;

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
    
    attenuated_power = zeros(1,1000);
    lengths = linspace(0, geom.length, 1000);
    example_waveform = operating.V*sin(2*pi.*lengths*input_operating.f).*exp(-2*result_from_input.alpha.*lengths);

    for i = 1:1000
        input_geom.length = lengths(i);
        result = coaxialDesignTool(input_geom, input_material, input_operating);
        attenuated_power(i) = result.power_loss;
    end

    % Plot attenuated Power
    figure; 
    subplot(2,1,1)
    grid on;
    plot(lengths, attenuated_power, "Color", 'k');
    xlabel("Position along cable, meters")
    ylabel("P_{out}/P_{in}")
    ylim([-.05,1.05])
    subplot(2,1,2)
    grid on;
    hold on;
    plot(lengths, operating.V*attenuated_power, "Color", 'k');
    plot(lengths, -operating.V*attenuated_power, "Color", 'k');
    plot(lengths, example_waveform,"Color",'b');
    xlabel("Position along cable, meters")
    ylabel("Voltage, Volts")

    sgtitle('Power Attenuation Along Cable Length') 
end