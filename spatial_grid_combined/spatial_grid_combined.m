function F=spatial_grid_combined(img, R, C, Q)

%% Input params:
% img:      RGB image 
% rows:     number of row cells 
% cols:     number of col cells
% Q:        Number of angle quantisation levels
%% Output:
% F:        Feature vector of img
F = [];
img_colour = img;
im = rgb2gray(img);
im=im2double(im);

% Gy = Gx'
Gx=[1 0 -1; 2 0 -2; 1 0 -1];
Gy=[1 2 1; 0 0 0; -1 -2 -1];

f_x = conv2(im, Gx, 'same');
f_y = conv2(im, Gy, 'same');

magnitude = zeros(size(im));
orientation = zeros(size(im));

[rows, cols] = size(im);

for i=1:rows
    for j=1:cols
        magnitude(i,j) = sqrt(f_x(i,j)^2+f_y(i,j)^2);
        orientation(i,j)=atan2(f_y(i,j),f_x(i,j));
        %orientation(i,j)=atan(f_y(i,j)/f_x(i,j));
    end
end


thresholded_magnitude = (magnitude>(pi/10));

grid_img = create_grid(im, R, C);
[row_size, col_size, ~] = size(grid_img);
valid = size(grid_img{1,1});

thresholded_mag_grid = create_grid(thresholded_magnitude, R, C);
orient_grid = create_grid(orientation, R, C);
img_colour_grid = create_grid(img_colour, R, C);

for i=1:row_size
    for j=1:col_size
        if (size(grid_img{i,j})==valid)
            current_colour_grid = img_colour_grid{i, j};
            [rr, cc] = size(grid_img{i, j});
            curr_thresholded_mag_grid = thresholded_mag_grid{i, j};
            curr_orient_grid = orient_grid{i,j};
            curr_orient_grid = curr_orient_grid+pi; % Adjust range from [-pi, pi] to [0, 2pi]
            distinguishable_edges_indexes = find(curr_thresholded_mag_grid>0);
            
            temp = [];
            [END, ~] = size(distinguishable_edges_indexes);
            for idx=1:END
                curr_edge_idx = distinguishable_edges_indexes(idx);
                curr_orient_cell = curr_orient_grid(curr_edge_idx);
                temp = [temp, curr_orient_cell];
                
            end
            
            temp = floor(temp.*Q);
            h = histogram(temp, Q);
            total_area = rr*cc;
            norm_h = h.Values/total_area;
            F = [F, norm_h];
            
            overall_mean = mean(mean(current_colour_grid));
            
            mean_read = overall_mean(:,:,1);
            mean_green = overall_mean(:,:,2);
            mean_blue = overall_mean(:,:,3);
            
            curr_mean = [mean_read, mean_green, mean_blue];
            F = [F, curr_mean];
            
        end
    end
end 


return;