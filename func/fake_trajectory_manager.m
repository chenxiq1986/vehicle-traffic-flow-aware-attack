function fake_traj_list = fake_trajectory_manager(fake_traj_list, approx_index, t, transition, intersGPS, NR_FAKE_TRAJECTORY)
%% This function generates/updates a list of fake trajectories using the genetic algorithm
% Input:    fake_traj_list: the current list of fake trajectories, 
%           vehicle_trace: the real trajectory of the vehicle
%           t: the current time


% In this function, we use a two dimensional matrix: fake_traj_list to
% recrod the list of all fake trajectories

    BOUND = 1; 
    
    

	% Step 1: Reproduction: update each of fake trajectories by adding new locations, which
	% follow the estimated traffic flow information
	fake_traj_list(t) = reproduction(fake_traj_list, t, approx_index, transition);

    % Step 2: Selection: select the trajectories with high utilities     
    fake_traj_list = selection(fake_traj_list, t, approx_index, transition, intersGPS, NR_FAKE_TRAJECTORY); 
end

