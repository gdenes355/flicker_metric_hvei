function P = predict_flicker_in_image( frame_a, frame_b, ppd, fps, options )
% PREDICT_FLICKER_IN_IMAGE predicts the amount of flicker visible in a
% multiplexing scheme when alternating between frame_a and frame_b at fps
% frame_a - frame in CIE XYZ
% frame_b - frame in CIE XYZ. Size must be the same as frame_a
% [ppd] - pixels per visual degree on the display. Default: 52 (desktop)
% [fps] - frames per second. Default: 120Hz
% [options] - model parameters. Default: best fitting reported in the paper
%
% output:
% P - a probability of detection map; identical in size to frame_a and
% frame_b
%
% for example usage, see demo folder
%
% References:
% G. Denes, R. K. Mantiuk "Predicting visible flicker in temporally changing images", 
% Human Vision and Electronic Imaging, 2020
% 
%
% Copyright (c) 2017, Gyorgy Denes <gdenes355@gmail.com> and Rafal Mantiuk <mantiuk@gmail.com>
%
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.
%

    %% input processing , asserts
    assert(isequal(size(frame_a), size(frame_b)));
    if ~exist( 'ppd', 'var' )
        ppd = 52;
    end
    if ~exist( 'fps', 'var') || isempty(fps)
        fps = 120;
    end
    if ~exist( 'options', 'var' ) || isempty(options)
        options = {};        
    end
    opts = struct();
    opts.beta = 2;
    opts.sigma_pu = 0.36;
    opts.C_L0 = 1.9993;
    opts.C_W = -0.1059;
    opts.C_F = -0.0242;
    opts.C_L = 0.9102;
    for kk=1:2:length(options)
        opts.(options{kk}) = options{kk+1};
    end    

    % In case there is color, use only luminance
    if( size(frame_a,3) == 3 )
        Y_a = frame_a(:,:,2);
        Y_b = frame_b(:,:,2);
    else
        % Luminance only image
        Y_a = frame_a;
        Y_b = frame_b;
    end
    Y_m = (Y_a + Y_b) / 2;

    %% model code
    Yd = Y_a - Y_b; % difference frame
    
    % Laplacian pyramid decomposition
    ms = flicker_lpyr_dec( ); 
    ms = ms.decompose(Yd, ppd);

    % For each spatial freq. band
    for ll=1:(ms.band_count())
        freq = ms.get_freqs;
        freq = freq(ll);
        b = ms.get_band(ll,1);

        % Micheslon contrast: max-min/max+min. max-min is b in this band; max+min=2*mean
        Y_m_band = imresize(Y_m, size(b), 'box');
        c = abs(b)./(2 * Y_m_band + 0.00001);   % tiny normalisation value to avoid error in 0 (black) pixels

        % sensitivity with pyramid of visibility
        S = csf_pyrVis(fps / 2, freq, Y_m_band, opts ); 

        % normalise by sensitivity, then raise to beta
        d = (S .* c).^(opts.beta);    
        ms = ms.set_band( ll, 1, d );
    end

    % This will do probability summation
    D = ms.reconstruct();
    
    % Psychometric function 
    P = 1 - exp( log(0.5) *  D );
    
    % phase uncertainty
    P = imgaussfilt(P, opts.sigma_pu * ppd, 'padding', 'symmetric');
end
