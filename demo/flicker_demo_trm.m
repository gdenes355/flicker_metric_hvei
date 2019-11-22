% demonstrating the usage of the flicker model when applied to temporal
% resolution multiplexing

% some arbitrary display properties
peak_luminance = 50;
ppd = 20;
refresh_rate = 60;

% loading the image and resizing to something reasonable
img = imread('autumn.jpg');
img = imresize(img, 512 / size(img, 1));

% going from display-referenced values to CIE XYZ
Img = display_model(img, peak_luminance);


% emulate temporal multiplexing technique
Blur = imresize(imresize(Img .^ (1/3), 0.25), [size(Img, 1), size(Img, 2)]) .^ 3;
Frame_A = Blur;
Frame_B = Img * 2 - Blur;

figure(1);
clf;
P_map = predict_flicker_in_image(Frame_A, Frame_B, ppd, refresh_rate);
imshow(flicker_visualize(P_map, double(img)/255));

function Img = display_model(img, peak_luminance)
    Img = rgb2xyz(img, 'colorspace', 'srgb') * peak_luminance;
end

function img = display_model_inverse(Img, peak_luminance)
    img = max(min(xyz2rgb(Img / peak_luminance, 'colorspace', 'srgb'), 1), 0);
end