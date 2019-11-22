function [lpyr, gpyr] = flicker_laplacian_pyramid_dec(img,levels,kernel_a)
% Function which builds laplacian pyramid according to a paper:
% The Laplacian Pyramid as Compact Image Code
%      by Peter J.Burt and Edward H.Adelson
%
% Usage:
%   laplacian_pyramid(img,levels,kernel_a)
%
% img - image in grey scale - matrix <height x width double>
% levels - height of pyramid , cannot be bigger then log_2(min(width,height)),
%          with levels=-1, the hight is equal to floor(log_2(min(width,height)))
% kernel_a - it is used for generating kernel for diffusion,
%       a method for that is given in the paper
%
% lpyr - cell array of matrices with the Laplacian pyramd, each higher
% level halves the resolution
% gpyr - cell array of matrices with the Gaussian pyramd
%
% It can be used also in such ways:
%   laplacian_pyramid(img) - levels set to be largest
%                           kernel_a set to be equal to 0.4
%   laplacian_pyramid(img,levels) - kernel_a set to be equal to 0.4
%
% For license information, see https://github.com/gdenes355/flicker_metric_hvei

switch nargin
    case 0
        warning('Incorrect number of parameters!')
        lpyr={};
        return;
    case 1
        g_pyramid=flicker_gaussian_pyramid_dec(img);
    case 2
        g_pyramid=flicker_gaussian_pyramid_dec(img,levels);
    case 3
        g_pyramid=flicker_gaussian_pyramid_dec(img,levels,kernel_a);
end
height = size(g_pyramid,2);
if height == 0
    lpyr={};
    return;
end
lpyr = {};
for i=1:height-1
    lpyr{i} = g_pyramid{i} - imresize(g_pyramid{i+1}, size(g_pyramid{i}), 'bilinear' );
end
lpyr{height} = g_pyramid{height};
if nargout > 1
    gpyr = g_pyramid;
end
