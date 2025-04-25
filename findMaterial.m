function property = findMaterial(name)
    
    % User Entered a String
    if isnan(str2double(name))

        switch lower(name)
            % Conductors
            case {'ccs', 'bare copper clad steel'}
                property = 2.38e7;
            case {'tc', 'tinned copper'}
                property = 5.96e7;
            case {'bc', 'bare copper'}
                property = 5.96e7;
            case {'sc', 'silver covered copper'}
                property = 6.00e7;
            case {'sccs', 'silver covered copper clad steel'}
                property = 2.38e7;
            case {'al', 'aluminum'}
                property = 3.538e7;

            % Dielectrics
            case {'pe', 'polyethylene'}
                property = 2.26;
            case {'r', 'rubber'}
                property = 2.8;
            case {'ptfe', 'polytetrafluoroethylene'}
                property = 2.07;
            case {'foam pe', 'foam polyethylene'}
                property = 1.465;
            case {'pfa', 'perfluoroalkoxy alkane'}
                property = 2.1;
            case {'etfe', 'ethylene tetrafluoroethylene'}
                property = 2.6;
            case {'ectfe', 'ethylene clorotrifluoroethylene'}
                property = 2.5;
            case {'pvdf', 'polyvinylidene fluoride'}
                property = 7.8;
            case {'fep', 'fluorinated ethylene propylene'}
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