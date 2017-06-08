%parameters
Emin_index=975;
beta = 0.2;
index='0.2_0_r';
Fv = 1;
color = 2;
nbin = 512;
quantization = 0;
if_histogram = 1; % only choose one of them
if_error_plot = 0; % only choose one of them 
im_file_path_1='D:\My Documents\neural network\1g.tif';
im_file_path_2='D:\My Documents\neural network\2g.tif';
im_output_path='E:\neural network\Lab1\results\';
record_input_path='E:\neural network\Lab1\results\';

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

%load weights
sd_id_z = hdfsd('start',strcat(record_input_path,'Wz',index,'.hdf'),'read');
sds_id_z = hdfsd('select',sd_id_z,Emin_index-1);
[ds_name, ds_ndims, ds_dims, ds_type, ds_atts, stat] = hdfsd('getinfo',sds_id_z);
ds_start = zeros(1,ds_ndims);
ds_stride = []; 
ds_edges = ds_dims; 
[Wz, status] = hdfsd('readdata',sds_id_z,ds_start,ds_stride,ds_edges);
stat = hdfsd('end',sd_id_z);

sd_id_o = hdfsd('start',strcat(record_input_path,'Wo',index,'.hdf'),'read');
sds_id_o = hdfsd('select',sd_id_o,Emin_index-1);
[ds_name, ds_ndims, ds_dims, ds_type, ds_atts, stat] = hdfsd('getinfo',sds_id_o);
ds_start = zeros(1,ds_ndims);
ds_stride = []; 
ds_edges = ds_dims; 
[Wo, status] = hdfsd('readdata',sds_id_o,ds_start,ds_stride,ds_edges);
stat = hdfsd('end',sd_id_o);

if if_histogram==1
x=-1+2/nbin/2:2/nbin:1-2/nbin/2;
histogram=zeros(1,nbin);
end
%test training sample===========================
for pixel_window_row=0:63
    for pixel_window_col=0:63
        r = pixel_window_row * 8;
        c = pixel_window_col * 8;
                    
        %initialize input vector (X)
        T = NormalizedImage1(r+1:r+8,c+1:c+8);
        X = T(:); % 64 x 1
        X1 = [1;X]; % 65 x 1
                    
        %[forward pass]
        % hidden neurons
        Vz = Wz * X1; % 16 x 65 * 65 x 1
        Z = tansig(beta .* Vz); % 16 x 1
        % pdf
        if if_histogram==1
            histogram = histogram + hist(Z, x);
        end
        % quantinization
        if quantization==1
        for i=1:length(Z)
            for j=1:length(boundary)-1
                if boundary(j) <= Z(i) && Z(i) < boundary(j+1)
                    Z(i) = (boundary(j)+boundary(j+1))/2;
                    break;
                end
            end
        end
        end
        Z1 = [1;Z];
        
        % output neurons 
        Y = purelin(Wo * Z1); % 64 x 17 * 17 x 1  %Vo = Wo * Z; Y = Vo;
                    
        i=0;
        pixel_window = Y(i*8+1:i*8+8,1);
        for i=1:7
            pixel_window = [pixel_window Y(i*8+1:i*8+8,1)];
        end
        DecodedNormalizedImage(r+1:r+8,c+1:c+8) = pixel_window;
    end
end
DecodedImage = uint8((DecodedNormalizedImage + ones(512,512)) ./ (2/256));
if color==1
    imwrite(DecodedImage,ColorMap1,strcat(im_output_path,'1d_',index,'.tif'),'tif');
else
    imwrite(DecodedImage,strcat(im_output_path,'1gd_',index,'.tif'),'tif');
end

%test validation sample===========================
for pixel_window_row=0:63
    for pixel_window_col=0:63
        r = pixel_window_row * 8;
        c = pixel_window_col * 8;
                    
        %initialize input vector (X)
        T = NormalizedImage2(r+1:r+8,c+1:c+8);
        X = T(:); % 64 x 1
        X1 = [1;X]; % 65 x 1
                    
        %[forward pass]
        % hidden neurons
        Vz = Wz * X1; % 16 x 65 * 65 x 1
        Z = tansig(beta .* Vz); % 16 x 1
        % quantinization
        if quantization==1        
        for i=1:length(Z)
            for j=1:length(boundary)-1
                if boundary(j) <= Z(i) && Z(i) < boundary(j+1)
                    Z(i) = (boundary(j)+boundary(j+1))/2;
                    break;
                end
            end
        end
        end
        Z1 = [1;Z];
        
        % output neurons 
        Y = purelin(Wo * Z1); % 64 x 17 * 17 x 1  %Vo = Wo * Z; Y = Vo;
                    
        i=0;
        pixel_window = Y(i*8+1:i*8+8,1);
        for i=1:7
            pixel_window = [pixel_window Y(i*8+1:i*8+8,1)];
        end
        DecodedNormalizedImage(r+1:r+8,c+1:c+8) = pixel_window;
    end
end
DecodedImage = uint8((DecodedNormalizedImage + ones(512,512)) ./ (2/256));
if color==1
    imwrite(DecodedImage,ColorMap1,strcat(im_output_path,'2d_',index,'.tif'),'tif');
else
    imwrite(DecodedImage,strcat(im_output_path,'2gd_',index,'.tif'),'tif');
end

%pdf =====================================================
if if_histogram==1
histogram = histogram / 4096 / 16;
plot(x,histogram,'r');
axis([-1 1 0 1]);
title('Pdf of the Outputs of the Hidden layer');
xlabel('Zi');
ylabel('f(Zi)');
end

if quantization==1
l=2/nbin; boundary=[]; bin=256;
s=0; prob=1/bin; indexU=90; indexL=450;
boundary=[boundary -1+indexU.*l];
for i=1:361
s=s+histogram(indexU+i);
if s>=prob-0.00365
boundary=[boundary -1+(i+indexU).*l];
s=0;
end
end
boundary=[boundary -1+indexL.*l];
length(boundary)
end

%error curve ==============================================
%load error data
sd_id_t = hdfsd('start',strcat(record_input_path,'Et',index,'.hdf'),'read');
sds_id_t = hdfsd('select',sd_id_t,0);
[ds_name, ds_ndims, ds_dims, ds_type, ds_atts, stat] = hdfsd('getinfo',sds_id_t);
ds_start = zeros(1,ds_ndims);
ds_stride = []; 
ds_edges = ds_dims; 
[Et, status] = hdfsd('readdata',sds_id_t,ds_start,ds_stride,ds_edges);
stat = hdfsd('end',sd_id_t);

sd_id_v = hdfsd('start',strcat(record_input_path,'Ev',index,'.hdf'),'read');
sds_id_v = hdfsd('select',sd_id_v,0);
[ds_name, ds_ndims, ds_dims, ds_type, ds_atts, stat] = hdfsd('getinfo',sds_id_v);
ds_start = zeros(1,ds_ndims);
ds_stride = []; 
ds_edges = ds_dims; 
[Ev, status] = hdfsd('readdata',sds_id_v,ds_start,ds_stride,ds_edges);
stat = hdfsd('end',sd_id_v);

%plot
if if_error_plot==1
y=[];
for i=1:length(Et)
    if mod(i,Fv)==0
        y=[y;Et(1,i) Ev(1,i/Fv)];
    end
end
x=1:Fv:length(Et);
x=log(x);
plot(x,y);
title('Error Plot');
xlabel('log(epoch)');
ylabel('error energy');
end