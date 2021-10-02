clear all, close all, clc
load ../../../DATA/FLUIDS/CYLINDER_ALL.mat
X = VORTALL(:,1:end-1);
X2 = VORTALL(:,2:end);
[U,S,V] = svd(X,'econ');

%%  Compute DMD (Phi are eigenvectors)
r = 21;  % truncate at 21 modes
U = U(:,1:r);
S = S(1:r,1:r);
V = V(:,1:r);
Atilde = U'*X2*(V/S);
[W,eigs] = eig(Atilde);
Phi = X2*V*(S\W);

dt = 0.02;

lambda = diag (eigs); % discrete -time eigenvalues
omega = log ( lambda )/dt; % continuous -time eigenvalues
%% Compute DMD mode amplitudes b
x1 = X(:, 1);
b = Phi \x1;

%% DMD reconstruction
mm1 = size (X , 2); % mm1 = m - 1
time_dynamics = zeros(r, mm1 );

t = (0: mm1 -1) *dt; % time vector
for iter = 1:mm1
time_dynamics (:, iter ) = (b.*exp ( omega*t(iter )));
end 
Xdmd = Phi * time_dynamics ;

err=abs(Xdmd-X2)./X2;
plot(t,mean(err,1))
%% Plot DMD modes
% for i=10:2:20
%     plotCylinder(reshape(real(Phi(:,i)),nx,ny),nx,ny);
%     plotCylinder(reshape(imag(Phi(:,i)),nx,ny),nx,ny);
% end
% for tt=1:length(t)
%     plotCylinder(reshape(real(Xdmd(:,tt)),nx,ny),nx,ny)
%     pause(.001)
% %plotCylinder(reshape(real(X2(:,100)),nx,ny),nx,ny)
% end

%%  Plot DMD spectrum
% figure
% theta = (0:1:100)*2*pi/100;
% plot(cos(theta),sin(theta),'k--') % plot unit circle
% hold on, grid on
% scatter(real(diag(eigs)),imag(diag(eigs)),'ok')
% axis([-1.1 1.1 -1.1 1.1]);