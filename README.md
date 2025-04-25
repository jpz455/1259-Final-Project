# Coaxial Cable Design and Analysis Tool

### :magnet: Authors:
Jillian Zitcovich, Josh Brositz, Anthony Spadafore, and Sean Van Alen

---

## Description

This project provides a MATLAB-based interactive design tool for coaxial cables.  
Users can either:

- **Design a custom coaxial cable** by entering geometry, material, and operating parameters
- **Verify the software's accuracy** by comparing calculations against real-world cable catalog data

The tool computes distributed parameters (R', L', C', G'), propagation constants, characteristic impedances (lossy and lossless), power attenuation, and wavelength.  
It also provides graphical outputs including Smith Charts, attenuation plots, and voltage propagation along the cable.

---

## How to Use

1. Open `Test.m` in MATLAB.
2. Run the script.
3. Choose:
   - `1` to design your own cable
   - `2` to verify calculations against a provided coaxial cable catalog (`Coaxial Cable Catalog.csv`)

Follow the prompts to input geometric dimensions, material properties, and operating conditions.

The program will automatically:
- Display calculated properties
- Plot coaxial cable geometry
- Plot signal behavior over frequency
- Perform Smith Chart mapping
- Suggest a shunt capacitance for impedance matching
- Plot input impedance along the cable

---

## Repository Contents

| File | Purpose |
|:---|:---|
| `Test.m` | Main user interface. Guides users through cable design or verification workflow. |
| `coaxialDesignTool.m` | Core computation function. Calculates distributed parameters, impedance, and attenuation. |
| `findMaterial.m` | Maps material names to standard conductivity and permittivity values. |
| `matchLoadWithShuntCap.m` | Suggests shunt capacitor values to match a load impedance. |
| `plotSmith.m` | Plots normalized reflection coefficients on a Smith Chart. |
| `plotCoaxialBehavior.m` | Plots attenuation, characteristic impedance, wavelength, and voltage behavior across the cable length. |
| `coax_visualizer.m` | Visualizes the coaxial cable cross section. |
| `Coaxial Cable Catalog.csv` | Datasheet for real coaxial cables used in verification mode. |

---

## Features

- Calculate distributed parameters \( R', L', C', G' \)
- Compute lossy and lossless characteristic impedance
- Compute propagation constants (alpha, beta) and wavelength
- Analyze power loss along the cable
- Visualize coaxial cable geometry
- Plot:
  - Attenuation vs frequency
  - Characteristic impedance vs frequency
  - Wavelength vs frequency
  - Voltage propagation along the cable
- Plot normalized reflection coefficients on a Smith Chart
- Suggest shunt capacitor values for impedance matching
- Validate tool calculations against real-world catalog specifications

---

## Example Workflow

After running `Test.m`, select:
