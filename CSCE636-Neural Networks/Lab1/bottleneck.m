function [Emin, Emin_index] = bottleneck(beta, alpha, eta_z, eta_o, training_cycle, Fv, linear, color, im_file_path_1, im_file_path_2, hidden_layer_weight_record, output_layer_weight_record, training_error_record, validation_error_record)
                 
%initialize image
if color==1
    [Image1,ColorMap1] = imread(im_file_path_1,'tif'); % color image
    [Image2,ColorMap2] = imread(im_file_path_2,'tif'); % color image
else
    Image1 = imread(im_file_path_1,'tif'); % gray image
    Image2 = imread(im_file_path_2,'tif'); % gray image
end
NormalizedImage1 = double(Image1) .* (2/256) - ones(512,512);
NormalizedImage2 = double(Image2) .* (2/256) - ones(512,512);

%initialize learning parameters
% beta=; %0.2, 1, 5
% alpha=; %0, 0.5
% eta_z=0.0001;
% eta_o=0.0001;
% training_cycle = 2000;
% Fv=1; %validation frequency
training_set_size = 4096;

%initialize weights Wz, Wo
%W = round(rand(1,65)).*2-ones(1,65);
%Wz = W;
%for i=2:16
%    Wz = [Wz;W];
%end
%Wz1 = zeros(16,65); % 16 x 65

%W = round(rand(1,17)).*2-ones(1,17);
%Wo = W;
%for i=2:64
%    Wo = [Wo;W];
%end
%Wo1 = zeros(64,17); % 64 x 17

%load weights
Emin_index=1986;
sd_id_z = hdfsd('start',strcat('E:\neural network\Lab1\results\Wz0.2_0.hdf'),'read');
sds_id_z = hdfsd('select',sd_id_z,Emin_index-1);
[ds_name, ds_ndims, ds_dims, ds_type, ds_atts, stat] = hdfsd('getinfo',sds_id_z);
ds_start = zeros(1,ds_ndims);
ds_stride = []; 
ds_edges = ds_dims; 
[Wz, status] = hdfsd('readdata',sds_id_z,ds_start,ds_stride,ds_edges);
stat = hdfsd('end',sd_id_z);
Wz1=zeros(16,65);

sd_id_o = hdfsd('start',strcat('E:\neural network\Lab1\results\Wo0.2_0.hdf'),'read');
sds_id_o = hdfsd('select',sd_id_o,Emin_index-1);
[ds_name, ds_ndims, ds_dims, ds_type, ds_atts, stat] = hdfsd('getinfo',sds_id_o);
ds_start = zeros(1,ds_ndims);
ds_stride = []; 
ds_edges = ds_dims; 
[Wo, status] = hdfsd('readdata',sds_id_o,ds_start,ds_stride,ds_edges);
stat = hdfsd('end',sd_id_o);
Wo1=zeros(64,17);

%initialize error storage
Et=zeros(1,training_cycle);
Ev=zeros(1,round(training_cycle/Fv));
Emin=1000;
Emin_index=training_cycle;

%open weight and error files
sd_id_z = hdfsd('start',hidden_layer_weight_record,'DFACC_CREATE');
sd_id_o = hdfsd('start',output_layer_weight_record,'DFACC_CREATE');
sd_id_t = hdfsd('start',training_error_record,'DFACC_CREATE');
sd_id_v = hdfsd('start',validation_error_record,'DFACC_CREATE');

