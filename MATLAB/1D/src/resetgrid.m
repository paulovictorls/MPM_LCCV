%% function 'resetgrid'

function [grid] = resetgrid(grid)

% This function resets the values of the finite element grid, given:
%
% grid = The original grid

% Getting the number of nodes in the grid:
nnodes = length(grid.node);

% The following loop runs through all nodes in the grid, setting their
% values at 0:

for i=1:nnodes
    grid.node(i).mass = 0;
    grid.node(i).momentum = 0;
    grid.node(i).iforce = 0;
    grid.node(i).eforce = 0;
    grid.node(i).velocity = 0;
    grid.node(i).active = 0;
end

% Getting the number of elements in the grid:
nelem = length(grid.elem);

% Setting the active flag of all element to '0':
for i=1:nelem
    grid.elem(i).active = 0;
end

end
