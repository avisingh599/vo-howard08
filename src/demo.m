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

% read calibration parameters (intrinsic and extrinsic) from the
% calibration file
calibname = '../sample_data/calib.txt';
T = readtable(calibname, 'Delimiter', 'space', 'ReadRowNames', true, 'ReadVariableNames', false);
A = table2array(T);

P1 = vertcat(A(1,1:4), A(1,5:8), A(1,9:12));
P2 = vertcat(A(2,1:4), A(2,5:8), A(2,9:12));

I1_l = rgb2gray(imread('../sample_data/image_2/000000.png'));
I1_r = rgb2gray(imread('../sample_data/image_3/000000.png'));
I2_l = rgb2gray(imread('../sample_data/image_2/000001.png'));
I2_r = rgb2gray(imread('../sample_data/image_3/000001.png'));

tic;
[R1, t1, cliqueSize, outlier, resnorm] = visodo(I1_l, I1_r, I2_l, I2_r, P1, P2);
toc

%only accept the results in which there are at least three point in the
%clique which is used for the determination of R, t
%  if (cliqueSize >= 3)
%      R = R1;
%      t = t1;
%  end

% use these lines if you want to 
%  pos = pos + Rpos*t;
%  Rpos = R*Rpos;
