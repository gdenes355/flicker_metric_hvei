function S = csf_pyrVis( temp_freq, spatial_freq, L, opts )
    % cff_pyrVis computing the contrast sensitivity function based on the
    % pyramid of visibility
    %
    % 
    % example usage: 
    % opts = struct('C_L0', 2.19, 'C_W', -0.060, 'C_F', -0.065, 'C_L', 0.388); % S5 in Watson et al. 
    % S = csf_pyrVis(W, F, L, opts);    % where W is the temporal
    % frequency, F is the spatial frequency, and L is the background
    % luminance
    %
    % For license information, see https://github.com/gdenes355/flicker_metric_hvei
    %
    % References:
    % A.B. Watson, A.J. Ahumada, "The pyramid of visibility", Human Vision and Electronic Imaging, vol. 2016, pp. 1-6, feb 2016.
    %
    S_log = opts.C_L0 + opts.C_W .* temp_freq + opts.C_F .* spatial_freq + opts.C_L .* log(L);       
    S = exp(S_log);
end
