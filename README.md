# Molecular Dynamics Simulation of Argon Gas  
Using the Lennard–Jones Potential (NVE Ensemble)

A classical molecular dynamics (MD) simulation of argon gas performed using the Lennard–Jones (LJ) potential in reduced units. The system is evolved under periodic boundary conditions using the velocity–Verlet integration scheme in the microcanonical (NVE) ensemble. Energy conservation, density dependence, and gas-phase behavior are systematically analyzed.


## Author
Puspa Kamal Rai  
M.Sc. Physics  
Department of Physics  
Sri Sathya Sai Institute of Higher Education  


## Project Overview

**System**: Monoatomic argon gas  
**Interaction**: Lennard–Jones (12–6) potential  
**Ensemble**: Microcanonical (NVE)  
**Integrator**: Velocity–Verlet  
**Boundary Conditions**: Periodic (PBC)  
**Units**: Reduced Lennard–Jones units  
**Visualization**: VMD  

The study focuses on:
_- Energy conservation in NVE dynamics
- Effect of particle density on kinetic, potential, and total energy
- Physical validation of dilute gas behavior_


## Model Details
### Simulation Box
Cubic box of size  
Lx = Ly = Lz = 10  

**Volume**  
V = 1000  

### Particle Count
Lattice spacing ≈ 1.05  
Particles per direction: 9  
Total particles  
N = 9³ = 729  

### Number Density
ρ = N / V = 0.729  
This density corresponds to a dilute gas regime.

## Units (Reduced Lennard–Jones)
All quantities are expressed in LJ reduced units:
σ = 1  
ε = 1  
m = 1  
kB = 1  

## Interaction Potential

The **Lennard–Jones potential** is given by
U(r) = 4 ( r⁻¹² − r⁻⁶ )

The corresponding force is
Fᵢⱼ = 48 r⁻² ( r⁻¹² − ½ r⁻⁶ ) rᵢⱼ

**Cutoff radius**  
rc = 3.0  
The potential is shifted so that U(rc) = 0.

## Numerical Method

### Equations of Motion
m d²rᵢ / dt² = Fᵢ  

### Integration Scheme

Velocity–Verlet algorithm
rᵢ(t + Δt) = rᵢ(t) + vᵢ(t) Δt + ½ aᵢ(t) Δt²  
vᵢ(t + Δt) = vᵢ(t) + ½ [ aᵢ(t) + aᵢ(t + Δt) ] Δt  

**Time step**  
Δt = 0.001  

## Thermodynamic Quantities

### Total Energy
E = K + U  

### Kinetic Energy
K = ½ Σ ( vxi² + vyi² + vzi² )  

### Temperature (Equipartition)
T = 1 / [ 3 ( N − 1 ) ] Σ ( vxi² + vyi² + vzi² )  

Temperature emerges dynamically since the simulation is performed in the NVE ensemble.

## Visualization
Particle trajectories and configurations are visualized using VMD.
Initial configuration: simple cubic lattice  
Final configuration: homogeneous, disordered gas state  

_The disappearance of lattice order confirms equilibration to a dilute gas phase.
_
## Energy Analysis

### Density Dependence

- Potential energy becomes increasingly negative with density
- Kinetic energy increases due to enhanced collision frequency
- Total energy decreases smoothly and remains conserved

No discontinuities or anomalies are observed, confirming gas-phase behavior.

## Energy Conservation and Error Analysis
Total energy fluctuations are of order 10⁻⁶  
No long-term drift is observed  
Larger fluctuations in kinetic and potential energies are physical, not numerical.
This validates:
- Force calculation
- Timestep selection
- Correct NVE implementation

## Results Summary
- Stable NVE dynamics achieved
- Excellent energy conservation
- Physically consistent trends with particle density
- No clustering or phase transition observed

## Conclusion

This project demonstrates a reliable molecular dynamics implementation for a monoatomic Lennard–Jones gas. The results are consistent with classical kinetic theory and validate the velocity–Verlet integrator under periodic boundary conditions. The framework can be extended to higher densities, different ensembles, or transport property calculations.

## License

This project is intended for academic and educational use.
