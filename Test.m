2%% MAIN %%

% Clear Previous Data
clc
clear
close all

% Prompt User and Error Check
fprintf("Welcome to our Coaxial Cable Design Tool!\nWould you like to:\n\t1. Design your own cable\n\t2. Verify the software\n")
choice = input("Please enter 1 or 2: ");
while choice ~= 1 && choice ~= 2
    choice = input("Please enter 1 or 2: ");
end

% Design Choice
if choice == 1

    % Cable Geometry
    geom.a = input("\nEnter inner conductor radius (mm): ")*1e-3;
    geom.b = input("Enter dielectric conductor radius (mm): ")*1e-3;
    geom.c = input("Enter outer conductor radius (mm): ")*1e-3;
    geom.length = input("Enter cable length (m): ");

    % Material Properties
    fprintf("\n\tConductor options:")
    fprintf("\n\tCCS - Bare Copper Clad Steel\n\tTC - Tinned Copper\n\tBC - Bare Copper")
    fprintf("\n\tSC - Silver Covered Copper\n\tSilver Covered Copper Clad Steel\n\tAL - Aluminum\n");
    fprintf("\n\tDielectric options:")
    fprintf("\n\tPE - Polyethylene\n\tR - Rubber\n\tPTFE - Polytetrafluoroethylene\n\tFoam PE - Foam Polyethylene")
    fprintf("\n\tPFA - Perfluoroalkoxy Alkane\n\tETFE - Ethylene Tetrafluoroethylene\n\tECTFE - Ethylene Clorotrifluoroethylene")
    fprintf("\n\tPVDF - Polyvinylidene Fluoride\n\tFEP - Fluorinated Ethylene Propylene\n\n")

    material.sigma_ci = findMaterial(input("Enter inner conductor material name (see above) or conductivity value (S/m): ","s"));
    material.er = findMaterial(input("Enter dielectric material name (see above) or relative permittivity value: ","s"));
    material.sigma_d = 0;
    material.sigma_co = findMaterial(input("Enter outer conductor material name (see above) or conducitivity value (S/m): ","s"));

    % Cable Operation
    operating.f = input("\nEnter cable operating frequency (Hz): ");
    operating.V = input("Enter cable operating voltage (V): ");

    % Hard Code
    % geom.a = 0.001;                 % inner conductor radius (m)
    % geom.b = 0.005;                 % dielectric radius (m)
    % geom.c = 0.010;                 % outer conductor radius (m)
    % geom.length = 5;                % cable length (m)
    % material.er = 2.3;              % dieletric permittivity
    % material.sigma_ci = 5.8e7;      % inner conductor conductivity
    % material.sigma_co = 5.8e7;       % outer conductor conductivity
    % material.sigma_d = 0;           % dielectric conductivity
    % operating.f = 1e9;  % 1 GHz     % operating frequency
    % operating.V = 1.28;             % operating voltage

    %Display Provided Parameters
    fprintf("\nProvided Parameters:")
    fprintf("\n\ta (mm): %f", geom.a*1e3);
    fprintf("\n\tb (mm): %f", geom.b*1e3);
    fprintf("\n\tc (mm): %f", geom.c*1e3);
    fprintf("\n\tCable length (m): %f", geom.length)
    fprintf("\n\tInner conductor conductivity (S/m): %f", material.sigma_ci);
    fprintf("\n\tDielectric relative permeability: %f", material.er);
    fprintf("\n\tOuter conductor conductivity (S/m): %f", material.sigma_co);
    fprintf("\n\tOperating frequency (Hz): %f", operating.f);
    fprintf("\n\tOperating voltage (V): %f", operating.V);

    % Calculate Results
    result = coaxialDesignTool(geom, material, operating);

    % Display Results
    fprintf("\n\nCalculated Characteristics:")
    fprintf("\n\tAC resistance (ohms/m): %f", result.R_per_m);
    fprintf("\n\tInner DC resistance (ohms/m): %f", result.R_DCi_per_m);
    fprintf("\n\tOuter DC resistance (ohms/m): %f", result.R_DCo_per_m);
    fprintf("\n\tCapacitance (pF/m): %f", result.C_per_m*1e12);
    fprintf("\n\tInductance (nH/m): %f", result.L_per_m*1e9);
    fprintf("\n\tCharacteristic impedance (ohms): %f + %fi", real(result.Z0_dist), imag(result.Z0_dist));
    fprintf("\n\tLossless Characteristic impedance (ohms): %f", result.Z0_lossless);
    fprintf("\n\tPropogation constant: %f + %fi", real(result.gamma), imag(result.gamma));
    fprintf("\n\tAttenuation constant (Np/m): %f", result.alpha);
    fprintf("\n\tAttenuation constant (dB/m): %f", result.alpha_dB_per_m);
    fprintf("\n\tPhase constant (rad/m): %f", result.beta);
    fprintf("\n\tLossless phase constant (rad/m): %f", result.beta_lossless);
    fprintf("\n\tPropogation velocity (km/s): %f", result.u_p/1e3);
    fprintf("\n\tLossless propogation velocity (km/s): %f", result.u_p_lossless/1e3);
    fprintf("\n\tWavelength (m): %f", result.lambda);
    fprintf("\n\tInput power (W): %f", result.input_power);
    fprintf("\n\tSupplied power (W): %f", result.supplied_power);
    fprintf("\n\tPower loss: %f", result.power_loss);

    % Plot Visualizer
    coax_visualizer(geom, material, operating);

    % Plot Coaxial Behavior
    f_range = logspace(6, 10, 200); % 1 MHz to 10 GHz
    plotCoaxialBehavior(geom, material, operating, f_range)

    % Input Load Impedance for Smith Chart Plotting
    ZL = 75 + 25j;  
    Z0 = result.Z0_dist;
    % Normalize and Calculate Reflection Coefficient
    z = ZL / Z0;
    Gamma = (z - 1) / (z + 1);

    % Plot on Smith Chart
    plotSmith(Gamma);

    Z0 = result.Z0_dist;     
    ZL = 75 + 25j;           % load to match
    f = operating.f;
    C_match = matchLoadWithShuntCap(ZL, Z0, f);
    %maybe add in inductor matching



    % Plot Input Impedance Along Cable
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

