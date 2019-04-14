clear all
close all
clc

num_scales = 3; % Scales per octave.
num_octaves = 5; % Number of octaves.
sigma = 1.6;
contrast_threshold = 0.04;
image_file_1 = 'images/img_1.jpg';
image_file_2 = 'images/img_2.jpg';
rescale_factor = 0.2; % Rescaling of the original image for speed.

images = {getImage(image_file_1, rescale_factor),...
    getImage(image_file_2, rescale_factor)};

% kpt_locations = cell(1, 2);
% descriptors = cell(1, 2);
blurred = cell(num_octaves, 2);   % create two containers for blurring step and Difference of Gaussians
Dog_Pyramid = cell(num_octaves, 2); % {number of octaves, number of images } ( I_im, J_im, stacks of sigmas )
Dog_max = cell(num_octaves, 2);
kpts = cell(num_octaves, 2);
kpts_locations = cell(num_octaves, 2);
Grad_magnitude = cell(num_octaves, 2);
Grad_orientation = cell(num_octaves, 2);
descriptors = cell(num_octaves, 2);
img_descriptors =cell(num_octaves, 2);
img_kpt_locations = cell(num_octaves, 2);
final_descriptors = cell(num_octaves, 2);
final_kpt_locations = cell(num_octaves, 2);

for img_idx = 1:2
    
    % generate images pyramids for defined number octaves
    for j=2:1:num_octaves
        images{j,img_idx}=imresize(images{j-1,img_idx},0.5);
    end
    
    % octaves
    for j=1:1:num_octaves
        
        % step one (1): blurring images
        for s =-1:1:num_scales+1
            sigma_ = sigma*2^(s/num_scales);
            h = fspecial('gaussian',16,sigma_);
            blurred{j,img_idx}(:,:,s+2) =  conv2(images{j,img_idx},h,'same');
        end
        
        % step two(2): generate difference of gaussians
        for i=1:1:5
            Dog_Pyramid{j,img_idx}(:,:,i) = abs (blurred{j,img_idx}(:,:,i+1) - blurred{j,img_idx}(:,:,i)) ;
        end
    end
    
    for j=1:1:num_octaves
        Dog_max{j,img_idx} = imdilate(Dog_Pyramid{j,img_idx}, true(3, 3, 3));
        kpts{j,img_idx} = (Dog_Pyramid{j,img_idx} == Dog_max{j,img_idx}) & (Dog_Pyramid{j,img_idx} >= contrast_threshold);
        kpts{j,img_idx}(:,:,1) =false;
        kpts{j,img_idx}(:,:,end) =false;
        [x,y,r] = ind2sub(size(kpts{j,img_idx}), find(kpts{j,img_idx}));
        kpts_locations{j,img_idx} = horzcat(x, y, r);
    end
    for j=1:1:num_octaves
        for s = 1:1:num_scales
            [Grad_magnitude{j,img_idx}(:,:,s), Grad_orientation{j,img_idx}(:,:,s)] = imgradient( blurred{j,img_idx}(:,:,s+2) );
        end
    end
    
    for j=1:1:num_octaves
        for s = 1:1:num_scales
            [L,~] = size(kpts_locations{j,img_idx});
            for l=1:L
                %                 [Grad_magnitude{j,img_idx}(:,:,s), Grad_orientation{j,img_idx}(:,:,s)] = imgradient( blurred{j,img_idx}(:,:,s+2) );
                Row = kpts_locations{j,img_idx}(l,1);
                Column = kpts_locations{j,img_idx}(l,2);
                Level = kpts_locations{j,img_idx}(l,3)-1;
                
                [M,N]= size(images{j,img_idx});
                hd = fspecial('gaussian', [16, 16], 16 * 1.5);
                
                if (Row > 7 && Row+8 <= M  &&  Column > 7 && Column+8 <=N )
                    descriptors {j,img_idx} (:,1:4,l) = reshape( Grad_magnitude{j,img_idx}(Row-7:Row+8 , Column-7:Column+8 , Level)*hd , [64,4]) ;
                    descriptors {j,img_idx} (:,5:8,l) = reshape( Grad_orientation{j,img_idx}(Row-7:Row+8 , Column-7:Column+8 , Level) , [64,4]) ;
                end
            end
        end
    end
 R=1;   
    for j=1:1:num_octaves
        for s = 1:1:num_scales
            [L,~] = size(kpts_locations{j,img_idx});
            is_valid = false(L, 1);
            for l=1:L
                
                Row = kpts_locations{j,img_idx}(l,1);
                Column = kpts_locations{j,img_idx}(l,2);
                Level = kpts_locations{j,img_idx}(l,3)-1;
                
                
                [M,N]= size(images{j,img_idx});
                
                if (Row > 7 && Row+8 <= M  &&  Column > 7 && Column+8 <=N )
                    is_valid(l,1) = true;
                    for num=1:16
                        vals    = reshape (descriptors {j,img_idx} (4*num-3:4*num,5:8,l),[1,16]);
                        weights = reshape (descriptors {j,img_idx} (4*num-3:4*num,1:4,l),[1,16]);
                        edges   = -180:45:180;
                        N_w = weightedhistc(vals, weights, edges);
                        img_descriptors{j,img_idx}(l,R:R+7) = N_w(1,1:8);
                        R=R+8;
                    end
                end
                
                img_kpt_locations {j,img_idx} (l,1:2) = kpts_locations {j,img_idx}(l,1:2).*2^(Level) ;
                img_kpt_locations {j,img_idx} (l,3)   = kpts_locations {j,img_idx}(l,3); 
            end
        k=find(is_valid);    
        final_descriptors {j,img_idx}(:,1:8,1:size(k)) = descriptors {j,img_idx} (:,1:8,k);
        final_kpt_locations {j,img_idx}(1:size(k),1:2) = img_kpt_locations{j,img_idx} (k,1:2);   
        end
    end
    
    
end



indexPairs = matchFeatures(final_descriptors {1,1}, final_descriptors {1,2},...
    'MatchThreshold', 100, 'MaxRatio', 0.7, 'Unique', true);








% Finally, match the descriptors using the function 'matchFeatures' and
% visualize the matches with the function 'showMatchedFeatures'.
% If you want, you can also implement the matching procedure yourself using
% 'knnsearch'.