function esti_index = Viterbi(approx_index, real_time, transition_matrix, obf_matrix)
%% The Viterbi algorithm to find the hidden states with the maximum likelihood
    TRACE_SIZE = size(approx_index, 1);
    MATRIX_SIZE = size(transition_matrix(1).transition_matrix, 2); 

    v = -inf*ones(TRACE_SIZE, MATRIX_SIZE);                                 % Initialize v matrix by -inf
    v2 = -inf*ones(TRACE_SIZE, MATRIX_SIZE);                                % Initialize v2 matrix by -inf (for debug)
    v_back = zeros(TRACE_SIZE, MATRIX_SIZE);                                % v_back is used to track the last index in the trace
    v_back2 = zeros(TRACE_SIZE, MATRIX_SIZE);                               % v_back2 is used to track the index of second largest element in the last round 
      
    for i = 1:1:MATRIX_SIZE                                                 % Initilization of v(1, :)
        if obf_matrix(i, approx_index(1, 1)) ~= 0
            v(1, i) = log(obf_matrix(i, approx_index(1, 1))); 
        end
    end
    real_time = mod(real_time, 1800);
    
    transition_ave = sparse(MATRIX_SIZE, MATRIX_SIZE); 
    for i = 1:1:size(transition_matrix, 2)
        transition_ave = transition_ave + transition_matrix(i).transition_matrix;
    end
    
    for t = 2:1:TRACE_SIZE                                                  % Build the table for t = 2:1:TRACE_SIZE
        t1 = real_time(t);
        % transition_ave = transition_matrix(t1+1).transition_matrix;
        
        
        index_set_j = find(obf_matrix(:, approx_index(t, 1)));              % 
        for j = 1:1:size(index_set_j, 1)
            inst_v = -inf*ones(1, MATRIX_SIZE); 
            
            index_set_l = find(transition_ave(:, index_set_j(j))); 
            
            for l = 1:1:size(index_set_l, 1)
                if transition_ave(index_set_l(l), index_set_j(j)) * obf_matrix(index_set_j(j), approx_index(t, 1)) ~= 0
                    inst_v(1, index_set_l(l)) = v(t-1, index_set_l(l)) + log(transition_ave(index_set_l(l), index_set_j(j))) + log(obf_matrix(index_set_j(j), approx_index(t, 1))); 
                end
            end
            [v(t, index_set_j(j)), v_back(t, index_set_j(j))]= max(inst_v); 
            
            inst_v(1, v_back(t, index_set_j(j))) = -inf;
            [v2(t, index_set_j(j)), v_back2(t, index_set_j(j))]= max(inst_v);
            
            
            clear index_set_l;
        end
        clear index_set_j; 
    end
    
    % Prevent loop
    for t =  TRACE_SIZE:-1:2
        for i = 1:1:MATRIX_SIZE
            if v_back(t, i) ~= 0
                if v_back(t-1,  v_back(t, i)) == i
                    v_back(t-1,  v_back(t, i)) = v_back2(t-1,  v_back(t, i)); 
                end
            end
        end
    end
    
    % Back track
    trace = zeros(TRACE_SIZE, 1);
    [v_max, trace(TRACE_SIZE, 1)] = max(v(TRACE_SIZE, :)); 
    for t = TRACE_SIZE:-1:2
        trace(t-1, 1) = v_back(t, trace(t, 1)); 
    end
    esti_index = trace; 
end

