function [ grid ] = gridgen( DL,nelem, suppos )

%nodes generation
pos = linspace(DL(1),DL(2),nelem+1);
grid.elemsize = pos(2)-pos(1);
for i=1:nelem+1
    if (pos(i)>suppos-grid.elemsize)&&(pos(i)<suppos+grid.elemsize)
        node(i).sup = 1;
    else
        node(i).sup = 0;
    end
    
    node(i).pos = pos(i);
    node(i).mass = 0;
    node(i).velocity = 0;
    node(i).momentum = 0;
    node(i).iforce = 0;
    node(i).eforce = 0;
end
grid.nodes = node;
grid.bound = [min(pos) max(pos)];
grid.elemsize = pos(2)-pos(1);

for i=1:nelem
    elements(i).nodes(:) = [i i+1];
    elements(i).N = @(r) 0.5*[1-r 1+r];
    elements(i).dN = @(r) [-1 1];
end
grid.elements = elements;

end

