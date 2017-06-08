%initialize image;
[Image1,ColorMap1] = imread('D:\My Documents\neural network\1.gif','gif');
%Image1 = imread('D:\My Documents\neural network\1g.gif','gif');
NormalizedImage1 = double(Image1) .* (2/256) - ones(512,512);
[Image2,ColorMap2] = imread('D:\My Documents\neural network\2.gif','gif');
%Image2 = imread('D:\My Documents\neural network\2g.gif','gif');
NormalizedImage2 = double(Image2) .* (2/256) - ones(512,512);

%initialize learning parameters
beta=5; %0.2, 1, 5
alpha=0; %0, 0.5
eta_z=0.01;
eta_o=0.1;
training_cycle = 3000;
training_size = 4096;
Fv=5; %validation frequency

%load weights
sd_id_z = hdfsd('start','Wz2.hdf','read');
sds_id_z = hdfsd('select',sd_id_z,2999);
[ds_name, ds_ndims, ds_dims, ds_type, ds_atts, stat] = hdfsd('getinfo',sds_id_z);
ds_start = zeros(1,ds_ndims);
ds_stride = []; 
ds_edges = ds_dims; 
[Wz, status] = hdfsd('readdata',sds_id_z,ds_start,ds_stride,ds_edges);
stat = hdfsd('end',sd_id_z);

sd_id_o = hdfsd('start','Wo2.hdf','read');
sds_id_o = hdfsd('select',sd_id_o,2999);
[ds_name, ds_ndims, ds_dims, ds_type, ds_atts, stat] = hdfsd('getinfo',sds_id_o);
ds_start = zeros(1,ds_ndims);
ds_stride = []; 
ds_edges = ds_dims; 
[Wo, status] = hdfsd('readdata',sds_id_o,ds_start,ds_stride,ds_edges);
stat = hdfsd('end',sd_id_o);

Wz1 = zeros(16,65); % 16 x 65
Wo1 = zeros(64,17); % 64 x 17

%initialize error
Et=zeros(1,training_cycle);
Ev=zeros(1,round(training_cycle/Fv));
Emin=1000;
Emin_index=training_cycle;

%write weight file
sd_id_z = hdfsd('start','Wz2.hdf','DFACC_CREATE');
sd_id_o = hdfsd('start','Wo2.hdf','DFACC_CREATE');
sd_id_t = hdfsd('start','Et2.hdf','DFACC_CREATE');
sd_id_v = hdfsd('start','Ev2.hdf','DFACC_CREATE');

for n=1:training_cycle
    perm=randperm(training_size);
    E=0;
    for t=1:training_size
        %initialize input vector (X)
        r = floor((perm(t) - 1)/64) * 8;
        c = mod(perm(t)-1,64) * 8;
        T = NormalizedImage1(r+1:r+8,c+1:c+8);
        X = T(:); % 64 x 1
        X1 = [1;X]; % 65 x 1
        
        %[forward pass]
        % hidden neurons
        Vz = Wz * X1; % 16 x 65 * 65 x 1
        Z = tanh(beta .* Vz); % 16 x 1
        Z1 = [1;Z];
        
        % output neurons 
        Y = Wo * Z1; % 64 x 17 * 17 x 1  %Vo = Wo * Z; Y = Vo;
        
        %[backward pass]
        % output neurons
        T = eta_o .* ((X-Y) * Z1');
        Wo = Wo + alpha .* Wo1 + T;
        Wo1 = T;
        
        % hidden neurons
        W = (eta_z .* beta .* (ones(17,1) - Z1) .* (ones(17,1) + Z1) .* ((X-Y)' * Wo)') * X'; % 17 x 64
        T = [W(2:17,:) zeros(16,1)];
        Wz = Wz + alpha .* Wz1 + T; % 16 x 65
        Wz1 = T;
        
        %[error function]
        E = E + (ones(1,64) * ((X-Y).^2)) ./ 2;
    end
    %[error function]
    Et(1,n)=E ./ training_size;
    
    %[write weights]
    % create data set / write / close
    sds_id_z = hdfsd('create',sd_id_z,strcat('Wz',int2str(n-1)),'double',2,fliplr(size(Wz)));
    stat = hdfsd('writedata',sds_id_z,zeros(1:ndims(Wz)),[],fliplr(size(Wz)),Wz);
    stat = hdfsd('endaccess',sds_id_z);
    % create data set / write / close
    sds_id_o = hdfsd('create',sd_id_o,strcat('Wo',int2str(n-1)),'double',2,fliplr(size(Wo)));
    stat = hdfsd('writedata',sds_id_o,zeros(1:ndims(Wo)),[],fliplr(size(Wo)),Wo);
    stat = hdfsd('endaccess',sds_id_o);

    %validation===========================
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
                Z = tanh(beta .* Vz); % 16 x 1
                Z1 = [1;Z];
        
                % output neurons 
                Y = Wo * Z1; % 64 x 17 * 17 x 1  %Vo = Wo * Z; Y = Vo;
                    
                %[error function]
                E = E + (ones(1,64) * ((X-Y).^2)) ./ 2;
            end    
        end
        Ev(1,n/Fv)=E ./ training_size;
        if Emin > Ev(1,n/Fv)
            Emin = Ev(1,n/Fv);
            Emin_index = n;
        end        
    end
end
stat = hdfsd('end',sd_id_z);
stat = hdfsd('end',sd_id_o);
%[write error]
% create data set / write / close
sds_id_t = hdfsd('create',sd_id_t,'Et','double',2,fliplr(size(Et)));
stat = hdfsd('writedata',sds_id_t,zeros(1:ndims(Et)),[],fliplr(size(Et)),Et);
stat = hdfsd('endaccess',sds_id_t);
% create data set / write / close
sds_id_v = hdfsd('create',sd_id_v,'Ev','double',2,fliplr(size(Ev)));
stat = hdfsd('writedata',sds_id_v,zeros(1:ndims(Ev)),[],fliplr(size(Ev)),Ev);
stat = hdfsd('endaccess',sds_id_v);
stat = hdfsd('end',sd_id_t);
stat = hdfsd('end',sd_id_v);
Emin
Emin_index