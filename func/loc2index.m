function index = loc2index(loc_input, intersGPS)
%% This function is 
    distance_flag = 999999;
    index_flag = 0; 
    for i = 1:1:size(intersGPS, 1)
        distance = sqrt((loc_input(1,1) - intersGPS(i, 2))^2 + (loc_input(1,2) - intersGPS(i, 3))^2); 
        if distance < distance_flag
            index_flag = i; 
            distance_flag = distance; 
        end
    end
    
    index = index_flag; 
end

