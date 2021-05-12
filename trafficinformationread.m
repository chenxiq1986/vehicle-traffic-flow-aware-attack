%% File read
addpath('./func/');

% intersGPS = dlmread('.\data\intersGPS.txt');                                % Read the discrete points: [ID, x_coordinate, y_coordinate]


%% Read the transition matrix of road segments (hidden states)
% fid_transMatrix = fopen('.\data\transMatrix_second');
% NR_ROAD_SEG = 26036; 
% for t = 1:1:1800
%     transition(t) = struct('time', t-1, ...
%                         'transition_matrix', sparse(NR_ROAD_SEG, NR_ROAD_SEG)); 
% end
% index = 1;
% tline = fgetl(fid_transMatrix);
% while ischar(tline)
%     seg1 = sscanf(tline, '[12:00-12:30]%d')+1;
%     title = strcat('.\data\transMatrix_folder\', int2str(seg1-1)); 
%     fileID = fopen(title,'w');
%     fprintf(fileID,tline);
%     fclose(fileID);
%     clear title; 
%     
%     sub_tline = extractAfter(tline, ';');
%     indx = strfind(sub_tline, '|'); 
%     indx = [0 indx];
%     for i = 1:1:size(indx, 2)-1
%         subsub_tline = sub_tline(indx(i)+1: indx(i+1)-1);
%         time = sscanf(subsub_tline, '%dth_second');
%         indxx = strfind(subsub_tline, ':');
%         subsub_tline = subsub_tline(indxx+1:size(subsub_tline,2));
%         while ischar(subsub_tline)
%             data = sscanf(subsub_tline, '%d=%f');
%             seg2 = data(1)+1;
%             prob = data(2);
%             transition(time+1).time = time;
%             transition(time+1).transition_matrix(seg1, seg2) = prob; 
%             indxx = strfind(subsub_tline, ';');
%             % [time seg2 prob]
%             if size(indxx, 1) == 0
%                 break; 
%             else 
%                 subsub_tline = subsub_tline(indxx+1:size(subsub_tline,2));
%             end
%             
%         end 
%     end
%     
%     clear data;
%     clear indx; 
%     
%     tline = fgetl(fid_transMatrix);
%     index = index + 1;
%     index
% end
% 
% a = 0; 

% plot(vehicle_trace(vehicle_ID).data(:,3), vehicle_trace(vehicle_ID).data(:,4), 'o');
% hold on;
% obfuscation = zeros(size(vehicle_trace(vehicle_ID).data, 1), 2);
% for i = 1:1:size(vehicle_trace(vehicle_ID).data, 1)
%     loc_input = [vehicle_trace(vehicle_ID).data(i,3), vehicle_trace(vehicle_ID).data(i,4)];
%     [loc_output, mark_index] = obfuscation_laplace(loc_input, intersGPS, EPSILON, R);
%     obfuscation(i, :) = loc_output;
% end

%% Read the taxi trace
vehicle_ID = 1;
fid_YueBN14X7 = fopen('.\data\YueBH4809_bus_6');
index = 1;
tline = fgetl(fid_YueBN14X7);
while ischar(tline)
    data = sscanf(tline, '%f,%f,%f,%f;');
    data = reshape(data, 4, size(data, 1)/4);
    data = data';
    vehicle_trace(index) = struct('data', data); 
    clear data; 
    tline = fgetl(fid_YueBN14X7);
    index = index + 1;
end
real_x = vehicle_trace(vehicle_ID).data(:,3); 
real_y = vehicle_trace(vehicle_ID).data(:,4); 
plot(real_x, real_y, 'o');
hold on;
