%% Transition matrix test
load('.\data\mat\transition.mat');                                          % Read the transition matrix of road segments (hidden states)
load('.\data\mat\intersGPS.mat')                                            % Read the discrete points: [ID, x_coordinate, y_coordinate]

SIZE_MATRIX = size(transition(1).transition_matrix, 1); 

transition_matrix_ave = sparse(SIZE_MATRIX, SIZE_MATRIX);

for i = 1:1:size(transition, 2)
    transition_matrix_ave = transition_matrix_ave + transition(i).transition_matrix;
end
transition_matrix_ave = transition_matrix_ave/size(transition, 2); 

[row, col] = find(transition_matrix_ave); 

for i = 1:1:size(row, 1)
    i
    if row ~= col
        x = [intersGPS(row(i), 2),intersGPS(col(i), 2)];
        y = [intersGPS(row(i), 3),intersGPS(col(i), 3)]; 
        plot(x, y); 
        hold on; 
    end
end
