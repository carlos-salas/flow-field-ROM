function [imax,jmax,x,y] = loadGrid(snapshots_root)

fname = [snapshots_root,'snapshot_',num2str(10016,'%04d'),'.p3d'];
fileID = fopen(fname);  % open file
DIMS = textscan(fileID,'%s%s',1); 
imax = str2double(DIMS{1,1});
jmax = str2double(DIMS{1,2}); 



x = zeros(imax,jmax);
y = zeros(imax,jmax);




   FDATA = fscanf(fileID,'%f');
   
   x(:,1) = FDATA(1:imax);
   for j=2:jmax
       x(:,j) = FDATA((j-1)*imax+1:j*imax);
   end
   
   bound = jmax*imax;
   
   y(:,1) = FDATA(bound+1:bound+imax);
   for j=2:jmax
       y(:,j) = FDATA(bound+(j-1)*imax+1:bound+j*imax);
   end
   
   
fclose all;    