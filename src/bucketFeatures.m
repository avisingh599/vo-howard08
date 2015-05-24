% The MIT License
% 
% Copyright (c) 2015 Avi Singh
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.

% this functions returns a list of feature vectors, such that there are at
% most numCorners number of features in every block (roughly ~100x100) of
% the image with which we are working. This ensures a uniform distribution
% of features over the image

function points = bucketFeatures(I, h, b, h_break, b_break, numCorners)
% input image I should be grayscale

y = floor(linspace(1, h - h/h_break, h_break));
x = floor(linspace(1, b - b/b_break, b_break));

final_points = [];
for i=1:length(y)
    for j=1:length(x)
    roi =   [x(j),y(i),floor(b/b_break),floor(h/h_break)];
    corners = detectFASTFeatures(I, 'MinQuality', 0.00, 'MinContrast', 0.1, 'ROI',roi );
    corners = corners.selectStrongest(numCorners);
    final_points = vertcat(final_points, corners.Location);
    end
end
points = cornerPoints(final_points);
