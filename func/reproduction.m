% This function is used to reproduce the locations in the current round
% given the loction in the last round

function fake_traj_list_curr = reproduction(fake_traj_list, t, approx_index, transition)
	current_location = [];
    for i = 1:1:size(fake_traj_list(t-1).location, 1)
        last_loc = fake_traj_list(t-1).location(i, 3); 
        last_uti = fake_traj_list(t-1).location(i, 4);     
        current_location_temp = find(transition(last_loc, :) ~= 0); 
        current_location_temp(current_location_temp == approx_index(t)) = [];
        current_location_temp = current_location_temp';
        last_loc = ones(size(current_location_temp))*last_loc; 
        last_uti = ones(size(current_location_temp))*last_uti; 
        uti = zeros(size(current_location_temp));
        current_location = [current_location; [last_loc, last_uti, current_location_temp, uti]]; 
    end
    fake_traj_list_curr = struct('location', current_location);
end

