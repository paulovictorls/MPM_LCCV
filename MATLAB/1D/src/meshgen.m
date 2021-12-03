function grid = meshgen(meshProp)

grid.bound = meshProp.limits;
grid.elemsize = meshProp.elemsize;
grid.alpha = meshProp.alpha;

nelem = (grid.bound(2)-grid.bound(1))/grid.elemsize;
suppos = meshProp.suppos;
pos = linspace(grid.bound(1),grid.bound(2),nelem+1);

for i=1:nelem+1
    
    if (pos(i)>suppos-meshProp.elemsize)&&(pos(i)<suppos+meshProp.elemsize)
        grid.node(i).sup = 1;
    else
        grid.node(i).sup = 0;
    end
    
    grid.node(i).pos = pos(i);
    grid.node(i).mass = 0;
    grid.node(i).velocity = 0;
    grid.node(i).momentum = 0;
    grid.node(i).iforce = 0;
    grid.node(i).eforce = 0;
    grid.node(i).damping = damping(grid.alpha, grid.node(i));
end

for i=1:nelem
    grid.elem(i).nodes(:) = [i i+1];
    grid.elem(i).N = @(r) 0.5*[1-r 1+r];
    grid.elem(i).dN = @(r) [-1 1];
end

end

