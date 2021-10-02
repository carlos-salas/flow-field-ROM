function [imax,jmax,x_avg,y_avg] = loadGrid(snapshots_root)

fname = [snapshots_root,'snapshot_',num2str(4985,'%04d'),'.p3d'];
fileID = fopen(fname);  % open file
DIMS = textscan(fileID,'%s%s',1); 
imax = str2double(DIMS{1,1});
jmax = str2double(DIMS{1,2}); 

fclose all;

x = zeros(imax,jmax,100);
y = zeros(imax,jmax,100);

for count=1:100
   num = 4980+5*count;

   %load file
   fname = [snapshots_root,'snapshot_',num2str(num,'%04d'),'.p3d'];
   fileID = fopen(fname);  % open file
   textscan(fileID,'%s',1,'delimiter',char(460)); 

   FDATA = fscanf(fileID,'%f');
   
   x(:,1,count) = FDATA(1:imax);
   for j=2:jmax
       x(:,j,count) = FDATA((j-1)*imax+1:j*imax);
   end
   
   bound = jmax*imax;
   
   y(:,1,count) = FDATA(bound+1:bound+imax);
   for j=2:jmax
       y(:,j,count) = FDATA(bound+(j-1)*imax+1:bound+j*imax);
   end
   
    
   x_avg = mean(x,3);
   y_avg = mean(y,3);
   

end
   
fclose all;    