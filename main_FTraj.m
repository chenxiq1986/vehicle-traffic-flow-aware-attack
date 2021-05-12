%% Main file
addpath('./func/');


%% Parameter
EPSILON = 1;
R = 0.01; 
vehicle_ID = 2;
NR_FAKE_TRAJECTORY = 100; 

%% Read files
load('.\data\mat\transition.mat');                                          % Read the transition matrix of road segments (hidden states)
load('.\data\mat\vehicle_trace.mat')                                        % Read the vehicle trace
load('.\data\mat\intersGPS.mat')                                            % Read the discrete points: [ID, x_coordinate, y_coordinate]
MATRIX_SIZE = size(transition(1).transition_matrix, 2); 

%% Simulation 

tic
for NR_FAKE_TRAJECTORY = 1000:100:1000
    NR_FAKE_TRAJECTORY
% Initialization 
SIZE_VEHICLE_TRACE = size(vehicle_trace(vehicle_ID).data, 1); 

% SIZE_VEHICLE_TRACE = 10; 

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
end

% Each node is a triple [previous location, current location, utility]

fake_traj_list(1) = struct('location', [-1, 0, approx_index(1, 1), 0]);            % % Fake trajectory list is initialized by empty

% 
transition_ave = sparse(MATRIX_SIZE, MATRIX_SIZE); 
for i = 1:1:size(transition, 2)
	transition_ave = transition_ave + transition(i).transition_matrix;
end

for t = 2:1:SIZE_VEHICLE_TRACE                                              % Build the table for t = 2:1:TRACE_SIZE
	t1 = real_time(t);
	% transition_ave = transition_matrix(t1+1).transition_matrix;
    fake_traj_list = fake_trajectory_manager(fake_traj_list, approx_index, t, transition_ave, intersGPS, NR_FAKE_TRAJECTORY); 
end

fake_traj_list_matrix = fake_traj_list2matrix(fake_traj_list); 




%% The result figures

EIE_fake = 0;

tic 
for i = 1:1:NR_FAKE_TRAJECTORY
    fake_x = zeros(SIZE_VEHICLE_TRACE, 1);
    fake_y = zeros(SIZE_VEHICLE_TRACE, 1);
    for t = 1:1:SIZE_VEHICLE_TRACE
        fake_x(t, 1) = intersGPS(fake_traj_list_matrix(i, t), 2);
        fake_y(t, 1) = intersGPS(fake_traj_list_matrix(i, t), 3);
        EIE_fake = EIE_fake + sqrt((fake_x(t, 1) - approx_x(t, 1))^2 + (fake_y(t, 1) - approx_y(t, 1))^2); 
    end
    plot(fake_y, fake_x, '-x'); 
    hold on; 
end
toc 

EIE_fake_(NR_FAKE_TRAJECTORY/100) = EIE_fake/(NR_FAKE_TRAJECTORY);

plot(approx_y, approx_x, '-s');
hold on;
end
toc

