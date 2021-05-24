%% Main file
addpath('./func/');


%% Parameter
EPSILON = 1;
R = 0.1; 
vehicle_ID = 1;

%% Read files
load('.\data\mat\transition.mat');                                          % Read the transition matrix of road segments (hidden states)
load('.\data\mat\vehicle_trace.mat')                                        % Read the vehicle trace
load('.\data\mat\intersGPS.mat')                                            % Read the discrete points: [ID, x_coordinate, y_coordinate]

for i = 1:1:42
    nr_traces(i) = size(vehicle_trace(i).data, 1);
end
nr_traces = nr_traces';

% spatialcorr2D = obfuscation_matrix(intersGPS, 0, 0.01); 
% obf_matrix = obfuscation_matrix(intersGPS, EPSILON, R); 
% load('.\data\mat\spatialcorr2D.mat');


    SIZE_VEHICLE_TRACE = size(vehicle_trace(vehicle_ID).data, 1); 
    time(vehicle_ID) = vehicle_trace(vehicle_ID).data(SIZE_VEHICLE_TRACE,1) - vehicle_trace(vehicle_ID).data(1,1); 
    %% Generating the obfuscation matrix
    % obf_matrix = obfuscation_matrix(intersGPS, EPSILON, 0.1); 
    load('.\data\mat\obf_matrix.mat');



    %% Generate the obfuscated locations based on the obfuscation matrix
    % vehicle_trace(vehicle_ID).data = vehicle_trace(vehicle_ID).data(6:20, :); 
    SIZE_VEHICLE_TRACE = size(vehicle_trace(vehicle_ID).data, 1); 
    obfusc_index = zeros(SIZE_VEHICLE_TRACE, 1);                                % Approximated locations (index)
    obfusc_x = zeros(SIZE_VEHICLE_TRACE, 1);                                    % Obfuscated locations
    obfusc_y = zeros(SIZE_VEHICLE_TRACE, 1);
    approx_index = zeros(SIZE_VEHICLE_TRACE, 1);                                % Approximated locations (index)
    approx_x = zeros(SIZE_VEHICLE_TRACE, 1);
    approx_y = zeros(SIZE_VEHICLE_TRACE, 1);

    real_x = vehicle_trace(vehicle_ID).data(:,3); 
    real_y = vehicle_trace(vehicle_ID).data(:,4); 
    real_time = vehicle_trace(vehicle_ID).data(:,1);

    for i = 1:1:SIZE_VEHICLE_TRACE
        loc_input = [real_x(i,1), real_y(i,1)];
        approx_index(i, 1) = loc2index(loc_input, intersGPS);  
        approx_x(i, 1) = intersGPS(approx_index(i, 1), 2);
        approx_y(i, 1) = intersGPS(approx_index(i, 1), 3);
        loc_output = obfuscated_loc_gen(approx_index(i, 1), obf_matrix, intersGPS); % Genera  ting the obfuscated location 
        obfusc_x(i, 1) = loc_output(1, 1);
        obfusc_y(i, 1) = loc_output(1, 2);
        obfusc_index(i, 1) = loc2index([obfusc_x(i, 1), approx_y(i, 1)], intersGPS); 
    end


%% Decoding algorithm 
% In this part, we use the Viterbi algorithm to estimate the vehicle's real
% trajectory (represented by "esti_index") given 
esti_index = Viterbi(obfusc_index, real_time, transition, obf_matrix); 
