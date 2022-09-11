# flicker_metric_hvei
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Flicker predictor: a visual model for predicting flicker visibility in temporally changing images. The model performs a multi-scale analysis on the difference between consecutive frames, normalizing values with the spatio-temporal contrast sensitivity function as approximated by the pyramid of visibility. The output of the model is a 2D detection probability map.

[![Teaser](https://www.cl.cam.ac.uk/~gd355/publications/static/hvei20_teaser.png)](https://www.cl.cam.ac.uk/~gd355/publications/static/hvei20_teaser.png)

## Usage
The model is self-contained in this repository. The single entry point is: `predict_flicker_in_image.m` which takes two consecutive frames, a display resolution (ppd) and a refresh rate.
Frames should be in CIE XYZ colour-space

## Examples
For example usage, please see the `demo` folder

## Dataset
You can evaluate your own flicker model against our dataset if you would like to. The entire dataset is uploaded and can be found in `stimuli.mat`. Use Matlab (scipi.io.loadmat from Python) to open this.
Fields:
* P: 18x512x512 array: aggregated marking probabilities for the 18 images
* P_observers: 18x19x512x512 array: marking probabilities for the 18 images for the 19 individual observers (averaged over 3 trials per observer)
* V_observers: 18x19x512x512 array: marking variance for the 18 images for the 19 individual observers (measured over 3 trials per observer)
* V_sample: 18x512x512 array: sample variance for the 18 image markings (measured as `var(P_observers, 1, 2) / 9`)
* V_simple: 18x512x512 array: variance estimated as pq
* names: 18x1 cell: image names
* levels: 18x1 array: blur levels
* refreshRates: 18x1 array: refresh rate at which the images were displayed (note that the flicker frequency of the alternating signal is half of the refresh rate -- see Nyquist)
* ref: 18x512x512x3 array: 18 sharp images encoded in CIE 1931 XYZ
* blur : 18x512x512x3 array: 18 blurry images encoded in CIE 1931 XYZ
Data was measured on 52ppd.

An example use of the stimuli would be:
```matlab
iS = 8;  % use the 8th stimulus
ppd = 52;
PMap = predict_flicker_in_image(squeeze(stimuli.ref(iS,:,:,:)), ...
                                squeeze(stimuli.blur(iS,:,:,:)), ...
                                ppd, stimuli.refreshRates(iS));
PMap = clamp(PMap, 0, 1);                           
GroundTruth = squeeze(stimuli.P(iS,:,:));
```

## References
[1] Gyorgy Denes, Rafal K. Mantiuk "Predicting visible flicker in temporally changing images" in Human Vision and Electronic Imaging, 2020
https://doi.org/10.2352/ISSN.2470-1173.2020.11.HVEI-233

Paper pre-print: https://www.cl.cam.ac.uk/~gd355/publications/hvei20_paper_comp.pdf

## License
MIT License

Copyright (c) 2017 Gyorgy Denes and Rafal K. Mantiuk

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