% Verification Choice
elseif choice == 2

    % Read Coaxial Cable Catalog
    catalog = readtable('Coaxial Cable Catalog.csv');

    % Loop Through Each Cable
    for i = 1:size(catalog, 1)

        % Cable Geometry
        geom.a = (catalog(i,2).Variables*1e-3) / 2;
        geom.b = (catalog(i,3).Variables*1e-3) / 2;
        geom.c = (catalog(i,4).Variables*1e-3) / 2;
        geom.length = 1;
        material.sigma_ci = findMaterial(char(catalog(i,5).Variables));
        material.er = findMaterial(char(catalog(i,6).Variables));
        material.sigma_d = 0;
        material.sigma_co = findMaterial(char(catalog(i,7).Variables));

        % Cable Operation
        operating.f = catalog(i,13).Variables*1e9;
        operating.V = 1;

        % Compare Calculated Results with Catalog
        result = coaxialDesignTool(geom, material, operating);
        fprintf("\nCable: %s\n", char(catalog(i,1).Variables));
        temp1 = result.u_p/1000; temp2 = (catalog(i,9).Variables/100)*299792.458;
        fprintf("\tCalculated propogation velocity (km/s): %f\n\tDatasheet propogation velocity (km/s): %f\n\tPercent Error (%%): %f\n\n", temp1, temp2, 100*abs(temp1 - temp2) / temp2)
        temp1 = result.Z0_lossless; temp2 = catalog(i,10).Variables;
        fprintf("\tCalculated characteristic impedance (ohms): %f\n\tDatasheet characteristic impedance (ohms): %f\n\tPercent Error (%%): %f\n\n", temp1, temp2, 100*abs(temp1 - temp2) / temp2)
        temp1 = result.C_per_m*1e12; temp2 = catalog(i,11).Variables;
        fprintf("\tCalculated capacitance (pf/m): %f\n\tDatasheet capacitance (pf/m): %f\n\tPercent Error (%%): %f\n\n", temp1, temp2, abs(temp1 - temp2) / temp2)
        temp1 = result.R_DCi_per_m; temp2 = catalog(i,14).Variables/304.8;
        fprintf("\tCalculated inner DC resistance (ohms/m): %f\n\tDatasheet inner DC resistance (ohms/m): %f\n\tPercent Error (%%): %f\n\n", temp1, temp2, 100*abs(temp1 - temp2) / temp2)
        temp1 = result.R_DCo_per_m; temp2 = catalog(i,15).Variables/304.8;
        fprintf("\tCalculated outer DC resistance (ohms/m): %f\n\tDatasheet outer DC resistance (ohms/m): %f\n\tPercent Error (%%): %f\n\n", temp1, temp2, 100*abs(temp1 - temp2) / temp2)

    end
    
end

