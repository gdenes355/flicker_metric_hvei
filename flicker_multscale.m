classdef flicker_multscale
% For license information, see https://github.com/gdenes355/flicker_metric_hvei
    
    methods( Abstract )
        
        ms = decompose( ms, I );
        I = reconstruct( ms );
        
        B = get_band( ms, band, o );
        ms = set_band( ms, band, o, B );
        
        bc = band_count( ms );
        oc = orient_count( ms, band );

        % Get band frequences in cyc/deg
        bf = get_freqs( ms );
        
    end
    
end