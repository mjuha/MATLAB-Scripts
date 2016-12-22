function [energy, volume] = computeEnergy(xe,Te, psie, phie)

global porosity_p Cd L Cl Tm

% 1 point formula - degree of precision 1
gp =  [ 1/4, 1/4, 1/4 ];
w =  1/6; % see Hughes's book.

ngp = length(w);

energy = 0;
volume = 0;
% loop over gauss points
for i=1:ngp
    [N,~,jac] = shape(gp(i,:),xe);
    % this is a hack to specify different material properties in the domain
    z = N*xe(:,3);
    if (z < 50e-6)
        porosity = (1 - psie) * porosity_p;
    else
        porosity = 0;
    end
    % rhoCp
    rhoCp = (1-porosity) * Cd;
    % compute phase function
    p = phie^3 * (10-15*phie+6*phie^2);
    % compute temperetaure
    T = N * Te;
    energy = energy + ( rhoCp * T + p * (L + (Cl - rhoCp) * (T - Tm)) ) * w * jac;
    volume = volume + w * jac;
end

end
