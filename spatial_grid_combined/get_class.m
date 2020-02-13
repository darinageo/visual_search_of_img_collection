function [ class ] = get_class(filename)

% Function to get image class from image name
%% Input params:
% img:        Image candidate
% name:       Filename of image
%% Output:
% class:      Image class

sep = strfind(filename,'_');
class = str2num(filename(1:sep-1));
