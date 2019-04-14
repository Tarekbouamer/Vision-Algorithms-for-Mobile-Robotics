function descriptors = describeKeypoints(img, keypoints, r)
% Returns a (2r+1)^2xN matrix of image patch vectors based on image
% img and a 2xN matrix containing the keypoint coordinates.
% r is the patch "radius".

[~,num]= size(keypoints);
descriptors=zeros((2*r+1)*(2*r+1),num);
temp_img=padarray(img,[r r]);
for p=1: num
    x= temp_img(keypoints(1,p)-r+r:keypoints(1,p)+r+r,keypoints(2,p)-r+r:keypoints(2,p)+r+r);
    descriptors(:,p) = reshape(x,[(2*r+1)*(2*r+1),1]);
end 
