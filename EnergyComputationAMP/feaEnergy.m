% feaEnergy.m
% Author: Dr. Mario J. Juha
% Date: 12/21/2016
%

clear all %#ok<CLSCR>
% global data
global coordinates elements nel temperature basename np
global porosity_p Cd L Cl Tm

tic();

% define location of base file
%basename = '/fasttmp/roys28/resultsFolder/2016October17/resultFiles2/lambda2_24cmS_50W_nonmelt_4/0/';
%basename = '/fasttmp/juham/test/souvik/testing1_2/0/';
basename = '/fasttmp/roys28/resultsFolder/2016October17/resultFiles2/lambda2_singlefile_50W_nonmelt_1/0/';

% number of processors
np = 1;

% porosity
porosity_p = 0.652;

% read data
inputdata;

% rho cp
Cd = 4.25e6;

% Cl
Cl = 5.95e6;

% Tm
Tm = 1700;

% L
L = 2.18e9;

% =============================
% Dimension the global matrices
% =============================


elapsed_time = toc();
fprintf('Elapsed time (s) used to read and process data = %i\n',elapsed_time);

tic();

% compute energy
% ===========================
energy = 0;
volume = 0;
for i=1:nel %loop over elements
    xe = coordinates(elements(i,:),:);
    Te = temperature(elements(i,:));
    psie = psi(i);
    phie = phi(i);
    [E,V] = computeEnergy(xe,Te,psie,phie);
    energy = energy + E;
    volume = volume + V;
end

fprintf('\n Energy = %g\n',energy)
fprintf('\n Volume = %g\n\n',volume)


elapsed_time = toc();
fprintf('Elapsed time (s) to postprocess data = %i\n', elapsed_time);
