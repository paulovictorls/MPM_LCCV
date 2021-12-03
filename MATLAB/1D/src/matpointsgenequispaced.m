function [ matpoints ] = matpointsgenequispaced( grid, L, nmatpointspercell,rho,E,n,v0)

nelements = size(grid.elements,2);

%generating velocity field for a sinusoidal velocity profile at t=0
beta = ((2*n-1)/2)*(pi/L(end));

%generation of particles
partcont = 1;
for i=1:nelements
    
    nodes = [grid.elements(i).nodes];
    
    %initialization of particles in the gauss points of a cell
    delement = grid.nodes(nodes(end)).pos - grid.nodes(nodes(1)).pos;
    
    for j=1:nmatpointspercell
        matpointposition = grid.nodes(nodes(1)).pos + (j-0.5)*delement/nmatpointspercell;
        
        if((matpointposition <=L(end)) && (matpointposition>=L(1)))
            matpoints(partcont).pos = matpointposition;
            matpoints(partcont).volume = delement/nmatpointspercell;
            matpoints(partcont).mass = matpoints(partcont).volume*rho;
            matpoints(partcont).Fp = 1;
            matpoints(partcont).volume0 =  matpoints(partcont).volume;
            matpoints(partcont).velocity = v0*sin(beta*matpoints(partcont).pos);
            matpoints(partcont).stress = 0;
            matpoints(partcont).strain = 0;
            matpoints(partcont).E = E;
            partcont = partcont+1;
        end
    end
end
end


