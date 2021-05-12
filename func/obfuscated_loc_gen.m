function loc_output = obfuscated_loc_gen(index_input, obf_matrix, intersGPS)
%% This function is used to generate obfucated location given the obfuscation matrix "obf_matrix"
    prob_distance_cumsum = cumsum(obf_matrix(index_input, :)); 
    
	seed = rand();
    obfuscated_index = 0;
    for i = 1:1:size(intersGPS, 1)-1
        if prob_distance_cumsum(1, i) <= seed && seed < prob_distance_cumsum(1, i+1)
            obfuscated_index = i+1;
        end
    end
    
    loc_output = [intersGPS(obfuscated_index, 2), intersGPS(obfuscated_index, 3)];
    
end

