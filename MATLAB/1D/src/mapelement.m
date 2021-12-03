function i = mapelement(x, grid)
%given position x this function returns the element i in 
%which the particle is located

 i = ceil((x - grid.bound(1))/grid.elemsize);

end
