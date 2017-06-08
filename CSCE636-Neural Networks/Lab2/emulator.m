%initialize learning parameters
beta=1;
alpha=0;
eta=0.0001;
%number_of_lessons=16;
%traning_cycle_of_each_lesson=2500;
number_of_trials=1200;

hidden_layer_weight_record='Wz.hdf';
output_layer_weight_record='Wo.hdf';
training_error_record='Et.hdf';
min_error_record='Em.hdf';

lT=10;
lC=3;
lN=1;
xMax=10;
yMax=5;
yMin=-5;
xDock=0;
yDock=0;
d=-2.23;

%initialize weights Wz, Wo
%W = round(rand(1,8)).*2-ones(1,8);
%Wz = W;
%for i=2:45
%    Wz = [Wz;W];
%end
%Wz1 = zeros(45,8); % 45 x 8

%W = round(rand(1,45)).*2-ones(1,45);
%Wo = W;
%for i=2:6
%    Wo = [Wo;W];
%end
%Wo1 = zeros(6,45); % 6 x 45

%initialize error storage
%Et=zeros(1,number_of_trials);
%Emin=10000000;
%Emin_index=0;

    p=[1; 1; 1; 1; 1];
    t=[1; 1; 1; 1];
for i=1:number_of_trials
    %EE=0;
%for n1=start_distance:number_of_lessons+start_distance-1
    E=0;
    n=1;
    
    % random x y T C
    x=rand(1,1).*xMax;
    y=rand(1,1).*(yMax-yMin)+yMin;
    T=rand(1,1).*2*pi-pi;
    C=rand(1,1).*2*pi-pi;
    %xC=x+(lT+lN).*cos(T);
    %yC=y+(lT+lN).*sin(T);
    
    X=[1; 1; 1; 1; 1];
    D=[1; 1; 1; 1];
    while 1>0
        % random S
        S=rand(1,1).*2*pi-pi;
        
        %X=[xC; yC; x; y; T; C; S; 1];
        X=[X [x; y; T; C; S]];
        
        % next position
        x=x+d*cos(S)*cos(C-T)*cos(T);
        if x<=xDock || x>=xMax
            break;
        end
        y=y+d*cos(S)*cos(C-T)*sin(T);
        if y<=yMin || y>=yMax
            break;
        end
        %xC=xC+d*cos(S)*cos(C);
        %yC=yC+d*cos(S)*sin(C);
        T=T+atan(d*cos(S)*sin(C-T)/lT);
        T=angle(T);
        %if T >= pi
        %    T=mod(T,2*pi);
        %    if (T > pi) 
        %        T=-(pi-(T-pi));
        %    end
        %elseif T<=-pi
        %    T=-mod(-T,2*pi);
        %    if (T < -pi)
        %        T=pi+(T+pi);
        %    end
        %end        
        C=C+atan(d*sin(S)/lC);
        C=angle(C);
        %if C >= pi
        %    C=mod(C,2*pi);
        %    if (C > pi) 
        %        C=-(pi-(C-pi));
        %    end
        %elseif C<=-pi
        %    C=-mod(-C,2*pi);
        %    if (C < -pi)
        %        C=pi+(C+pi);
        %    end
        %end        
                
        %D=[xC; yC; x; y; T; C];
        D=[D [x; y; T; C]];
        
        %[forward pass]
        % hidden neurons
        %Vz = Wz * X; % 45 x 6 * 6 x 1
        %Z = tansig(beta .* Vz);
        
        % output neurons
        %Vo = Wo * Z; % 4 x 45 * 45 x 1
        %Y = tansig(beta .* Vo);
        %Y = sim(net,X);
        
        %[backward pass]
        % output neurons
        %Temp = eta .* ((D-Y) .* dtansig(beta .* Vo, Y)) * Z'; 
        %Wo1 = alpha .* Wo1 + Temp;
        %Wo = Wo + Wo1;
        
        % hidden neurons
        %Temp = eta .* dtansig(beta .* Vz, Z) .* (Wo' * ((D-Y) .* dtansig(beta .* Vo, Y))) * X';
        %Wz1 = alpha .* Wz1 + Temp; 
        %Wz = Wz + Wz1;
        
        %[error function]
        %D_=[D(1); D(2); angle(D(3)); angle(D(4))];
        %Y_=[Y(1); Y(2); angle(Y(3)); angle(Y(4))];
        %E=(E.*(n-1)+ones(1,6) * ((D-Y).^2) ./2)./n;
        %ones(1,4) * sqrt(((D_-Y_).^2)) ./2
        
        %n=n+1;
    end
    [m,n]=size(X);
    X=X(:,2:n-1);
    [m,n]=size(D);
    D=D(:,2:n);
    %EE=(EE*(n1-1)+E)/n1;
    %end
    %Et(1,i)=E;
    %if E~=0 && Et(1,i) < Emin
    %    Emin=Et(1,i);
    %    Emin_index=i;
    %end
    p=[p X];
    t=[t D];
end
    [m,n]=size(p);
    p=p(:,2:n);
    [m,n]=size(t);
    t=t(:,2:n);
    
    net=newff([xDock xMax; yMin yMax; -pi pi; -pi pi; -pi pi],[45,4],{'tansig','purelin'},'trainscg');
    net.trainParam.show = 20;
    %net.trainParam.lr = 0.01;
    %net.trainParam.mc = 0.2;
    net.trainParam.epochs = 150;
    net.trainParam.goal = 0.2;
    [net,tr]=train(net,p,t);


%[echo the minimum error and the epoch at which the minimum error occurs]
%Emin
%Emin_index