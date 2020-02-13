function F=global_col_histo(img,Q)

% Function to compute the Global colour histogram
%% Input params:
% img:      RGB image 
% Q:        The level of quantization of the RGB space
%% Output:
% H:        Feature vector of img

% qimg: normalized img
qimg = double(img)./256;
qimg = floor(qimg.*Q);

% extract red, green, blue channels
rdash = qimg(:,:,1);
gdash = qimg(:,:,2);
bdash = qimg(:,:,3);

% bin: a 2D image where each 'pixel' contains an integer value in range 0 to Q^3-1 inclusive
bin = rdash*(Q^2) + gdash*(Q) + bdash;

% vals: build a frequency histogram from these values
vals=reshape(bin,1,size(bin,1)*size(bin,2));

% Now we can use hist to create a histogram of Q^3 bins.
F = histogram(vals,Q^3-1);

return;







