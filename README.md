# coaxialDesignTool Documentation
### :magnet: Coaxial Cable Design Model :magnet:

## Description:
The purpose of this design tool is to take inputs from the user (geometric radii, material permitivity, material conductivity, operating frequency and more) 
to calculate and determine information that would be useful for the design and fabrication of a coaxial cable. Once the function receives inputs, it will calculate
distributed parameters, propogation constants and velocity, and finally characteristic impedances for both lossy or lossless cables. The results of the calculations
are then stored in a results struct. Finally, the characteristic impedance, alpha, beta, and attenuation in dB/m amongst other results can be accessed by the user
calling specific variables of the results struct.


## Creation:
### Syntax
*result = coaxialDesignTool(geom, material, operating);*

### Description
*function result = coaxialDesignTool(geom, material, operating)* creates a new coaxial cable design object called "result" and sets the radii, material properties, and operating frequency.
The user provided information is then used to perform calculations and the results can be accessed by calling the object name's respective struct variables (i.e. result.gamma).


### Input Arguments
*geom* (scalar) - inner radius (*a*) and outer radius (*b*), specified as a scalar in meters (m). The *a* component (*geom.a*) specifies the inner conductor radius and the *b* component (*geom.b*) specifies the outer
radius.

*material* (scalar) - relative permitivity (*er*), loss angle/dissipation factor (*tan_delta*), conductor conductivity (*sigma_c*) and dielectric conductivity (*sigma_d*).
All variables are scalars with respective units: *er* - (F/m), *tan_delta* - (radians), *sigma_c* and *sigma_d* - (S/m).

*operating* (scalar) - operating frequency (*f*), specified as a scalar in Hertz (Hz).

### Output Arguments
All output arguments are accessed through the "*object_name.variable*" results struct (i.e. beta = result.beta).

*R_per_m* (scalar) - resistance distributed paramter in Ohms per meter (ohms/m).  
Calculated based on the following equation: (1/2\*pi)\*((1/a)+(1/b))\*sqrt((pi\*f*mu)/sigma_c)
