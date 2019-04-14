%%
clear all;
clc;

poses = uiimport('../data/poses.txt');
poses = poses.poses;

K = uiimport('../data/K.txt');
K = K.K;

D = uiimport('../data/D.txt');
D = D.D;

%%
cube_pts = [0.12 0.04   0    1;
            0.20 0.04   0    1;
            0.12 0.12   0    1;
            0.20 0.12   0    1;
            0.12 0.04  -0.08 1;
            0.20 0.04  -0.08 1;
            0.12 0.12  -0.08 1;
            0.20 0.12  -0.08 1];
        
undistorted = true;

if undistorted
   srcFiles = dir('../data/images_undistorted/*.jpg');  
else
   srcFiles = dir('../data/images/*.jpg');
end

[X, Y] = meshgrid([0:4:32]/100, [0:4:20]/100);

for i = 1:length(srcFiles)
    if undistorted
    uv = [];
    filename = strcat(srcFiles(i).folder, '\', srcFiles(i).name);   
    img = imread(filename);
    omega = poses(i, 1:3);
    theta = norm(omega);
    k = omega/theta;
    k_hat = cross_matrix(k);
    R = eye(3,3) + sin(theta)*k_hat + (1 - cos(theta))*k_hat*k_hat;
    t = poses(i, 4:6)';
    for j = 1:9
        for k = 1:6
            pixels = K*[R t]*[X(k, j); Y(k, j);0; 1];
            uv = [uv; pixels(1)/pixels(3) pixels(2)/pixels(3)];
        end
    end
    for l = 1:size(cube_pts, 1)
        pixels = K*[R t]*cube_pts(l,:)';
        uv = [uv; pixels(1)/pixels(3) pixels(2)/pixels(3)];
    end
    imshow(img);
    hold on;
    plot(uv(:,1), uv(:,2), 'ro', 'MarkerFaceColor',[1 0 0]);
    l1 = [uv(55, 1) uv(55, 2);
          uv(59, 1) uv(59, 2)];
    l2 = [uv(56, 1) uv(56, 2);
          uv(60, 1) uv(60, 2)];
    l3 = [uv(57, 1) uv(57, 2);
          uv(61, 1) uv(61, 2)];
    l4 = [uv(58, 1) uv(58, 2);
          uv(62, 1) uv(62, 2)];    
    l5 = [uv(59, 1) uv(59, 2);
          uv(60, 1) uv(60, 2)]; 
    l6 = [uv(60, 1) uv(60, 2);
          uv(62, 1) uv(62, 2)];  
    l7 = [uv(62, 1) uv(62, 2);
          uv(61, 1) uv(61, 2)]; 
    l8 = [uv(61, 1) uv(61, 2);
          uv(59, 1) uv(59, 2)];
    line(l1(:,1), l1(:, 2), 'Color','red','LineWidth',3);
    hold on;
    line(l2(:,1), l2(:, 2), 'Color','red','LineWidth',3);
    hold on;
    line(l3(:,1), l3(:, 2), 'Color','red','LineWidth',3);
    hold on;
    line(l4(:,1), l4(:, 2), 'Color','red','LineWidth',3); 
    hold on;
    line(l5(:,1), l5(:, 2), 'Color','red','LineWidth',3);  
    hold on;
    line(l6(:,1), l6(:, 2), 'Color','red','LineWidth',3); 
    hold on;
    line(l7(:,1), l7(:, 2), 'Color','red','LineWidth',3); 
    hold on;
    line(l8(:,1), l8(:, 2), 'Color','red','LineWidth',3);  
    hold off;
    else
    uv = [];
    filename = strcat(srcFiles(i).folder, '\', srcFiles(i).name);   
    img = imread(filename);
    omega = poses(i, 1:3);
    theta = norm(omega);
    k = omega/theta;
    k_hat = cross_matrix(k);
    R = eye(3,3) + sin(theta)*k_hat + (1 - cos(theta))*k_hat*k_hat;
    t = poses(i, 4:6)';
    for j = 1:9
        for k = 1:6
           XYZ = [R t]*[X(k, j); Y(k, j);0; 1];
           x = XYZ(1)/XYZ(3);
           y = XYZ(2)/XYZ(3);
           r2 = x^2 + y^2;
           r4 = r2^2;
           xprime = (1 + D(1)*r2 + D(2)*r4)*x;
           yprime = (1 + D(1)*r2 + D(2)*r4)*y;
           pixel = K*[xprime; yprime; 1];
           uv = [uv; pixel(1)/pixel(3) pixel(2)/pixel(3)];
        end
    end
    for l = 1:size(cube_pts, 1)
           XYZ = [R t]*cube_pts(l,:)';
           x = XYZ(1)/XYZ(3);
           y = XYZ(2)/XYZ(3);
           r2 = x^2 + y^2;
           r4 = r2^2;
           xprime = (1 + D(1)*r2 + D(2)*r4)*x;
           yprime = (1 + D(1)*r2 + D(2)*r4)*y;
           pixels = K*[xprime; yprime; 1];
           uv = [uv; pixels(1)/pixels(3) pixels(2)/pixels(3)];
    end
    imshow(img);
    hold on;
    plot(uv(:,1), uv(:,2), 'ro', 'MarkerFaceColor',[1 0 0]);
    l1 = [uv(55, 1) uv(55, 2);
          uv(59, 1) uv(59, 2)];
    l2 = [uv(56, 1) uv(56, 2);
          uv(60, 1) uv(60, 2)];
    l3 = [uv(57, 1) uv(57, 2);
          uv(61, 1) uv(61, 2)];
    l4 = [uv(58, 1) uv(58, 2);
          uv(62, 1) uv(62, 2)];    
    l5 = [uv(59, 1) uv(59, 2);
          uv(60, 1) uv(60, 2)]; 
    l6 = [uv(60, 1) uv(60, 2);
          uv(62, 1) uv(62, 2)];  
    l7 = [uv(62, 1) uv(62, 2);
          uv(61, 1) uv(61, 2)]; 
    l8 = [uv(61, 1) uv(61, 2);
          uv(59, 1) uv(59, 2)];
    line(l1(:,1), l1(:, 2), 'Color','red','LineWidth',3);
    hold on;
    line(l2(:,1), l2(:, 2), 'Color','red','LineWidth',3);
    hold on;
    line(l3(:,1), l3(:, 2), 'Color','red','LineWidth',3);
    hold on;
    line(l4(:,1), l4(:, 2), 'Color','red','LineWidth',3); 
    hold on;
    line(l5(:,1), l5(:, 2), 'Color','red','LineWidth',3);  
    hold on;
    line(l6(:,1), l6(:, 2), 'Color','red','LineWidth',3); 
    hold on;
    line(l7(:,1), l7(:, 2), 'Color','red','LineWidth',3); 
    hold on;
    line(l8(:,1), l8(:, 2), 'Color','red','LineWidth',3);  
    hold off;
    pause(0.1);
    end
end