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
% potentialNodes: list of nodes that can be added to the clique, so that it
% still remains a clique when one such node is added, a vector of node
% indices
% M: the graph, represented as an adjacency matrix

%OUTPUT:
% cl -> the new clique, after adding one of the nodes in the potentialNodes

function cl = updateClique(potentialNodes, clique, M)

maxNumMatches = 0;
curr_max = 0;
for i = 1:length(potentialNodes)
    if(potentialNodes(i)==1)
        numMatches = 0;
        for j = 1:length(potentialNodes)
            if (potentialNodes(j) & M(i,j))
                numMatches = numMatches + 1;
            end
        end
        if (numMatches>=maxNumMatches)
            curr_max = i;
            maxNumMatches = numMatches;
        end
    end
end

if (maxNumMatches~=0)
    clique(length(clique)+1) = curr_max;
end

cl = clique;

    