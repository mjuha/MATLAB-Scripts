%
global coordinates elements nel nnodes temperature basename np
global psi phi

% count number of nodes and cells
nnodesG = zeros(1,np);
ncellsG = zeros(1,np);
offset = zeros(1,np);

% coordinates = load('coordinates.txt');
% elements = load('elements.txt');
% nel = size(elements,1);
% nnodes = size(coordinates,1);



for i=0:np-1
    fname = [basename num2str(i) '.vtu'];
    fileID = fopen(fname,'r');
    fgetl(fileID);
    fgetl(fileID);
    tline = fgetl(fileID);
    % get number of points
    nnodesl = sscanf(tline,'<Piece NumberOfPoints="%d"');
    nnodesG(i+1) = nnodesl;
    % get number of cells
    str2 =['<Piece NumberOfPoints="' num2str(nnodesl) '"'];
    str3 = [str2 ' NumberOfCells="%d"'];
    ncellsl = sscanf(tline,str3);
    ncellsG(i+1) = ncellsl;
    fclose(fileID);
end
nnodes = sum(nnodesG);
nel = sum(ncellsG);

for i=2:np
    offset(i) = offset(i-1) + nnodesG(i-1);
end

% read the coordinates
coordinates = zeros(nnodes,3);
elements = zeros(nel,4);
temperature = zeros(nnodes,1);
% assuming only one Gauss point per element
phi = zeros(nel,1);
psi = zeros(nel,1);

str = '<DataArray type="Float64" Name="coordinates" NumberOfComponents="3" format="ascii">';
count = 0;
for i=0:np-1
    fname = [basename num2str(i) '.vtu'];
    fileID = fopen(fname,'r');
    tline = fgetl(fileID);
    while ischar(tline)
        if strcmp(tline,str)
            break;
        end
        tline = fgetl(fileID);
    end
    for k=1:nnodesG(i+1)
        count = count + 1;
        tline = fgetl(fileID);
        x = sscanf(tline,'%f');
        coordinates(count,:) = x(:);
    end
    fclose(fileID);
end

count = 0;
str = '<DataArray type="Int32" Name="connectivity" format="ascii">';
for i=0:np-1
    fname = [basename num2str(i) '.vtu'];
    fileID = fopen(fname,'r');
    tline = fgetl(fileID);
    while ischar(tline)
        if strcmp(tline,str)
            break;
        end
        tline = fgetl(fileID);
    end
    for k=1:ncellsG(i+1)
        count = count + 1;
        tline = fgetl(fileID);
        x = sscanf(tline,'%d');
        elements(count,:) = x(:) + offset(i+1) + 1;
    end
    fclose(fileID);
end

count = 0;
str = '<DataArray type="Float64" Name="Solution" NumberOfComponents="1" format="ascii">';
for i=0:np-1
    fname = [basename num2str(i) '.vtu'];
    fileID = fopen(fname,'r');
    tline = fgetl(fileID);
    while ischar(tline)
        if strcmp(tline,str)
            break;
        end
        tline = fgetl(fileID);
    end
    for k=1:nnodesG(i+1)
        count = count + 1;
        tline = fgetl(fileID);
        temperature(count) = str2double(tline);
    end
    fclose(fileID);
end

count = 0;
str = '<DataArray type="Float64" Name="Phi_1" NumberOfComponents="1" format="ascii">';
for i=0:np-1
    fname = [basename num2str(i) '.vtu'];
    fileID = fopen(fname,'r');
    tline = fgetl(fileID);
    while ischar(tline)
        if strcmp(tline,str)
            break;
        end
        tline = fgetl(fileID);
    end
    for k=1:ncellsG(i+1)
        count = count + 1;
        tline = fgetl(fileID);
        phi(count) = str2double(tline);
    end
    fclose(fileID);
end


count = 0;
str = '<DataArray type="Float64" Name="Psi_1" NumberOfComponents="1" format="ascii">';
for i=0:np-1
    fname = [basename num2str(i) '.vtu'];
    fileID = fopen(fname,'r');
    tline = fgetl(fileID);
    while ischar(tline)
        if strcmp(tline,str)
            break;
        end
        tline = fgetl(fileID);
    end
    for k=1:ncellsG(i+1)
        count = count + 1;
        tline = fgetl(fileID);
        psi(count) = str2double(tline);
    end
    fclose(fileID);
end


WriteVTKFile( 0, temperature )