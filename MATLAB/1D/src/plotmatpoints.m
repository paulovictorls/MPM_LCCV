%visualization function
function plotmatpoints(grid,matpoints,L)
%ploting the elements
hold off
plot([matpoints.pos],zeros(size([matpoints.pos])), 'o ')
hold on
for i=1:length(grid.elements)
    
    nodes = [grid.elements(i).nodes];
    
    plot(ones(10,1)*grid.nodes(nodes(1)).pos,linspace(-0.1,0.1,10),'b');
    plot(ones(10,1)*grid.nodes(nodes(2)).pos,linspace(-0.1,0.1,10),'b');
    plot([grid.nodes(nodes).pos], [0 0],'k');
end

xlim([grid.bound(1) grid.bound(2)])
ylim([-1 1])
end