function scores = harris(img, patch_size, kappa)

Sx=[-1 0 1;
    -2 0 2;
    -1 0 1];

Sy=[-1 -2 -1;
     0  0  0;
     1  2  1];
 
 Ix= conv2(img,Sx,'valid');
 Iy= conv2(img,Sy,'valid');
 
 Ix2=Ix.*Ix;
 Iy2=Iy.*Iy;
 Ixy=Ix.*Iy;
 
 sigma=5;
 Gauss=fspecial('gaussian',patch_size,sigma);
 
 Sum_I2x = conv2(Ix2,Gauss,'valid');
 Sum_I2y = conv2(Iy2,Gauss,'valid');
 Sum_Ixy = conv2(Ixy,Gauss,'valid');
 
 scores = (Sum_I2x.*Sum_I2y - Sum_Ixy.*Sum_Ixy) - kappa*Sum_I2x.*Sum_I2y;
 scores( find( scores <0 )) = 0;
 scores = padarray(scores,[floor(patch_size/2)+1 floor(patch_size-1)/2+1 ]);
end
 
