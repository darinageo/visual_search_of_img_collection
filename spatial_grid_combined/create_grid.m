function F = create_grid(im, rows, cols)

F = [];
[height, width, colour] = size(im);

full_rows = fix(height/rows);
rem_rows = rem(height,rows);
row_grid = [full_rows * ones(1, rows), rem_rows];

full_cols = fix(width/cols);
rem_cols = rem(width,cols);
col_grid = [full_cols * ones(1, cols), rem_cols];

grid_img = mat2cell(im, row_grid, col_grid, colour);

F=grid_img;
end

