clear all, close all, clc

snapshots_root  = '../../../DATA/FLUIDS/cylinder/'; %change to correct address 
[imax,jmax,x,y] = loadGrid(snapshots_root);

% rho: Density
% u: Velocity U
% v: Velocity V
% p: Pressure

[rho, u, v, p] = loadAirfoil(imax,jmax,snapshots_root);

gamma = 1.40;

U = u'*u;
V = v'*v;
X = (U+V)/200;


% Y = [X X];

% %% augment matrix with mirror images to enforce symmetry/anti-symmetry
% for k=1:size(X,2)
%     xflip = reshape(flipud(reshape(X(:,k),imax,jmax)),imax*jmax,1);
%     Y(:,k+size(X,2)) = -xflip;
% end

% %% compute mean and subtract;
% FIELDavg = mean(Y,2);
% f1 = plotCylinder(reshape(FIELDavg,imax,jmax),imax,jmax,x,y);  % plot average wake
%% compute POD after subtracting mean (i.e., do PCA)
%[PSI,S,V] = svd(Y-FIELDavg*ones(1,size(Y,2)),'econ');

% PSI are POD modes


% for k=1:4  % plot first four POD modes
%     f1 = plotCylinder(reshape(PSI(:,k),imax,jmax),imax,jmax,x,y);
% end

%%
% r = 8;
% PSI = PSI(:,1:r);
% S = S(1:r,1:r);
% V = V(:,1:r);


[beta,S] = svd(X);
S = diag(S);
figure
semilogy(S); % plot singular vals


phi_i = u*beta;
phi_j = v*beta;


GridNum = numel(x);
for j = 1:200
    PhiNor = 0;
    for ii = 1:GridNum
       PhiNor = PhiNor + phi_i(ii,j)^2+phi_j(ii,j)^2 ;
    end
    PhiNor = sqrt(PhiNor);
    phi_i(:,j) = phi_i(:,j)/PhiNor;
    phi_j(:,j) = phi_j(:,j)/PhiNor;
end

TimCoeU = u'*phi_i;    
TimCoeV = v'*phi_j;    
TimCoe = TimCoeU + TimCoeV; 

for k=1:3  % plot first four POD modes
     plotCylinder(reshape(phi_i(:,k),imax,jmax),imax,jmax,x,y);
     plotCylinder(reshape(phi_j(:,k),imax,jmax),imax,jmax,x,y);
end



%Identify most energetic modes
sum_modes = 0;
for lead_modes = 1:length(S)
   if sum_modes < .99*sum(S)
      sum_modes = sum_modes + S(lead_modes); 
   else
      break 
   end
end




