function transition_ave = transition_accum(transition, MATRIX_SIZE)
    transition_ave = sparse(eye(MATRIX_SIZE));
    for i = 1:1:size(transition, 2)
        transition_ave = transition_ave * transition(i).transition_matrix;
    end
end

