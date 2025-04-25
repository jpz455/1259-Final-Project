function property = findMaterial(name)
    
    % User Entered a String
    if isnan(str2double(name))

        switch name
            % Conductors
            case {'CCS', 'Bare Copper Clad Steel'}
                property = 2.38e7;
            case {'TC', 'Tinned Copper'}
                property = 5.96e7;
            case {'BC', 'Bare Copper'}
                property = 5.96e7;
            case {'SC', 'Silver Covered Copper'}
                property = 6.00e7;
            case {'SCCS', 'Silver Covered Copper Clad Steel'}
                property = 2.38e7;
            case {'AL', 'Aluminum'}
                property = 3.538e7

            % Dielectrics
            case {'PE', 'Polyethylene'}
                property = 2.26;
            case {'R', 'Rubber'}
                property = 2.8;
            case {'PTFE', 'Polytetrafluoroethylene'}
                property = 2.07;
            case {'Foam PE', 'Foam Polyethylene'}
                property = 1.465;
            case {'PFA', 'Perfluoroalkoxy Alkane'}
                property = 2.1;
            case {'ETFE', 'Ethylene Tetrafluoroethylene'}
                property = 2.6;
            case {'ECTFE', 'Ethylene Clorotrifluoroethylene'}
                property = 2.5;
            case {'PVDF', 'Polyvinylidene Fluoride'}
                property = 7.8;
            case {'FEP', 'Fluorinated Ethylene Propylene'}
                property = 2.1;

            % Otherwise
            otherwise
                fprintf("Error finding material! Setting to property to 1.\n")
                property = 1;
        end

    % User Entered a Number
    else
            
        property = str2double(name);

    end
end