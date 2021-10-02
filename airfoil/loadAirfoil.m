function field_evolution = loadAirfoil(imax,jmax,field_num,snapshots_root)

% create space for 100 snapshots
field_evolution = zeros(imax*jmax,100);
fields = zeros(imax,jmax,4);

for count=1:100
   num = 4980+5*count;

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
   field_evolution(:,count) = reshape(fields(:,:,field_num),imax*jmax,1);
   
end
   
fclose all;
