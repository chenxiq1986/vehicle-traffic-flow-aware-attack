%% This function is used to switch the current trajectory to a different trajectory if needed

function new_loc = switching(fake_traj_list, last_loc)
load('.\data\mat\intersGPS.mat')                                            % Read the discrete points: [ID, x_coordinate, y_coordinate]
%% Parameters
    alpha_fitness = 1.0;
    alpha_smooth = 100.0; 
    NR_FAKE_TRAJECTORY = size(fake_traj_list, 1); 
    
    weights = zeros(NR_FAKE_TRAJECTORY, 1); 
    for i = 1:1:NR_FAKE_TRAJECTORY
        last_loc_x = intersGPS(last_loc, 2);
        last_loc_y = intersGPS(last_loc, 3);
        curr_loc_x = intersGPS(fake_traj_list(i, 3), 2);
        curr_loc_y = intersGPS(fake_traj_list(i, 3), 3);
        weights(i, 1) = alpha_fitness * fake_traj_list(i, 4) + alpha_smooth * sqrt((last_loc_x - curr_loc_x)^2 + (last_loc_y - curr_loc_y)^2); 
    end
    
    [opt_uti, new_loc] = max(weights); 

end

