function [ M ] = BKmaximal_M( int_matrix )
%BKMAXIMAL Find maximal stable set using Bron-Kerbosch algorithm
%   Given a graph's interference matrix g, calculates the matrix of maximal
%   independent sets using the Bron-Kerbosch algorithm in a recursive
%   manner
%
%   Berk Birand (c) 2009
%   http://www.ee.columbia.edu/~berk/

no_vertices = size(int_matrix,2);

% output for the maximal independent sets
M = [];

P = [];
S = [];
T = 1:no_vertices;

findIS( P, S, T);

    % Recursive function to branch on 
    function findIS(P, S, T)
        
        % Check if we are done
        if check_end(S,T)
            
            % Loop through the edges
            for i=1:size(T,2)
                % pick x as candidate
                x = T(i);
                P = [P x];
                S_new = remove_nbrs(S, x,0 );
                T_new = remove_nbrs(T, x, 1);
                
                % if S(j) and T(j) are empty, we got max'l  IS
                if (isempty(S_new) && isempty(T_new))
                    new_IS = convert_set_to_bin(P, no_vertices);
                    M = [M new_IS'];
                    
                    % go to step 5
                elseif ( ~isempty(S_new) && isempty(T_new))
                    % go to step 5
                    
                else
                    % recursive call
                    findIS(P, S_new, T_new);
                end

                
                % remove x from P
                x_ind = find(P == x);
                P(x_ind) = [];

                % add x to S
                S = [S x];
                

            end  % for i=1:size(T,2)
        end % if check_end(S,T)
                
    end % findIS


    % Removes the neighbors of x from inp, and returns it
    % Sinp: is the set where the neighorhood will be removed
    % x :index of node whose neighborhood will be removed
    % removeX : if 1, x is also removed, from Sinp
    function [ Sout ] = remove_nbrs( Sinp, x, removeX)
        
        if nargin ~= 3
            error('Need all three arguments');
        end

        int_line = int_matrix(x, :); % proper line in the interference matrix
        nbrs = find(int_line == 1);  % locate where int_line = 1
        
        % if we also need to remove the node itself
        if (removeX == 1)
            nbrs = [nbrs x];
        end
        
        mems = ismember(Sinp, nbrs);  % find locations where there is a match
        no_ind = find(mems ~= 1);     % find indices of locations where there is not match
        Sout = Sinp(no_ind);              % return those indices
    end % remove_nbrs


    % Converts an array of decimals to 0-1 array
    % [2 4] => [ 0 1 0 1 ]
    % The size of the output array is exactly len
    function [Sout] =  convert_set_to_bin(Sin, len)
        
        Sout = zeros(1,len);
        Sout(Sin) = 1;
        
    end %convert_set_to_bin

    % check whether we can end the execution
    function ret = check_end(S, T)
        ret = 1;
        for k=1:size(S,2)
            
            %TODO Fix this for not using g to get the neighborhood
            E_k = neighbors(g,S(k)); %neighborhood of k
            
            if ( isempty(intersect(E_k, T))  )
                ret = 0;
                break; %there exists such a node, so no need to continue
                
            end % if ( isempty(intersect(E_k, T))  )
            
        end % for k=1:size(S,2)

    end %ret


end %BKmaximal

