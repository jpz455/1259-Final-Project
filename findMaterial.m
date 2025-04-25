function property = findMaterial(name)
    switch name

        % Conductors
        case 'CCS'  % Bare Copper Clad Steel
            property = 2.38e7;
        case 'TC'   % Tinned Copper
            property = 5.96e7;
        case 'BC'   % Bare Copper
            property = 5.96e7;
        case 'SC'   % Silver Covered Copper
            property = 6.00e7;
        case 'SCCS'   % Silver Covered Copper Clad Steel
            property = 2.38e7;

        % Dielectrics
        case 'PE'   % 
            property = 2.26;
        case 'Rubber'
            property = 2.8;
        case 'PTFE'
            property = 2.07;

        % Otherwise
        otherwise
            fprint("Error finding material! Setting to property to 1.")
            property = 1;
    end
end