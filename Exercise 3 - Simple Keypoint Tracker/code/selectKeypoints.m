function keypoints = selectKeypoints(scores, num, r)
% Selects the num best scores as keypoints and performs non-maximum 
% supression of a (2r + 1)*(2r + 1) box around the current maximum.
keypoints = zeros(2, num);

temp_scores = padarray(scores, [r r]);
siz=size(temp_scores);
for p = 1:num
    [M,val]= max(temp_scores(:));
    [i,j] = ind2sub(siz, val);
    
    keypoints(1, p) = i - r;
    keypoints(2, p) = j - r ;
    
    temp_scores(i-r:i+r,j-r:j+r)=zeros(2*r+1,2*r+1);
    %temp_scores(kp(1)-r:kp(1)+r, kp(2)-r:kp(2)+r) = ...
     %   zeros(2*r + 1, 2*r + 1);
end

end