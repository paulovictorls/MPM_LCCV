function matpoints = particlegen(matProp, bmesh, gausspoints)

nelements = size(bmesh.elem,2);

%generation of particles
cont = 1;
for i=1:nelements
    
    nodes = [bmesh.elem(i).nodes];
    
    %initialization of particles in the gauss points of a cell
    if gausspoints
        xlocal = gausspositions(matProp.npart_percell);
    else
        xlocal = equidistantpositions(matProp.npart_percell);
    end
    
    for j=1:length(xlocal)
        N = bmesh.elem(i).N(xlocal(j));
        pos = bmesh.node(nodes(1)).pos*N(1) + bmesh.node(nodes(2)).pos*N(2);
        if((pos <=matProp.L(end)) && (pos>=matProp.L(1)))
            
            matpoints(cont).pos = pos;
            matpoints(cont).x0 = matpoints(cont).pos;
            matpoints(cont).disp = matpoints(cont).pos - matpoints(cont).x0; 
            matpoints(cont).volume = bmesh.elemsize/matProp.npart_percell;
            matpoints(cont).mass = matpoints(cont).volume*matProp.density;
            matpoints(cont).Fp = 1;
            matpoints(cont).volume0 =  matpoints(cont).volume;
            matpoints(cont).velocity = matProp.v(matpoints(cont).pos);
            matpoints(cont).g = matProp.g;
            matpoints(cont).stress = 0;
            matpoints(cont).strain = 0;
            matpoints(cont).E = matProp.E;
            cont = cont+1;
        end
    end
end

end

