lT=10;
lC=3;
lN=1;
xMax=10;
yMax=5;
yMin=-5;
xDock=0;
yDock=0;
d=-2.23;

x=rand(1,1).*xMax;
y=rand(1,1).*(yMax-yMin)+yMin;
T=rand(1,1).*2*pi-pi;
C=rand(1,1).*2*pi-pi;
[x y]

while 1>0
S = (5.4*(0.5*C-0.3*T)+3.6*((-0.02)*y));
S = angle(S);

X = [x; y; T; C; S];
Y = sim(net,X);

x=Y(1); y=Y(2); T=Y(3); C=Y(4);
[x y]
if x<=xDock || x>=xMax
    break;
end
if y<=yMin || y>=yMax
    break;
end

end