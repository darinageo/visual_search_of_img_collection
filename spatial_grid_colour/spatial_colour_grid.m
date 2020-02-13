function F=spatial_colour_grid(img, rows, cols)

% Function to compute the spatial colour grid
%% Input params:
% img:      RGB image 
% rows:     number of row cells 
% cols:     number of col cells
%% Output:
% F:        img descriptor

F = [];
img = double(img)./256;

grid_img = create_grid(img, rows, cols);
[row_size, col_size, ~] = size(grid_img);
valid = size(grid_img{1,1});

for i=1:row_size
    for j=1:col_size
        if (size(grid_img{i,j})==valid) 
            current_grid = grid_img{i, j};
            
            overall_mean = mean(mean(current_grid));
            
            mean_read = overall_mean(:,:,1);
            mean_green = overall_mean(:,:,2);
            mean_blue = overall_mean(:,:,3);
            
            curr_mean = [mean_read, mean_green, mean_blue];
            F = [F, curr_mean];
        end
        
    end
end

return;


