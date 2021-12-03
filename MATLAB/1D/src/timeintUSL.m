function [matpoints, grid] = timeintUSL(matpoints, grid, dt)
%integration of one time step using update stress last algorithm (USL)

grid = resetgrid(grid);
grid = activenodes(matpoints,grid); % Assigning the active nodes.

%mapping particle to nodes
for i=1:length(matpoints)
    
    ipart = mapelement(matpoints(i).pos, grid);
    nodes = [grid.elem(ipart).nodes];
    xlocal = 2*(matpoints(i).pos - grid.node(nodes(1)).pos)/grid.elemsize - 1;
    N = grid.elem(ipart).N(xlocal);
    dN = grid.elem(ipart).dN(xlocal)/grid.elemsize;
    
    %i) compute nodal mass
    grid.node(nodes(1)).mass = grid.node(nodes(1)).mass + N(1)*matpoints(i).mass;
    grid.node(nodes(2)).mass = grid.node(nodes(2)).mass + N(2)*matpoints(i).mass;
    %ii) compute nodal momentum
    grid.node(nodes(1)).momentum = grid.node(nodes(1)).momentum + N(1)*matpoints(i).velocity*matpoints(i).mass;
    grid.node(nodes(2)).momentum = grid.node(nodes(2)).momentum + N(2)*matpoints(i).velocity*matpoints(i).mass;
    
    %viii) compute nodal forces
    grid.node(nodes(1)).eforce = grid.node(nodes(1)).eforce + matpoints(i).mass * matpoints(i).g * N(1);
    grid.node(nodes(2)).eforce = grid.node(nodes(2)).eforce + matpoints(i).mass * matpoints(i).g * N(2);
    grid.node(nodes(1)).iforce = grid.node(nodes(1)).iforce - matpoints(i).volume * matpoints(i).stress * dN(1);
    grid.node(nodes(2)).iforce = grid.node(nodes(2)).iforce - matpoints(i).volume * matpoints(i).stress * dN(2);
end

for j=1:length(grid.node)
    if(grid.node(j).sup == 1)
        grid.node(j).eforce = 0;
        grid.node(j).iforce = 0;
        grid.node(j).damping = 0;
        grid.node(j).momentum = 0;
    end
    grid.node(j).velocity = grid.node(j).momentum/grid.node(j).mass;
    grid.node(j).damping = damping(grid.alpha, grid.node(j));
    grid.node(j).momentum = grid.node(j).momentum + dt*(grid.node(j).eforce + grid.node(j).iforce + grid.node(j).damping);
    grid.node(j).velocity = grid.node(j).momentum/grid.node(j).mass;
end

for i=1:length(matpoints)
    
    ipart = mapelement(matpoints(i).pos, grid);
    nodes = [grid.elem(ipart).nodes];
    xlocal = 2*(matpoints(i).pos - grid.node(nodes(1)).pos)/grid.elemsize - 1;
    N = grid.elem(ipart).N(xlocal);
    dN = grid.elem(ipart).dN(xlocal)/grid.elemsize;
    
    cont = 1;
    for j=nodes
        matpoints(i).velocity = matpoints(i).velocity + dt * N(cont) * (grid.node(j).eforce+grid.node(j).iforce+grid.node(j).damping)/grid.node(j).mass;
        matpoints(i).pos = matpoints(i).pos + dt * N(cont) * grid.node(j).momentum/grid.node(j).mass;
        matpoints(i).disp = matpoints(i).pos - matpoints(i).x0;
        cont = cont+1;
    end
    
    Lp=0;
    for j=1:length(nodes)
        Lp = Lp + dN(j)*grid.node(nodes(j)).velocity;
    end
    
    matpoints(i).Fp = (1+Lp*dt)*matpoints(i).Fp;
    matpoints(i).volume = matpoints(i).volume0*matpoints(i).Fp;
    dEps = dt*Lp;
    matpoints(i).strain = matpoints(i).strain + dEps;
    matpoints(i).stress = matpoints(i).stress + matpoints(i).E*dEps;
end

end

