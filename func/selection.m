%% Selection: select the trajectories with high utilities 
function [selected_trajectory, fake_traj_list] = selection(selected_trajectory, fake_traj_list, t, approx_index, intersGPS, NR_FAKE_TRAJECTORY)
    %% Step 0: Data pre-processing
    for i = 1:1:size(fake_traj_list(t).location, 1)
        fake_x = intersGPS(fake_traj_list(t).location(i, 3), 2);
        fake_y = intersGPS(fake_traj_list(t).location(i, 3), 3);
        real_x = intersGPS(approx_index(t), 2);
        real_y = intersGPS(approx_index(t), 3);
        
        
        if fake_x == real_x && fake_y == real_y
            fake_traj_list(t).location(i, 4) = 0; 
        else
            if sqrt((fake_x - real_x)^2 + (fake_y - real_y)^2) > 0.2
                fake_traj_list(t).location(i, 4) = 0; 
            else
                fake_traj_list(t).location(i, 4) = fake_traj_list(t).location(i, 2) + sqrt((fake_x - real_x)^2 + (fake_y - real_y)^2); 
                if fake_traj_list(t).location(i, 1) == selected_trajectory(size(selected_trajectory, 2))
                    fake_traj_list(t).location(i, 4) = fake_traj_list(t).location(i, 4) + 1;
                end
            end
        end
    end  
    %% Step 1: Sort the trajectories given the utiltiy values
    fake_traj_list(t).location = sortrows(fake_traj_list(t).location, 4, 'descend'); 
    
    %% Step 2: Filter out the trajectories with lower utility values
    if size(fake_traj_list(t).location, 1) > NR_FAKE_TRAJECTORY
        fake_traj_list(t).location = fake_traj_list(t).location(1:NR_FAKE_TRAJECTORY, :);
    end
    
    %% Step 3: Determine the current location in the selected trajactory
    
    % If the current trajectory cannot find the next location,
    % switch it to a different trajectory
    if fake_traj_list(t).location(1, 1) ~= selected_trajectory(size(selected_trajectory, 2))
        new_loc = switching(fake_traj_list(t).location, selected_trajectory(size(selected_trajectory, 2))); 
        selected_trajectory = [selected_trajectory new_loc]; 
    end
    
    selected_trajectory = [selected_trajectory, fake_traj_list(t).location(1, 3)]; 
end

