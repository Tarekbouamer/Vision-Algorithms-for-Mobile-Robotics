clear all;
clc;

poses = uiimport('../data/poses.txt');
poses = poses.poses;

K = uiimport('../data/K.txt');
K = K.K;

D = uiimport('../data/D.txt');
D = D.D;

srcFiles = dir('../data/images/*.jpg');

for i = 1:length(srcFiles)
    filename = strcat(srcFiles(i).folder, '\', srcFiles(i).name);   
    Idistorted = imread(filename);

    
Idistorted = rgb2gray(Idistorted);
Idistorted = im2double(Idistorted);

fx = K(1,1);
fy = K(2,2);
cx = K(1,3);
cy = K(2,3);
k1 = D(1);
k2 = D(2);
k3 = 0;
p1 = 0;
p2 = 0;

I = zeros(size(Idistorted));
[i, j] = find(~isnan(I));

% Xp = the xyz vals of points on the z plane
Xp = K\[j i ones(length(i),1)]';

% Now we calculate how those points distort i.e forward map them through the distortion
r2 = Xp(1,:).^2+Xp(2,:).^2;
x = Xp(1,:);
y = Xp(2,:);

x = x.*(1+k1*r2 + k2*r2.^2) + 2*p1.*x.*y + p2*(r2 + 2*x.^2);
y = y.*(1+k1*r2 + k2*r2.^2) + 2*p2.*x.*y + p1*(r2 + 2*y.^2);

% u and v are now the distorted cooridnates
u = reshape(fx*x + cx,size(I));
v = reshape(fy*y + cy,size(I));

% Now we perform a backward mapping in order to undistort the warped image coordinates
I = interp2(Idistorted, u, v);

imshow(I);
pause(0.1);
end