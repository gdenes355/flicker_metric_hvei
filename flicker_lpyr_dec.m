classdef flicker_lpyr_dec < flicker_multscale
% Decimated laplacian pyramid, non-fixed freq bands
% the band central frequencies may very depending on
% the ppd parameter. But it does not change the image size.
% Use flicker_lpyr for a fixed band frequency
% For license information, see https://github.com/gdenes355/flicker_metric_hvei

    
    properties
        P;
        
        ppd;
        base_ppd;
        img_sz;
        band_freqs;        
    end
    
    methods
                
        function ms = decompose( ms, I, ppd )
            
            ms.ppd = ppd;
            ms.img_sz = size(I);
            
            % We want the minimum frequency the band of 2cpd or higher
            height = max( ceil(log2(ppd))-2, 1 );
            ms.band_freqs = 2.^-(0:(height)) * ms.ppd / 2;            
            
            ms.P = flicker_laplacian_pyramid_dec( I, height+1 );
        end
        
        function I = reconstruct( ms )
            I = zeros( size(ms.P{end}) );
            for kk=length(ms.P):-1:1
                I = ms.P{kk} + imresize(I,size(ms.P{kk}), 'bilinear' );
            end
        end
        
        function B = get_band( ms, band, o )
            B = ms.P{band};
        end
            
        function ms = set_band( ms, band, o, B )
            ms.P{band} = B;
        end
                    
        function bc = band_count( ms )
            bc = length(ms.P);
        end
        
        function oc = orient_count( ms, band )
            oc = 1;
        end
        
        function sz = band_size( ms, band, o )
            sz = size( ms.P{band} );
        end

        function bf = get_freqs( ms )
            bf = ms.band_freqs;
        end
        
    end
    
end