clc
clear all


D = importdata('I:\David Scaramuzza\W2\exercise1\Exercise 1 - Augmented Reality Wireframe Cube\data\D.txt');
K = importdata('I:\David Scaramuzza\W2\exercise1\Exercise 1 - Augmented Reality Wireframe Cube\data\K.txt');
poses= importdata('I:\David Scaramuzza\W2\exercise1\Exercise 1 - Augmented Reality Wireframe Cube\data\poses.txt');

UI_dir ='I:\David Scaramuzza\W2\exercise1\Exercise 1 - Augmented Reality Wireframe Cube\data\images';

outputVideo = VideoWriter(fullfile(UI_dir,'shuttle_out.avi'));
outputVideo.FrameRate = 30;
open(outputVideo)

UI_folder = dir( fullfile(UI_dir, '*.jpg'));
nfiles = length(UI_folder);    % Number of files found

for p = 1:nfiles
    CurrentImageName = strcat(UI_folder(p).folder, '\', UI_folder(p).name);
    Image = imread(CurrentImageName);
    Image =rgb2gray(Image);
    imshow(Image);  % Display image.
    
    [X,Y]=meshgrid(0:0.04:0.04*8, 0:0.04:0.04*5);
    [m,n]=size(X);
    
    omega = poses(p,1:3);
    theta = norm(omega);
    k_v = omega/theta;
    
    kv =[0 -k_v(1,3) k_v(1,2);
        k_v(1,3) 0 -k_v(1,1);
        -k_v(1,2) k_v(1,1) 0;];
    
    R = eye(3,3) + sin(theta)*kv + (1-cos(theta))*kv*kv;
    
    t = poses(p,4:6)';
    uv_chess=[];
    
    for i =1:m
        for j= 1:n
           
           M = [R t]*[X(i, j); Y(i, j);0; 1];
           x = M(1,1)/M(3,1);
           y = M(2,1)/M(3,1);
           r = x^2 + y^2;
           x_ = (1 + D(1)*r + D(2)*r^2)*x;
           y_ = (1 + D(1)*r + D(2)*r^2)*y;
           M_ = K*[x_; y_; 1];
           
           uv_chess = [uv_chess; M_(1,1)/M_(3,1) M_(2,1)/M_(3,1)];
        end
    end
    hold on;
    scatter(uv_chess(:,1),uv_chess(:,2),2,'r','filled')
    
 %% First cube
 
    x=0.08; y=0.08; z=0.08;
    
    C = [ x-z/2  y-z/2   0    1;
        x-z/2  y+z/2   0    1;
        x+z/2  y-z/2   0    1;
        x+z/2  y+z/2   0    1;
        
        x-z/2  y-z/2   -z    1;
        x-z/2  y+z/2   -z    1;
        x+z/2  y-z/2   -z    1;
        x+z/2  y+z/2   -z    1];
    
    uv_cube=[];
    
    for i =1:8
        
        M = [R t]*[C(i,1); C(i,2);C(i,3); 1];
        x = M(1,1)/M(3,1);
        y = M(2,1)/M(3,1);
        r = x^2 + y^2;
        x_ = (1 + D(1)*r + D(2)*r^2)*x;
        y_ = (1 + D(1)*r + D(2)*r^2)*y;
        M_ = K*[x_; y_; 1];
        
        uv_cube=[uv_cube; M_(1,1)/M_(3,1) M_(2,1)/M_(3,1) ];
    end
    scatter(uv_cube(:,1),uv_cube(:,2),'g','filled')
    
    line([uv_cube(1,1) uv_cube(2,1)], [uv_cube(1,2), uv_cube(2,2)],'Color','red','LineWidth',2);
    line([uv_cube(1,1) uv_cube(3,1)], [uv_cube(1,2), uv_cube(3,2)],'Color','red','LineWidth',2);
    line([uv_cube(1,1) uv_cube(5,1)], [uv_cube(1,2), uv_cube(5,2)],'Color','red','LineWidth',2);
    line([uv_cube(2,1) uv_cube(6,1)], [uv_cube(2,2), uv_cube(6,2)],'Color','red','LineWidth',2);
    line([uv_cube(5,1) uv_cube(6,1)], [uv_cube(5,2), uv_cube(6,2)],'Color','red','LineWidth',2);
    line([uv_cube(5,1) uv_cube(7,1)], [uv_cube(5,2), uv_cube(7,2)],'Color','red','LineWidth',2);
    line([uv_cube(8,1) uv_cube(7,1)], [uv_cube(8,2), uv_cube(7,2)],'Color','red','LineWidth',2);
    line([uv_cube(8,1) uv_cube(6,1)], [uv_cube(8,2), uv_cube(6,2)],'Color','red','LineWidth',2);
    line([uv_cube(2,1) uv_cube(4,1)], [uv_cube(2,2), uv_cube(4,2)],'Color','red','LineWidth',2);
    line([uv_cube(3,1) uv_cube(4,1)], [uv_cube(3,2), uv_cube(4,2)],'Color','red','LineWidth',2);
    line([uv_cube(3,1) uv_cube(7,1)], [uv_cube(3,2), uv_cube(7,2)],'Color','red','LineWidth',2);
    line([uv_cube(4,1) uv_cube(8,1)], [uv_cube(4,2), uv_cube(8,2)],'Color','red','LineWidth',2);
    
    
     %% Second cube
     
     x=0.08*4; y=0.08; z=0.04;
    
    C = [ x-z  y-z   0    1;
        x-z  y+z   0    1;
        x+z  y-z   0    1;
        x+z  y+z   0    1;
        
        x-z  y-z   -z    1;
        x-z  y+z   -z    1;
        x+z  y-z   -z    1;
        x+z  y+z   -z    1];
    
    uv_cube=[];
    
    for i =1:8
        
        M = [R t]*[C(i,1); C(i,2);C(i,3); 1];
        x = M(1,1)/M(3,1);
        y = M(2,1)/M(3,1);
        r = x^2 + y^2;
        x_ = (1 + D(1)*r + D(2)*r^2)*x;
        y_ = (1 + D(1)*r + D(2)*r^2)*y;
        M_ = K*[x_; y_; 1];
        
        uv_cube=[uv_cube; M_(1,1)/M_(3,1) M_(2,1)/M_(3,1) ];
    end
    scatter(uv_cube(:,1),uv_cube(:,2),'g','filled')
    
    line([uv_cube(1,1) uv_cube(2,1)], [uv_cube(1,2), uv_cube(2,2)],'Color','b','LineWidth',2);
    line([uv_cube(1,1) uv_cube(3,1)], [uv_cube(1,2), uv_cube(3,2)],'Color','b','LineWidth',2);
    line([uv_cube(1,1) uv_cube(5,1)], [uv_cube(1,2), uv_cube(5,2)],'Color','b','LineWidth',2);
    line([uv_cube(2,1) uv_cube(6,1)], [uv_cube(2,2), uv_cube(6,2)],'Color','b','LineWidth',2);
    line([uv_cube(5,1) uv_cube(6,1)], [uv_cube(5,2), uv_cube(6,2)],'Color','b','LineWidth',2);
    line([uv_cube(5,1) uv_cube(7,1)], [uv_cube(5,2), uv_cube(7,2)],'Color','b','LineWidth',2);
    line([uv_cube(8,1) uv_cube(7,1)], [uv_cube(8,2), uv_cube(7,2)],'Color','b','LineWidth',2);
    line([uv_cube(8,1) uv_cube(6,1)], [uv_cube(8,2), uv_cube(6,2)],'Color','b','LineWidth',2);
    line([uv_cube(2,1) uv_cube(4,1)], [uv_cube(2,2), uv_cube(4,2)],'Color','b','LineWidth',2);
    line([uv_cube(3,1) uv_cube(4,1)], [uv_cube(3,2), uv_cube(4,2)],'Color','b','LineWidth',2);
    line([uv_cube(3,1) uv_cube(7,1)], [uv_cube(3,2), uv_cube(7,2)],'Color','b','LineWidth',2);
    line([uv_cube(4,1) uv_cube(8,1)], [uv_cube(4,2), uv_cube(8,2)],'Color','b','LineWidth',2);
    
    
    hold off
    frame = getframe(gcf) ;
    drawnow;
    writeVideo(outputVideo, frame);

end
