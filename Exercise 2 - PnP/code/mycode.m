clc
clear all


detected_corners = importdata('I:\David Scaramuzza\W3\exercise2\Exercise 2 - PnP\data\detected_corners.txt');
K = importdata('I:\David Scaramuzza\W3\exercise2\Exercise 2 - PnP\data\K.txt');
poses= importdata('I:\David Scaramuzza\W3\exercise2\Exercise 2 - PnP\data\p_W_corners.txt')/100;
points=12;

UI_dir ='I:\David Scaramuzza\W3\exercise2\Exercise 2 - PnP\data\images_undistorted';

% outputVideo = VideoWriter(fullfile(UI_dir,'shuttle_out.avi'));
% outputVideo.FrameRate = 30;
% open(outputVideo)

UI_folder = dir( fullfile(UI_dir, '*.jpg'));
nfiles = length(UI_folder);    % Number of files found
quats=[];
trans=[];
for p = 1:nfiles
    CurrentImageName = strcat(UI_folder(p).folder, '\', UI_folder(p).name);
    Image = imread(CurrentImageName);
    Image =rgb2gray(Image);
    imshow(Image);  % Display image.
    drawnow
    
    hold on;
    
    %% calibrated coordinates
    row=[];
    calib_corners=[];
    uv = reshape(detected_corners(p,:),2,12)';
    for j=1:points
        inter= inv(K)*[uv(j,1); uv(j,2); 1];
        calib_corners = [ calib_corners;  [inter(1) ,inter(2)]];
    end
    
    
    %% Q for single image
    
    Q=[];
    z= zeros(1,4);
    
    
    for j=1:points
        q=[ [poses(j,:), 1]          z                 -calib_corners(j,1)*[poses(j,:), 1] ;
            z           [poses(j,:), 1]         -calib_corners(j,2)*[poses(j,:), 1]];
        Q=[Q ; q];
        
    end
    
    %% Solve Q.M = 0
    [U, S, V] =svd(Q);
    M= reshape(V(:,end),4,3)';
    
    
    if det(M(:,1:3)) < 0
        M = -M;
    end
    
    R=M(:,1:3);
    T=M(:,4);
    
    [U S V]=svd(R);
    R_=U*V';
    
    alpha=norm(R_, 'fro')/norm(R, 'fro');
    M_=[R_,alpha*T ];
    
    new_pixels=[];
    %% projection 3D - 2D
    
    for j=1: points
        temp=K*M_*[poses(j,:) 1]';
        new_pixels=[new_pixels;  temp(1)/temp(3) temp(2)/temp(3)];
    end
    
    scatter(new_pixels(:,1),new_pixels(:,2),10,'r','filled')
    
    for j=1:2:2*points
        scatter(detected_corners(p,j),detected_corners(p,j+1),5,'g','filled')
    end
    drawnow
    hold off
    
    Rwc = inv(M_(:,1:3));
    twc = -inv(M_(:,1:3))*M_(:,4);
    qwc = rotMatrix2Quat(Rwc);
    quats = [quats qwc];
    trans = [trans twc];
end
plotTrajectory3D(30, trans, quats, poses);