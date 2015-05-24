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

%% this function is used in the clique selection part of the algorithm
% INPUT:
% clique: the current clique (a vector containing node indices)
% M: the graph, represented as an adjacency matrix

% OUTPUT:
% newSet -> a set of potential nodes that can added to the clique, such
% that is still remains a clique if one of these nodes is added. A vector
% containing the indices of the potential nodes

function newSet = findPotentialNodes(clique, M)

newSet = M(:,clique(1));
if (size(clique)>1)  
    for i=2:length(clique)
        newSet = newSet & M(:,clique(i));
    end
end

for i=1:length(clique)
    newSet(clique(i)) = 0;
end


    