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

function [R, T, cliqueSize, outliers, resnorm] = visodo(I1_l, I1_r, I2_l, I2_r, P1, P2)
%% The core visual odometry function
%INPUT:
% I1_l -> a grayscale image, from camera 1 (left) at some time t
% I1_r -> a grayscale image, from camera 2 (right) at some time t
% I2_l -> a grayscale image, from camera 1 (left) at time t+1
% I2_r -> a grayscale image, from camera 2 (right) at time t+1
% P1 -> the [3x4] projection matrix of camera 1 (left)
% P2 -> the [3x4] projection matrix of camera 2 (right)
%
%OUTPUT:
% R-> The rotation matrix [3x3] describing the change in orientation from t to
% t+1
% T-> The tranlsation vector [3x1] describing the change in cartesian
% coordinates of the vehicle from t to t+1
% cliqueSize -> the size of the cliques used in the Levenberg-Marquardt 
% optimization (checkout the documentation/blog for more info)
% 
disparityMap1 = disparity(I1_l,I1_r, 'DistanceThreshold', 5);
disparityMap2 = disparity(I2_l,I2_r);

[h,b] = size(I1_l);
h_break = 4;
b_break = 12;
numCorners = 100;
inlierThresh = 0.01;

points1_l = bucketFeatures(I1_l, h, b, h_break, b_break, numCorners);
tracker = vision.PointTracker('MaxBidirectionalError', 1);
initialize(tracker, points1_l.Location, I1_l);
[points2_l, validity] = step(tracker, I2_l);
TF1 = validity(:)==0;
points1_l = points1_l.Location;
points1_l(TF1,:) = [];
points2_l(TF1,:) = [];

M1_l=points1_l;
M2_l=points2_l;
M2_l = round(M2_l);
M1_r = M1_l;
M2_r = M2_l;
counter = 0;
allow = [];
for i = 1:size(M1_l,1)
    if ((disparityMap1(M1_l(i,2),M1_l(i,1))>0)&&(disparityMap1(M1_l(i,2),M1_l(i,1))<100)&&(disparityMap2(M2_l(i,2),M2_l(i,1))>0)&&(disparityMap2(M2_l(i,2),M2_l(i,1))<100))
    M1_r(i, 1) = (M1_l(i, 1) - disparityMap1(M1_l(i,2),M1_l(i,1)));
    M2_r(i, 1) = (M2_l(i, 1) - disparityMap2(M2_l(i,2),M2_l(i,1)));
    allow(i) = 1;
    counter = counter + 1;
    end
end

TF1 = allow(:)==0; 
M1_r(TF1,:) = [];
M1_l(TF1,:) = [];
M2_r(TF1,:) = [];
M2_l(TF1,:) = [];

%figure; showMatchedFeatures(I1_l, I2_l, matchedPoints1_l, matchedPoints1_r);

points3D_1 = ones(size(M1_l,1),4); % store homogeneous world coordinates
points3D_2 = ones(size(M2_l,1),4); % store homogeneous world coordinates

%For all point correspondences
for i = 1:size(M1_l,1)
    % For all image locations from a list of correspondences build an A
    pointInImage1 = M1_l(i,:);
    pointInImage2 = M1_r(i,:);
    
    A = [
        pointInImage1(1)*P1(3,:) - P1(1,:);
        pointInImage1(2)*P1(3,:) - P1(2,:);
        pointInImage2(1)*P2(3,:) - P2(1,:);
        pointInImage2(2)*P2(3,:) - P2(2,:)];

    % Compute the 3-D location using the smallest singular value from the
    % singular value decomposition of the matrix A
    [~,~,V]=svd(A);

    X = V(:,end);
    X = X/X(end);

    % Store location
    points3D_1(i,:) = X';

end
points3D_1 = points3D_1(:,1:3);
%scatter3(points3D(:,1), points3D(:,2), points3D(:,3))

for i = 1:size(M1_l,1)
    % For all image locations from a list of correspondences build an A
    pointInImage1 = M2_l(i,:);
    pointInImage2 = M2_r(i,:);   
    
    A = [
        pointInImage1(1)*P1(3,:) - P1(1,:);
        pointInImage1(2)*P1(3,:) - P1(2,:);
        pointInImage2(1)*P2(3,:) - P2(1,:);
        pointInImage2(2)*P2(3,:) - P2(2,:)];

    % Compute the 3-D location using the smallest singular value from the
    % singular value decomposition of the matrix A
    [~,~,V]=svd(A);

    X = V(:,end);
    X = X/X(end);

    % Store location
    points3D_2(i,:) = X';

