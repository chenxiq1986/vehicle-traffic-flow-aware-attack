function obf_matrix = obfuscation_matrix(intersGPS, EPSILON, R)
%% This function is used to generate the obfuscation matrix
% Laplacian distribution

    NR_LOC = size(intersGPS, 1); 

    mark_index = zeros(NR_LOC, NR_LOC);
    distance = zeros(NR_LOC, NR_LOC);
    obf_matrix = zeros(NR_LOC, NR_LOC);

    for i = 1:1:NR_LOC
        % i
        for j = 1:1:NR_LOC
            distance(i, j) = sqrt((intersGPS(i, 2) - intersGPS(j, 2))^2 + (intersGPS(i, 3) - intersGPS(j, 3))^2); 
            if distance(i, j) < R
                mark_index(i, j) = 1;
            end        
        end
    end
    
    obf_matrix = exp(-EPSILON*distance) .* mark_index;  
    for i = 1:1:NR_LOC
        % i
        sum_inst = sum(obf_matrix(i,:)); 
        obf_matrix(i,:) = obf_matrix(i,:)/sum_inst; 
    end
    obf_matrix = sparse(obf_matrix); 
end

