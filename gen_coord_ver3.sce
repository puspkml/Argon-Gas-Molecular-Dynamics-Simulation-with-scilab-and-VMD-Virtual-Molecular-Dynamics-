funcprot(0);

//================ LATTICE POSITION ===================
function [a1,a2,a3] = lattice_pos(index,Lx,Ly,Lz,lattice_const)
   l=1;
   for i = -Lx/2:Lx/2
       x=i*lattice_const;
       for j = -Ly/2:Ly/2
           y=j*lattice_const;
           for k = -Lz/2:Lz/2
               z=k*lattice_const;
               if (abs(x)<Lx/2) & (abs(y)<Ly/2) & (abs(z)<Lz/2) & (l<=index) then
                  a1=x; a2=y; a3=z;
                  l=l+1;
               end
           end
       end
   end
endfunction

//================ FORCE CALCULATION ===================
function [fx,fy,fz,en] = forces(x,y,z,npart,Lx,Ly,Lz,r_cuttoff,U_cut)

    fx = zeros(1,npart);
    fy = zeros(1,npart);
    fz = zeros(1,npart);
    en = 0;

    rcut2 = r_cuttoff^2;
    r2min = 1d-8;

    for i = 1:npart-1
        for j = i+1:npart

            xr = x(i) - x(j);
            yr = y(i) - y(j);
            zr = z(i) - z(j);

            // minimum image
            xr = xr - Lx*round(xr/Lx);
            yr = yr - Ly*round(yr/Ly);
            zr = zr - Lz*round(zr/Lz);

            r2 = xr^2 + yr^2 + zr^2;

            if (r2 < rcut2) & (r2 > r2min) then
                r2i  = 1/r2;
                r6i  = r2i^3;
                r12i = r6i^2;

                fij = 48*r2i*(r12i - 0.5*r6i);

                fx(i) = fx(i) + fij*xr;
                fy(i) = fy(i) + fij*yr;
                fz(i) = fz(i) + fij*zr;

                fx(j) = fx(j) - fij*xr;
                fy(j) = fy(j) - fij*yr;
                fz(j) = fz(j) - fij*zr;

                en = en + 4*(r12i - r6i) - U_cut;
            end
        end
    end
endfunction

//================ PARAMETERS ===================
npart = 729;
Lx = 10; Ly = 10; Lz = 10;
lattice_const = 1.05;
r_cuttoff = 3.0;
dt = 0.001;  // Reduced for better stability
steps = 1500;

// Compute potential shift for energy continuity
U_cut = 4 * ((1/r_cuttoff)^12 - (1/r_cuttoff)^6);

//================ ALLOCATION ===================
x = zeros(1,npart); y = x; z = x;
xu = x; yu = y; zu = z;
vx = x; vy = y; vz = z;
fx = x; fy = y; fz = z;

//================ INITIAL POSITIONS ===================
for i = 1:npart
    [x(i),y(i),z(i)] = lattice_pos(i,Lx,Ly,Lz,lattice_const);
end

// unwrapped = wrapped initially
xu = x; yu = y; zu = z;

//================ INITIAL VELOCITIES ===================
vx = rand(1,npart) - 0.5;
vy = rand(1,npart) - 0.5;
vz = rand(1,npart) - 0.5;

// remove COM velocity
vx = vx - mean(vx);
vy = vy - mean(vy);
vz = vz - mean(vz);

// velocity scaling
T0 = 1.0;
ekin0 = sum(0.5*(vx.^2 + vy.^2 + vz.^2));
scale = sqrt((3*(npart-1)*T0)/(2*ekin0));

vx = vx * scale;
vy = vy * scale;
vz = vz * scale;

//================ INITIAL FORCES ===================
[fx,fy,fz,en] = forces(x,y,z,npart,Lx,Ly,Lz,r_cuttoff,U_cut);

//================ OUTPUT ===================
fp1 = mopen("lattice_pos_729.xyz","wt");
fp2 = mopen("Energy_729.xyz","wt");
mfprintf(fp2,"Time        KE        PE        TE         Temp\n");

//================ VELOCITY–VERLET LOOP ===================
time = 0;

for step = 1:steps

    // Update half velocities
    vx_half = vx + 0.5 * dt * fx;
    vy_half = vy + 0.5 * dt * fy;
    vz_half = vz + 0.5 * dt * fz;

    // Update unwrapped positions
    xu = xu + dt * vx_half;
    yu = yu + dt * vy_half;
    zu = zu + dt * vz_half;

    // Wrap positions
    x = xu - Lx * round(xu / Lx);
    y = yu - Ly * round(yu / Ly);
    z = zu - Lz * round(zu / Lz);

    // Compute forces at new positions
    [fx,fy,fz,en] = forces(x,y,z,npart,Lx,Ly,Lz,r_cuttoff,U_cut);

    // Update velocities
    vx = vx_half + 0.5 * dt * fx;
    vy = vy_half + 0.5 * dt * fy;
    vz = vz_half + 0.5 * dt * fz;

    // Compute kinetic energy and temperature
    ekin = 0.5 * sum(vx.^2 + vy.^2 + vz.^2);
    sumv = sum(vx.^2 + vy.^2 + vz.^2);
    temp = sumv / (3 * (npart - 1));

    // Output positions
    mfprintf(fp1,"%d\n",npart);
    mfprintf(fp1,"Step %d\n",step);
    for i = 1:npart
        mfprintf(fp1,"Ar  %10.4f  %10.4f  %10.4f\n", x(i), y(i), z(i));
    end

    // Output energies
    mfprintf(fp2,"%8.4f %8.4f %8.4f %8.4f %8.4f\n", ...
         time, ekin, en, ekin+en, temp);

    time = time + dt;
end
mclose(fp1);
mclose(fp2);

//================ PLOT ===================
E = fscanfMat("Energy_729.xyz");
clf;
plot(E(:,1),E(:,4));
xlabel("Time (sec)");
ylabel("Total Energy (e)");
    
