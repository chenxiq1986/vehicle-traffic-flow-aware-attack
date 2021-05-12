%% Location obfuscation via Laplace distribution
% This function is used to generate Laplacian noise to a given real
% location 
function loc_output = obfuscation_laplace(loc_input, intersGPS, EPSILON, R)
    mark_index = zeros(size(intersGPS, 1), 1);
    distance = zeros(size(intersGPS, 1), 1);
    prob_distance = zeros(size(intersGPS, 1), 1);
    
    for i = 1:1:size(intersGPS, 1)
        distance(i, 1) = sqrt((loc_input(1,1) - intersGPS(i, 2))^2 + (loc_input(1,2) - intersGPS(i, 3))^2); 
        if distance(i, 1) < R
            mark_index(i, 1) = 1;
        end
    end
    
    prob_distance = exp(-EPSILON*distance) .* mark_index; 
    prob_distance = prob_distance/sum(prob_distance); 
    prob_distance_cumsum = cumsum(prob_distance); 
    
    seed = rand();
    obfuscated_index = 0;
    for i = 1:1:size(intersGPS, 1)-1
        if prob_distance_cumsum(i, 1) <= seed && seed < prob_distance_cumsum(i+1, 1)
            obfuscated_index = i+1;
        end
    end
    
    loc_output = [intersGPS(obfuscated_index, 2), intersGPS(obfuscated_index, 3)];
    
%% Show the cloaking area of the obfuscated location    
%     discrete_points_x = nonzeros(intersGPS(:, 2).*mark_index);
%     discrete_points_y = nonzeros(intersGPS(:, 3).*mark_index);
%     plot(intersGPS(:, 2), intersGPS(:, 3), 's');
%     hold on;
%     plot(discrete_points_x, discrete_points_y, 'o');
    
end

