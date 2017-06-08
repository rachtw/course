function T=angle(T)
        if T >= pi
            T=mod(T,2*pi);
            if (T > pi) 
                T=-(pi-(T-pi));
            end
        elseif T<=-pi
            T=-mod(-T,2*pi);
            if (T < -pi)
                T=pi+(T+pi);
            end
        end        
