dir = '';
fid = fopen(strcat(dir,'exp.txt'),'w');
%[Emin, Emin_index] = bottleneck(beta, alpha, eta_z, eta_o, training_cycle, Fv, linear,
%                 color, im_file_path_1, im_file_path_2,
%                 hidden_layer_weight_record, output_layer_weight_record,
%                 training_error_record, validation_error_record)

% common parameters
training_cycle = 2000;
Fv = 1;
color = 1;
im_file_path_1=strcat(dir,'1.tif');
im_file_path_2=strcat(dir,'2.tif');
eta_z = 0.0001;
eta_o = 0.0001;

% exp. begins
alpha = 0;

beta = 0.2;
index = '0.2_0_0.0001_continue';
linear = 0;
[Emin, Emin_index] = bottleneck(beta, alpha, eta_z, eta_o, training_cycle, Fv, linear, color, im_file_path_1, im_file_path_2, strcat(dir,'Wz',index,'.hdf'), strcat(dir,'Wo',index,'.hdf'), strcat('Et',index,'.hdf'), strcat('Ev',index,'.hdf'));
fprintf(fid,'%s %3.4f %4d\n', index, Emin, Emin_index);

% index = 'linear_0';
% linear = 1;
% [Emin, Emin_index] = bottleneck(beta, alpha, eta_z, eta_o, training_cycle, Fv, linear, color, im_file_path_1, im_file_path_2, strcat(dir,'Wz',index,'.hdf'), strcat(dir,'Wo',index,'.hdf'), strcat('Et',index,'.hdf'), strcat('Ev',index,'.hdf'));
% fprintf(fid,'%s %3.4f %4d\n', index, Emin, Emin_index);

fclose(fid);