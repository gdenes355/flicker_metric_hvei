# flicker_metric_hvei
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Flicker predictor: a visual model for predicting flicker visibility in temporally changing images. The model performs a multi-scale analysis on the difference between consecutive frames, normalizing values with the spatio-temporal contrast sensitivity function as approximated by the pyramid of visibility. The output of the model is a 2D detection probability map.

[![Teaser](https://www.cl.cam.ac.uk/~gd355/publications/static/hvei20_teaser.png)](https://www.cl.cam.ac.uk/~gd355/publications/static/hvei20_teaser.png)

## Usage
The model is self-contained in this repository. The single entry point is: `predict_flicker_in_image.m` which takes two consecutive frames, a display resolution (ppd) and a refresh rate.
Frames should be in CIE XYZ colour-space

## Examples
For example usage, please see the `demo` folder

## References
[1] Gyorgy Denes, Rafal K. Mantiuk "Predicting visible flicker in temporally changing images" to appear in Human Vision and Electronic Imaging, 2020

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
