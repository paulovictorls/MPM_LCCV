function [matpoints, grid] = timeintUSF(matpoints, grid, dt)
%integration of one time step using update stress first (USF)

grid = resetgrid(grid);
grid = activenodes(matpoints,grid); % Assigning the active nodes.

%mapping particle to nodes
for j=1:length(matpoints)
    ipart = mapelement(matpoints(j).pos, grid);
    nodes = [grid.elem(ipart).nodes];
    xlocal = 2*(matpoints(j).pos - grid.node(nodes(1)).pos)/grid.elemsize - 1;
    N = grid.elem(ipart).N(xlocal);

    %i) compute nodal mass
    grid.node(nodes(1)).mass = grid.node(nodes(1)).mass + N(1)*matpoints(j).mass;
    grid.node(nodes(2)).mass = grid.node(nodes(2)).mass + N(2)*matpoints(j).mass;
    %ii) compute nodal momentum
    grid.node(nodes(1)).momentum = grid.node(nodes(1)).momentum + N(1)*matpoints(j).velocity*matpoints(j).mass;
    grid.node(nodes(2)).momentum = grid.node(nodes(2)).momentum + N(2)*matpoints(j).velocity*matpoints(j).mass;
end

for j=1:length(grid.node)
    %iii) compute nodal velocities
    grid.node(j).velocity = grid.node(j).momentum/grid.node(j).mass;
    if(grid.node(j).sup == 1)
        grid.node(j).velocity = 0;
    end
end

for j=1:length(matpoints)
    
    ipart = mapelement( matpoints(j).pos, grid );
    
    nodes = [grid.elem(ipart).nodes];
    xlocal = 2*(matpoints(j).pos - grid.node(nodes(1)).pos)/grid.elemsize - 1;
    dN = grid.elem(ipart).dN(xlocal)/grid.elemsize;
    
    %iv) compute gradient velocity
    Lp = 0;
    for i = 1:length(nodes)
        Lp = Lp + dN(i)*grid.node(nodes(i)).velocity;
    end
    
    %v) compute gradient deformation tensor
    matpoints(j).Fp = (1+Lp*dt)*matpoints(j).Fp;
    %vi) update volume
    matpoints(j).volume = matpoints(j).volume0*matpoints(j).Fp;
    dEps = dt*Lp;
    %vii) update stress and strain
    matpoints(j).strain = matpoints(j).strain + dEps;
    matpoints(j).stress = matpoints(j).stress + matpoints(j).E*dEps;
    
    %viii) compute nodal forces
    grid.node(nodes(1)).eforce = grid.node(nodes(1)).eforce + matpoints(j).mass * matpoints(j).g * N(1);
    grid.node(nodes(2)).eforce = grid.node(nodes(2)).eforce + matpoints(j).mass * matpoints(j).g * N(2);
    grid.node(nodes(1)).iforce = grid.node(nodes(1)).iforce - matpoints(j).volume * matpoints(j).stress * dN(1);
    grid.node(nodes(2)).iforce = grid.node(nodes(2)).iforce - matpoints(j).volume * matpoints(j).stress * dN(2);
    grid.node(nodes(1)).damping = damping(grid.alpha, grid.node(nodes(1)));
    grid.node(nodes(2)).damping = damping(grid.alpha, grid.node(nodes(2)));
end


%ix) update noda momenta
for j=1:length(grid.node)
    if(grid.node(j).sup == 1)
        grid.node(j).eforce = 0;
        grid.node(j).iforce = 0;
        grid.node(j).damping = 0;
        grid.node(j).momentum = 0;
    end
    grid.node(j).momentum = grid.node(j).momentum + dt*(grid.node(j).eforce+grid.node(j).iforce+grid.node(j).damping);
end


for i=1:length(matpoints)
    
    ipart = mapelement(matpoints(i).pos, grid);
    
    nodes = [grid.elem(ipart).nodes];
    xlocal = 2*(matpoints(i).pos - grid.node(nodes(1)).pos)/grid.elemsize - 1;
    N = grid.elem(ipart).N(xlocal);
    
    
    for j=1:length(nodes)
        matpoints(i).velocity = matpoints(i).velocity + dt*N(j)*(grid.node(nodes(j)).eforce+grid.node(nodes(j)).iforce+grid.node(nodes(j)).damping)/grid.node(nodes(j)).mass;
        matpoints(i).pos = matpoints(i).pos + dt*N(j)*grid.node(nodes(j)).momentum/grid.node(nodes(j)).mass;
        matpoints(i).disp = matpoints(i).pos - matpoints(i).x0;
    end
end

end

