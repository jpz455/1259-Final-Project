# coaxialDesignTool Documentation
### :magnet: Coaxial Cable Design Model :magnet:

## Description:
The purpose of this design tool is to take inputs from the user (geometric radii, material permittivity, material conductivity, operating frequency and more) 
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
<ins>*geom*</ins> (struct, scalar) - inner radius (*a*) and outer radius (*b*), specified as a scalar in meters (m). The *a* component (*geom.a*) specifies the inner conductor radius and the *b* component (*geom.b*) specifies the outer
radius.

<ins>*material*</ins> (struct, scalar) - relative permittivity (*er*), loss angle/dissipation factor (*tan_delta*), conductor conductivity (*sigma_c*) and dielectric conductivity (*sigma_d*).
All variables are scalars with respective units: *er* - (F/m), *tan_delta* - (radians), *sigma_c* and *sigma_d* - (S/m).

<ins>*operating*</ins> (struct, scalar) - operating frequency (*f*), specified as a scalar in Hertz (Hz).

### Output Arguments
All output arguments are accessed through the "*object_name.variable*" results struct (i.e. beta = result.beta).

#### Distributed Parameters

<ins>*R_per_m*</ins> (scalar) - resistance distributed paramter in Ohms per meter (ohms/m).  
Calculated based on the following equation: R = (1/2 * pi) * ((1/a) + (1/b)) * sqrt((pi * f * mu) / sigma_c).

<ins>*L_per_m*</ins> (scalar) - inductance distributed parameter in Henries per meter (H/m).  
Calculated based on the following equation: L = (mu / (2 * pi)) * log(b / a).

<ins>*C_per_m*</ins> (scalar) - capacitance distributed parameter in Farads per meter (F/m).  
Calculated based on the following equation: C = (2 * pi * eps) / log(b / a).

<ins>*G_per_m*</ins> (scalar) - conductance distributed paramter in Siemens per meter (S/m).  
Caculated based on the following equation: G = (2 * pi * sigma_d) / log(b / a).

#### Propogation Constant

<ins>*gamma*</ins> (scalar) - complex propagation constant in units of inverse meters (1/m).  
Calculated based on the following equation: gamma = sqrt((R + 1j * omega * L) * (G + 1j * omega * C)).

<ins>*alpha*</ins> (scalar) - attenuation constant; measure of how fast the signal attenuates (loses amplitude) in units of Nepers per meter (Np/m).  
Calculated based on the following equation: alpha = real(gamma).

<ins>*beta*</ins> (scalar) - phase constant; measure of how quickly the signal's phase rotates in units of radians per meter (rad/m).  
Calculated based on the following equation: beta = imag(gamma).

<ins>*alpha_dB_per_m*</ins> (scalar) - attenuation constant converted from units of Nepers per meter to units of decibels per meter (dB/m).  
Calculated based on the following equation: alpha_dB_per_m = 8.686 * alpha.

#### Propagation Velocity

<ins>*u_p*</ins> (scalar) - propagation velocity of a wave down a cable with losses in units of meters per second (m/s).  
Calculated based on the following equation: u_p = omega/beta.

#### Characteristic Impedance (lossy)

<ins>*Z0_dist*</ins> (scalar) - lossy characteristic impedance in Ohms (ohms).  
Calculated based on the following equation: Z0_dist = sqrt((R + 1j * omega * L) / (G + 1j * omega * C)).

#### Characteristic Impedance (lossless)

<ins>*Z0_lossless*</ins> (scalar) - lossless characteristic impedance in Ohms (ohms).  
Calculated based on the following equation: Z0_lossless = sqrt(L / C).

<ins>*beta_lossless*</ins> (scalar) - Beta value for a lossless cable in Radians per meter (rad/m).  
Calculated based on the following equation: beta_lossless = omega * sqrt(L * C).

<ins>*u_p_lossless*</ins> (vector) - propagation velocity of a wave down a lossless cable with R = 0 and G = 0 in units of meters per second (m/s).  
Calculated based on the following equation:  u_p_lossless = 1 / sqrt(L * C).

## Examples

<ins>Example 1:</ins> take a coaxial cable with inner radius 0.001m, outer radius 0.005m, relative permittivity 2.3 F/m, a loss tangent of 0.0002 radians,  
a conductor conducitivity of 5.8e7 S/m, and no dielectric conductivity (0 S/m) operating at a frequency of 1 GHz.

The user would set the following variables in the MATLAB script:  
*geom.a = 0.001;  
geom.b = 0.005;  
material.er = 2.3;  
material.tan_delta = 0.0002;  
material.sigma_c = 5.8e7;  
material.sigma_d = 0;  
operating.f = 1e9;  % 1 GHz*  

The user would then create a new object as follows to perform the built-in calculations:  
*result = coaxialDesignTool(geom, material, operating);*

The user can then choose to display the outputs they desire. For example if they wanted the characteristic impedance, attenuation constant,  
phase constant, and cable attenuation in dB/m they would use code such as the following to display it:  
*disp(result.Z0_dist)  
disp(result.alpha)  
disp(result.beta)  
fprintf('Attenuation: %.4f dB/m\n', result.alpha_dB_per_m);*  

<ins>MATLAB Terminal Output:</ins>  
\>> CoaxialExample
 63.6310 - 0.2446i

   0.1222

   31.7850

Attenuation: 1.0614 dB/m

## Limitations

-Assumes that non-magnetic materials are used for relative permeability of materials (mu_r = 1)

### Constants and Derived Constants
The following are the constants that are used in the design tool's calculations as well as the values they're taken to be.

<ins>*mu0*</ins> (scalar) - permeability of free space in units of Henries per meter (H/m).  
Taken to be mu0 = 4 * π * 1e-7.

<ins>*eps0*</ins> (scalar) - permittivity of free space; measures ability of a vacuum to allow electric field lines to pass through it, in units of Farads per meter (F/m).  
Taken to be eps0 = 8.854e-12.

<ins>*mu_r*</ins> (scalar) - relative permeability of material; measure of how easily a material can support the formation of a magnetic field within itself (unitless).  
Assumed to have  mu_r = 1 (non-magnetic materials).

<ins>*mu*</ins> (scalar) - absolute permeability of the material; in units of Henries per meter (H/m).  
Calculated based on the following equation: mu = mu0 * mu_r;

<ins>*eps*</ins> (scalar) - absolute premittivity of the material; in units of Farads per meter (F/m).  
Calculated based on the following equation: eps = eps0 * er;

## References

-ECE 1259 Lecture Notes