end
points3D_2 = points3D_2(:,1:3);

TF1 = (abs(points3D_1(:,1)))>=50 | (abs(points3D_1(:,2)))>=50 | (abs(points3D_1(:,3)))>=50;
TF2 = (abs(points3D_2(:,1)))>=50 | (abs(points3D_2(:,2)))>=50 | (abs(points3D_2(:,3)))>=50;

Tdelete = TF1 | TF2;

points3D_1(Tdelete,:) = [];
points3D_2(Tdelete,:) = [];
M1_l(Tdelete,:) = [];
M2_l(Tdelete,:) = [];
M1_r(Tdelete,:) = [];
M2_r(Tdelete,:) = [];

% Consistency Matrix M
% Number of Row = Number of Columns = Number of Features

M = zeros(size(M1_l,1)); % generates a square matrix

for i = 1:size(M1_l,1)
    for j= 1:size(M1_l,1)
        if (abs(norm(points3D_2(i, :) - points3D_2(j, :)) - norm(points3D_1(i, :) - points3D_1(j, :))) < inlierThresh )
            M(i,j) = 1;
        end
    end
end

%We now need to find the maximal set which 
edge_max = 0;
edge_count = 0;
curr_max = 0;

for i = 1:size(M1_l,1)
    edge_count = 0;
    for j = 1:size(M1_l,1)
        if  (M(i,j)==1)
            edge_count = edge_count + 1;
        end
    end
    if (edge_count>= edge_max) 
        curr_max = i;
        edge_max = edge_count;
    end
end

% intialize the clique to the max_edge node found above
% intialize a new set containg all the neighbours of the above node
% among the elements of the above set, find the node which is connected to
% most of the other nodes in the above initialized set
% update the cliques with this new node

clique = [curr_max];
% now find all neighbours of the above node
% We need two functions here: Find Potential Additions to the Clique: this
% function will take the current clique as the input, and compute the set
% of nodes that can be added to the clique
% Find the best addition to the Clique: This will take the set of nodes
% that can be added to the clique as an input, and then use it.
 potentialNodes = findPotentialNodes(clique, M);
 i=0;
while(sum(potentialNodes))
    clique = updateClique(potentialNodes, clique, M);
    potentialNodes = findPotentialNodes(clique, M);
    i = i+1;
end

newCloud1 = ones(length(clique), 3);
newCloud2 = ones(length(clique), 3);

newfeatures1 = ones(length(clique), 2);
newfeatures2 = ones(length(clique), 2);

for i=1:length(clique)
    newCloud1(i, :) = points3D_1(clique(i), :);
    newCloud2(i, :) = points3D_2(clique(i), :);
    
    newfeatures1(i, :) = M1_l(clique(i), :);
    newfeatures2(i, :) = M2_l(clique(i), :);
end


%[R, T] = icp(newCloud1',newCloud2');

options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt','MaxFunEvals',1500);
lb = [];
ub = [];
PAR0 = [0;0;0;0;0;0];
PAR = [0;0;0;0;0;0];


[PAR,resnorm,residual,~,output1] = lsqnonlin(@(PAR) minimize(PAR, newfeatures1, newfeatures2, newCloud1, newCloud2, P1),PAR0, lb, ub, options);

TF11 = residual(1:0.5*size(residual,1), 1)>=1.0;
TF12 = residual(1:0.5*size(residual,1), 2)>=1.0;
TF1 = bitor(TF11, TF12);
TF21 = residual(0.5*size(residual,1)+1:size(residual,1), 1)>=1.0;
TF22 = residual(0.5*size(residual,1)+1:size(residual,1), 2)>=1.0;
TF2 = bitor(TF21, TF22);

TF = bitor(TF1,TF2);

newfeatures1(TF,:) = [];
newfeatures2(TF,:) = [];
newCloud1(TF,:) = [];
newCloud2(TF,:) = [];

[PAR,resnorm,residual,~,output1] = lsqnonlin(@(PAR) minimize(PAR, newfeatures1, newfeatures2, newCloud1, newCloud2, P1),PAR, lb, ub, options);


r = PAR(1:3);
t = PAR(4:6);
R = angle2dcm( r(1), r(2), r(3), 'ZXZ' );
T = t;
%F1, F2 -> 2d 
outliers = sum(TF);
cliqueSize = length(clique);
