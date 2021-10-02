clear all, close all, clc

snapshots_root  = '../../../DATA/FLUIDS/airfoil/'; %change to correct address 
[imax,jmax,x,y] = loadGrid(snapshots_root);

% Third argument is the desired variable
% 1: Density
% 2: Velocity U
% 3: Velocity V
% 4: Pressure

X = loadAirfoil(imax,jmax,1,snapshots_root); 
Y = [X X];

%% augment matrix with mirror images to enforce symmetry/anti-symmetry
for k=1:size(X,2)
    xflip = reshape(flipud(reshape(X(:,k),imax,jmax)),imax*jmax,1);
    Y(:,k+size(X,2)) = -xflip;
end

%% compute mean and subtract;
FIELDavg = mean(Y,2);
f1 = plotCylinder(reshape(FIELDavg,imax,jmax),imax,jmax,x,y);  % plot average wake
%f1 = contour(x,y,reshape(FIELDavg,imax,jmax));
%% compute POD after subtracting mean (i.e., do PCA)
[PSI,S,V] = svd(Y-FIELDavg*ones(1,size(Y,2)),'econ');
% PSI are POD modes
figure
semilogy(diag(S)./sum(diag(S))); % plot singular vals

for k=1:4  % plot first four POD modes
    f1 = plotCylinder(reshape(PSI(:,k),imax,jmax),imax,jmax,x,y);
    %f1 = contour(x,y,reshape(PSI(:,k),imax,jmax));
end