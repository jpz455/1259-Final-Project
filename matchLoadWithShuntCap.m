%% matchLoadWithShuntCap FUNCTION %%
function C_match = matchLoadWithShuntCap(ZL, Z0, f)
    Y_L = 1 / ZL;
    Y0 = 1 / Z0;
    B_match = imag(Y0 - Y_L);
    C_match = B_match / (2 * pi * f);
    fprintf('To match the load using a shunt capacitor:\n');
    fprintf('Add C = %.3e F (%.3f pF)\n', C_match, C_match*1e12);
end