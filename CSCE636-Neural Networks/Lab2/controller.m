lT=10;
lC=3;
lN=1;
xMax=10;
yMax=5;
yMin=-5;
xDock=0;
yDock=0;
d=-2.23;

%initialize net
%netC=newff([xDock xMax; yMin yMax; -pi pi; -pi pi],[25,1],{'tansig','tansig'},'traingdm');
Wz1 = zeros(25,5); % 25 x 5
Wo1 = zeros(1,26); % 1 x 26

%training paramters
number_of_lessons=16;
number_of_topics=1;
traning_cycle_of_each_lesson=20;
beta=1;
alpha=0.6;
eta=0.1;
goal=1.0;

%initialize error storage
Et=[];
Emin=10000000;
Emin_index=0;
index=1;

for iter_l=1:1
    rnd_position = [];
    for iter_t=1:number_of_topics
        x=(0-d)*(iter_l-1)+rand(1,1).*(0-d)*iter_l;
        if (rand(1,1)>0.5)
            y=rand(1,1).*(yMax-(0-d));
        else
            y=-rand(1,1).*(yMax-(0-d));
        end
        T=rand(1,1).*2*pi-pi;
        C=rand(1,1).*2*pi-pi;
        rnd_position=[rnd_position [x; y; T; C]];
    end
    for iter_c=1:traning_cycle_of_each_lesson
        perm=randperm(number_of_topics);
        E = [];
        equal_to_zero_1=0;
        equal_to_zero_2=0;
        equal_to_zero_3=0;
        for iter_t=1:number_of_topics
            %x = rnd_position(1,perm(iter_t));
            %y = rnd_position(2,perm(iter_t));
            %T = rnd_position(3,perm(iter_t));
            %C = rnd_position(4,perm(iter_t));
            x = 6;
            y = -1;
            T = 0.4;
            C = -0.4;
            X_record = [];
            S_record = [];
            V_record = [];
            VE_record = [];
            counter=1;
            while 1>0
                X = [x; y; T; C];
                X_record = [X_record X];
                
                %[forward pass]
                % controller
                Vz = [netC.IW{1} netC.b{1}] * [X; 1];
                Z = tansig(Vz);
                Vo = [netC.LW{2,1} netC.b{2}] * [Z; 1];
                S = tansig(Vo);
                %S = purelin(Vo);
                V_record = [V_record Vo];
                %S = sim(netC,X);
                S_record = [S_record S];
                
                % emulator
                %Vz = [net.IW{1} net.b{1}] * [x; y; T; C; angle(S); 1];
                %Vz = [net.IW{1} net.b{1}] * [x; y; T; C; S; 1];
                %Z = tansig(Vz);
                %Vo = [net.LW{2,1} net.b{2}] * [Z; 1];
                %VE_record = [VE_record Vo];
                %Y = purelin(Vo);
                %Y = tansig(Vo);
                Y = sim(net,[x; y; T; C; angle(S)]);
                
                x=Y(1); y=Y(2); T=Y(3); C=Y(4);
                if x<=xDock || x>=xMax
                    break;
                end
                if y<=yMin || y>=yMax
                    break;
                end
                if counter >= 1000
                    '1000'
                    break;
                end
                counter=counter+1;
            end % end while
            if counter==1
                equal_to_zero_1=equal_to_zero_1+1;
            else
                x=X_record(1,counter); y=X_record(2,counter); T=X_record(3,counter); C=X_record(4,counter);
                Y=[x; y; T; C];
                counter=counter-1;              
            end
            if x==NaN || y==NaN || T==NaN
                break;
            end
            E=[E (x.^2+y.^2+T.^2)./2];
            steps=counter;
            
            Wo_diff = zeros(1,26);
            Wz_diff = zeros(25,5);        
            while (counter>=1)
                %[backward pass]
                
                % emulator
                Vz=[net.IW{1} net.b{1}] * [X_record(:,counter); angle(S_record(:,counter)); 1];
                Z=tansig(Vz);
                % output neurons of net (emulator)
                if (counter==steps)
                    delta = E(length(E)) .* dpurelin(Y); % 4 x 1
                    %delta = E(length(E)) .* dtansig(Y, VE_record(:,counter)); % 4 x 1
                else
                    delta = dpurelin(X_record(:,counter)) .* (netC.IW{1}' * delta); % 4 x 1
                    %delta = dtansig(X_record(:,counter), VE_record(:,counter)) .* (netC.IW{1}' * delta); % 4 x 1
                end
                % hidden neurons of net (emulator)
                delta = dtansig(beta .* Vz, Z) .* (net.LW{2,1}' * delta); % 45 x 1
                
                % controller
                Vz=[netC.IW{1} netC.b{1}] * [X_record(:,counter); 1];
                Z=tansig(Vz);
                % output neurons of netC (controller)
                %delta = dpurelin(S_record(:,counter)) .* (net.IW{1}(:,5)' * delta); % 5 x 1 => 1 x 1
                delta = dtansig(V_record(:,counter), S_record(:,counter)) .* (net.IW{1}(:,5)' * delta); % 5 x 1 => 1 x 1
                Temp = eta .* delta * [Z; 1]';
                %if isequal(Temp,zeros(1,26))
                %    'o'
                %    [iter_t counter]
                %end
                Wo_diff = Wo_diff + Temp; % 1 x 26
                % hidden neurons of netC (controller)
                delta = dtansig(beta .* Vz, Z) .* (netC.LW{2,1}' * delta); % 25 x 1
                Temp = eta .* delta * [X_record(:,counter); 1]';
                %if isequal(Temp,zeros(25,5))
                %    'z'
                %    [iter_t counter]
                %end                
                Wz_diff = Wz_diff + Temp; % 25 x 5
                counter=counter-1;
            end % end while
            Wo1 = alpha .* Wo1 + Wo_diff/steps;
            netC.LW{2,1} = netC.LW{2,1} + Wo1(:,1:25);
            netC.b{2} = netC.b{2} + Wo1(:,26);
            Wz1 = alpha .* Wz1 + Wz_diff/steps;
            netC.IW{1} = netC.IW{1} + Wz1(:,1:4);
            netC.b{1} = netC.b{1} + Wz1(:,5);
            if (isequal(Wo_diff,zeros(1,26)))
                equal_to_zero_2=equal_to_zero_2+1;
            end
            if (isequal(Wz_diff,zeros(25,5)))
                equal_to_zero_3=equal_to_zero_3+1;
            end
        end % end iter_t=1:number_of_topics
        %[equal_to_zero_1 equal_to_zero_2 equal_to_zero_3]
        % [record error]
        Temp = ones(1,length(E))*E'./length(E);
        [index Temp]
        Et=[Et Temp];
        if  Temp < Emin
            LW=netC.LW{2,1};
            b2=netC.b(2);
            IW=netC.IW{1};
            b1=netC.b{1};
            Emin=Temp;
            Emin_index=index;
        end
        %if (Emin<goal)
        %    break;
        %end
        index=index+1;        
    end
end
Emin
Emin_index