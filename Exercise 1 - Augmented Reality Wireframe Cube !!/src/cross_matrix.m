function k_hat = cross_matrix(k)
 k = k(:);
 k_hat = [ 0,    -k(3),   k(2);
           k(3),     0,  -k(1);
          -k(2),  k(1),     0];
end