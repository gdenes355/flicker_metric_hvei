% demonstrating the usage of the flicker model when applied to temporal
% resolution multiplexing (multiple luminance and refresh rates)

% some basic display ppd
ppd = 20;

% loading and resizing image to something reasonable
img = imread('autumn.jpg');
img = imresize(img, 512 / size(img, 1));

% going to linear units
Img = display_model(img);

% emulate  temporal multiplexing technique technique
Blur = imresize(imresize(Img .^ (1/3), 0.25), [size(Img, 1), size(Img, 2)]) .^ 3;
Frame_A = Blur;
Frame_B = Img * 2 - Blur;

% show full image in fig 1
figure(1);
clf;
imshow(img);

% show grid in fig 2
figure(2);
clf;
addpath('tight_subplot'); % for visualisation
ha = tight_subplot(5, 4, [0.01, 0.01], [0.075, 0.001], [0.08, 0.001]);

% generate detection maps for different refresh rates and luminance levels
[ls, rrs] = meshgrid([50, 100, 200, 400], [50, 70, 90, 110]);
axes(ha(1));
imshow(display_model_inverse(Frame_A));
axes(ha(2));
imshow(display_model_inverse(Frame_B));
delete(ha(3));
delete(ha(4));
for ii=1:numel(ls)
    axes(ha(4+ii));
    P_map = predict_flicker_in_image(Frame_A * ls(ii), Frame_B * ls(ii), ppd, rrs(ii));
    imshow(flicker_visualize(P_map, double(img)/255));
    if mod(ii-1, 4) == 0
        ylabel(sprintf('%d cd/m^2', ls(ii)));
    end
    if ii > 12
        xlabel(sprintf('%dHz', rrs(ii)));
    end
end

function Img = display_model(img)
    Img = rgb2xyz(img, 'colorspace', 'srgb');
end

function img = display_model_inverse(Img)
    img = max(min(xyz2rgb(Img, 'colorspace', 'srgb'), 1), 0);
end