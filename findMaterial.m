function property = findMaterial(name)
    switch name
        case 'CCS'  %Bare Copper Clad Steel
            property =
        case 'BC'   %Bare Copper
            property =
        case ''
            otherwise
    end
end