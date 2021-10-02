function [rho, u, v, p] = loadAirfoil(imax,jmax,snapshots_root)

% create space for 100 snapshots
rho = zeros(imax*jmax,200);
u = zeros(imax*jmax,200);
v = zeros(imax*jmax,200);
p = zeros(imax*jmax,200);

fields = zeros(imax,jmax,4);

for count=1:200
   num = 10000+16*count;

   %load file
   fname = [snapshots_root,'snapshot_',num2str(num,'%04d'),'_stats.p3d'];
   fileID = fopen(fname);  % open file
   textscan(fileID,'%s',2,'delimiter',char(460)); 

   FDATA = fscanf(fileID,'%f');
   
   %Matrix containing all variables for a given time   
   fields(1:imax*jmax) = FDATA(1:imax*jmax);
   fields(imax*jmax:imax*jmax*2) = FDATA(imax*jmax:imax*jmax*2);
   fields(imax*jmax*2:imax*jmax*3) = FDATA(imax*jmax*2:imax*jmax*3);
   fields(imax*jmax*3:imax*jmax*4) = FDATA(imax*jmax*3:imax*jmax*4);
    
   %Matrix containing all snapshots of one variable
   rho(:,count) = reshape(fields(:,:,1),imax*jmax,1);
   u(:,count) = reshape(fields(:,:,2),imax*jmax,1);
   v(:,count) = reshape(fields(:,:,3),imax*jmax,1);
   p(:,count) = reshape(fields(:,:,4),imax*jmax,1);
   
   
end
   
fclose all;
