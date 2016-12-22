function WriteVTKFile( istep, d )
% ======================================================================
% This file is part of FlowSolveQuad.

%    FlowSolveQuad is free software: you can redistribute it and/or modify
%    it under the terms of the GNU Lesser General Public License as 
%    published by the Free Software Foundation, either version 3 of the 
%    License, or (at your option) any later version.

%    FlowSolveQuad is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU Lesser General Public License for more details.

%    You should have received a copy of the GNU Lesser General Public 
%    License along with FlowSolveQuad.  
%    If not, see <http://www.gnu.org/licenses/>.
%
%
% Author: Mario J. Juha, Ph.D
% Date: 08/22/2014
% Tampa - Florida
% =====================================================================
global coordinates nnodes nel elements psi phi

if istep < 10
    % file name
    fname = ['output000' num2str(istep) '.vtk'];
elseif istep < 100
    % file name
    fname = ['output00' num2str(istep) '.vtk'];
elseif istep < 1000
    % file name
    fname = ['output0' num2str(istep) '.vtk'];
else
    % file name
    fname = ['output' num2str(istep) '.vtk'];
end

% open file
fid = fopen (fname, 'w');

fprintf(fid, '# vtk DataFile Version 3.8\n');
fprintf(fid, 'Velocities, pressures and level set\n');
fprintf(fid,'ASCII\n');
fprintf(fid, 'DATASET UNSTRUCTURED_GRID\n');
fprintf(fid, '%s %d %s\n','POINTS ', nnodes, 'float');
for i=1:nnodes
    fprintf(fid, '%f  %f  %f\n', coordinates(i,1), coordinates(i,2), coordinates(i,3));
end
fprintf(fid, '%s %d %d\n','CELLS ', nel, 5*nel);
for i=1:nel
    fprintf(fid, '%d %d %d %d %d\n',4, elements(i,:)-1);
end
fprintf(fid, '%s %d\n','CELL_TYPES ', nel);
for i=1:nel
    fprintf(fid, '%d\n', 10);
end
fprintf(fid, '%s %d\n', 'POINT_DATA ', nnodes);
fprintf(fid, 'SCALARS Temperature float\n');
fprintf(fid, 'LOOKUP_TABLE default\n');
for i=1:nnodes
    fprintf(fid, '%f\n',d(i));
end
fprintf(fid, '%s %d\n', 'CELL_DATA ', nel);
fprintf(fid, 'SCALARS Psi float 1\n');
fprintf(fid, 'LOOKUP_TABLE default\n');
for i=1:nel
    fprintf(fid, '%f\n',psi(i));
end 
fprintf(fid, 'SCALARS Phi float 1\n');
fprintf(fid, 'LOOKUP_TABLE default\n');
for i=1:nel
    fprintf(fid, '%f\n',phi(i));
end 

fclose(fid);


end

