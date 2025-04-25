%% matchLoadWithShuntCap FUNCTION %%
function C_match = matchLoadWithShuntCap(ZL, Z0, f)
    Y_L = 1 / ZL;
    Y0 = 1 / Z0;
    B_match = imag(Y0 - Y_L);
    C_match = B_match / (2 * pi * f);
    fprintf("\n\nGiven an impedance load of:\n\t%f + %fi ohms", real(ZL), imag(ZL));
    fprintf("\nThe impedance can be matched with a shunt capacitor of value:\n\t%f uF\n", C_match*1e6);
end