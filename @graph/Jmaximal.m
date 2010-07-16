function [ M ] = Jmaximal( g )
%JMAXIMAL Get the maximal independent sets using Java library JGraphT
%   Calculates all the maximal independent sets of a graph using the
%   BronKerbosch algorithm found in the JGraphT library

if nv(g) == 0
    error('Jmaximal: Graph is empty');
end

gc = graph(g);
%copy(gc, g);
complement(gc);

M = org.matjgraph.MaximalCliques.getMaximalCliques( matrix(gc) );

free(gc);
end