for n=1:training_cycle
    
    %===========================training===========================
    
    perm=randperm(training_set_size); % random permutation
    E=0;
    for t=1:training_set_size
        %initialize input vector (X)
        r = floor((perm(t) - 1)/64) * 8;
        c = mod(perm(t)-1,64) * 8;
        T = NormalizedImage1(r+1:r+8,c+1:c+8);
        X = T(:); % 64 x 1
        X1 = [1;X]; % 65 x 1
        
        %[forward pass]
        % hidden neurons
        Vz = Wz * X1; % 16 x 65 * 65 x 1
        if linear==1
            Z = purelin(Vz);
        else
            Z = tansig(beta .* Vz); % Z = tanh(beta .* Vz); % 16 x 1
        end
        Z1 = [1;Z];
        
        % output neurons 
        Y = purelin(Wo * Z1); % 64 x 17 * 17 x 1 
        
        %[backward pass]
        % output neurons
        T = eta_o .* ((X-Y) .* dpurelin(Y)) * Z1';
        Wo1 = alpha .* Wo1 + T; % add momentum term
        Wo = Wo + Wo1;
        
        % hidden neurons
        if linear==1
            W = eta_z .* dpurelin(Vz) .* (Wo(:,2:17)' * ((X-Y) .* dpurelin(Y))) * X1'; % 16 x 65
        else
            W = eta_z .* dtansig(beta .* Vz, Z) .* (Wo(:,2:17)' * ((X-Y) .* dpurelin(Y))) * X1'; % 16 x 65
        end
        Wz1 = alpha .* Wz1 + W; % add momentum term
        Wz = Wz + Wz1; 
        
        %[error energy]
        E = E + (ones(1,64) * ((X-Y).^2)) ./ 2;
    end
    %[error of this epoch]
    Et(1,n)=E ./ training_set_size;
    
    %[write weights to files]
    % create data set / write / close
    sds_id_z = hdfsd('create',sd_id_z,strcat(hidden_layer_weight_record,int2str(n-1)),'double',2,fliplr(size(Wz)));
    stat = hdfsd('writedata',sds_id_z,zeros(1:ndims(Wz)),[],fliplr(size(Wz)),Wz);
    stat = hdfsd('endaccess',sds_id_z);
    % create data set / write / close
    sds_id_o = hdfsd('create',sd_id_o,strcat(output_layer_weight_record,int2str(n-1)),'double',2,fliplr(size(Wo)));
    stat = hdfsd('writedata',sds_id_o,zeros(1:ndims(Wo)),[],fliplr(size(Wo)),Wo);
    stat = hdfsd('endaccess',sds_id_o);

    %===========================validation===========================
    if mod(n, Fv)==0
        E = 0;
        for pixel_window_row=0:63
            for pixel_window_col1=0:63
                %initialize input vector (X)
                r = pixel_window_row * 8;
                c = pixel_window_col1 * 8;
                T = NormalizedImage2(r+1:r+8,c+1:c+8);
                X = T(:); % 64 x 1
                X1 = [1;X]; % 65 x 1
                    
                %[forward pass]
                % hidden neurons
                Vz = Wz * X1; % 16 x 65 * 65 x 1
                if linear==1
                    Z = purelin(Vz);
                else
                    Z = tansig(beta .* Vz); % 16 x 1
                end                
                Z1 = [1;Z];
        
                % output neurons 
                Y = purelin(Wo * Z1); % 64 x 17 * 17 x 1
                    
                %[error function]
                E = E + (ones(1,64) * ((X-Y).^2)) ./ 2;
            end    
        end
        Ev(1,n/Fv)=E ./ training_set_size;
        if Emin > Ev(1,n/Fv)
            Emin = Ev(1,n/Fv);
            Emin_index = n;
        end        
    end
end
stat = hdfsd('end',sd_id_z);
stat = hdfsd('end',sd_id_o);

%[write error value to files]
% create data set / write / close
sds_id_t = hdfsd('create',sd_id_t,training_error_record,'double',2,fliplr(size(Et)));
stat = hdfsd('writedata',sds_id_t,zeros(1:ndims(Et)),[],fliplr(size(Et)),Et);
stat = hdfsd('endaccess',sds_id_t);
stat = hdfsd('end',sd_id_t);
% create data set / write / close
sds_id_v = hdfsd('create',sd_id_v,validation_error_record,'double',2,fliplr(size(Ev)));
stat = hdfsd('writedata',sds_id_v,zeros(1:ndims(Ev)),[],fliplr(size(Ev)),Ev);
stat = hdfsd('endaccess',sds_id_v);
stat = hdfsd('end',sd_id_v);

%[echo the minimum error and the epoch at which the minimum error occurs]
%Emin
%Emin_index