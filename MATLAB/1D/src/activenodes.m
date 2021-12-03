%% function 'activenodes'

function [grid] = activenodes(matpoints, grid)

% This function verifies which of the elements in a grid have material
% points inside them, by assigning '1' to the 'active' flag of said
% elements, given:
%
% matpoints = a struct containing the material points of the object.
% grid = a mesh of finite elements.

% The following loop runs over all material points, verifying to which
% element them belong, one by one, and assigning the value '1' to the flag
% 'active' of the elements that contain these material points.

for i=1:length(matpoints)

    if (matpoints(i).pos < grid.bound(1) || matpoints(i).pos > grid.bound(2))
        error('ERROR: THE PARTICLES HAVE ESCAPED THE BACKGROUND MESH. TRY A LARGER ONE.');
    else
        ipart = mapelement(matpoints(i).pos, grid); % for each material point, 'ipart' picks up the ordinal number of the element in which said material point is contained. 
        grid.elem(ipart).active = 1; % assigning the value '1' to the 'active' flag of ordinal element 'ipart'.

        nodes = [grid.elem(ipart).nodes]; % 'nodes' gets the nodes of the ordinal 'ipart' element.

        for j=nodes
            grid.node(j).active = 1; % assigning the value '1' to the 'active' flag of nodes that belong to the ordinal 'ipart' element.
        end
    end
end
