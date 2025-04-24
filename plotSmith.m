%% plotSmith FUNCTION %%
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
