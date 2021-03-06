%% Given the trajectory pool, this function is used to find the selected fake trajectory convert the fake trajectory list to a matrix

function fake_traj_list_matrix = fake_traj_list2matrix(fake_traj_list)
    SIZE_VEHICLE_TRACE = size(fake_traj_list, 2); 
    NR_FAKE_TRAJECTORY = size(fake_traj_list(SIZE_VEHICLE_TRACE).location, 1); 
      
    fake_traj_list_matrix = zeros(NR_FAKE_TRAJECTORY, SIZE_VEHICLE_TRACE); 
    fake_traj_uti_matrix = zeros(NR_FAKE_TRAJECTORY, SIZE_VEHICLE_TRACE); 
    
    for i = 1:1:NR_FAKE_TRAJECTORY
        fake_traj_list_matrix(i, SIZE_VEHICLE_TRACE) = fake_traj_list(SIZE_VEHICLE_TRACE).location(i, 3); 
        fake_traj_uti_matrix(i, SIZE_VEHICLE_TRACE) = fake_traj_list(SIZE_VEHICLE_TRACE).location(i, 4);
        fake_traj_list_matrix(i, SIZE_VEHICLE_TRACE-1) = fake_traj_list(SIZE_VEHICLE_TRACE).location(i, 1); 
        fake_traj_uti_matrix(i, SIZE_VEHICLE_TRACE-1) = fake_traj_list(SIZE_VEHICLE_TRACE).location(i, 2);
    end
    
    for i = 1:1:NR_FAKE_TRAJECTORY
        for j = SIZE_VEHICLE_TRACE-1:-1:2
            idx1 = find(fake_traj_list(j).location(:, 3) == fake_traj_list_matrix(i, j)); 
            idx2 = find(fake_traj_list(j).location(:, 4) == fake_traj_uti_matrix(i, j)); 
            idx = intersect(idx1, idx2); 
            fake_traj_list_matrix(i, j-1) = fake_traj_list(j).location(idx, 1); 
            fake_traj_uti_matrix(i, j-1) = fake_traj_list(j).location(idx, 2); 
        end
    end
    
end

