lT=5;
lC=1.5;
lN=0.5;
wW=lC/4;
w=lT/6;
x=X_record(1,1);
y=X_record(2,1);
xNeck=x+lT*cos(X_record(3,1));
yNeck=y+lT*sin(X_record(3,1));
xNeck_F=xNeck+lN*cos(X_record(3,1));
yNeck_F=yNeck+lN*sin(X_record(3,1));
xLeftT=x-w*cos(pi/2-X_record(3,1));
yLeftT=y+w*sin(pi/2-X_record(3,1));
xRightT=x+w*cos(pi/2-X_record(3,1));
yRightT=y-w*sin(pi/2-X_record(3,1));
xLeftT_F=xLeftT+lT*cos(X_record(3,1));
yLeftT_F=yLeftT+lT*sin(X_record(3,1));
xRightT_F=xRightT+lT*cos(X_record(3,1));
yRightT_F=yRightT+lT*sin(X_record(3,1));
xLeftC=xNeck_F-w*cos(pi/2-X_record(4,1));
yLeftC=yNeck_F+w*sin(pi/2-X_record(4,1));
xRightC=xNeck_F+w*cos(pi/2-X_record(4,1));
yRightC=yNeck_F-w*sin(pi/2-X_record(4,1));
xLeftC_F=xLeftC+lC*cos(X_record(4,1));
yLeftC_F=yLeftC+lC*sin(X_record(4,1));
xRightC_F=xRightC+lC*cos(X_record(4,1));
yRightC_F=yRightC+lC*sin(X_record(4,1));
xRightW_M=(xRightC_F+xRightC)/2;
yRightW_M=(yRightC_F+yRightC)/2;
xLeftW_M=(xLeftC_F+xLeftC)/2;
yLeftW_M=(yLeftC_F+yLeftC)/2;
xRightW_F=xRightW_M+wW*cos(X_record(4,1)-S_record(1));
yRightW_F=yRightW_M+wW*sin(X_record(4,1)-S_record(1));
xRightW_T=xRightW_M-wW*cos(X_record(4,1)-S_record(1));
yRightW_T=yRightW_M-wW*sin(X_record(4,1)-S_record(1));
xLeftW_F=xLeftW_M+wW*cos(X_record(4,1)-S_record(1));
yLeftW_F=yLeftW_M+wW*sin(X_record(4,1)-S_record(1));
xLeftW_T=xLeftW_M-wW*cos(X_record(4,1)-S_record(1));
yLeftW_T=yLeftW_M-wW*sin(X_record(4,1)-S_record(1));
xplot=[xNeck xRightT_F xRightT xLeftT xLeftT_F xNeck xNeck_F xLeftC xLeftW_M xLeftW_F xLeftW_T xLeftW_M xLeftC_F xRightC_F xRightW_M xRightW_F xRightW_T xRightW_M xRightC xNeck_F];
yplot=[yNeck yRightT_F yRightT yLeftT yLeftT_F yNeck yNeck_F yLeftC yLeftW_M yLeftW_F yLeftW_T yLeftW_M yLeftC_F yRightC_F yRightW_M yRightW_F yRightW_T yRightW_M yRightC yNeck_F];

h=plot(xplot,yplot);
axis([0 20 -10 10]);
axis square

set(h,'EraseMode','none')
[m,n]=size(X_record);
for i=2:n
drawnow

x=X_record(1,i);
y=X_record(2,i);
xNeck=x+lT*cos(X_record(3,i));
yNeck=y+lT*sin(X_record(3,i));
xNeck_F=xNeck+lN*cos(X_record(3,i));
yNeck_F=yNeck+lN*sin(X_record(3,i));
xLeftT=x-w*cos(pi/2-X_record(3,i));
yLeftT=y+w*sin(pi/2-X_record(3,i));
xRightT=x+w*cos(pi/2-X_record(3,i));
yRightT=y-w*sin(pi/2-X_record(3,i));
xLeftT_F=xLeftT+lT*cos(X_record(3,i));
yLeftT_F=yLeftT+lT*sin(X_record(3,i));
xRightT_F=xRightT+lT*cos(X_record(3,i));
yRightT_F=yRightT+lT*sin(X_record(3,i));
xLeftC=xNeck_F-w*cos(pi/2-X_record(4,i));
yLeftC=yNeck_F+w*sin(pi/2-X_record(4,i));
xRightC=xNeck_F+w*cos(pi/2-X_record(4,i));
yRightC=yNeck_F-w*sin(pi/2-X_record(4,i));
xLeftC_F=xLeftC+lC*cos(X_record(4,i));
yLeftC_F=yLeftC+lC*sin(X_record(4,i));
xRightC_F=xRightC+lC*cos(X_record(4,i));
yRightC_F=yRightC+lC*sin(X_record(4,i));
xRightW_M=(xRightC_F+xRightC)/2;
yRightW_M=(yRightC_F+yRightC)/2;
xLeftW_M=(xLeftC_F+xLeftC)/2;
yLeftW_M=(yLeftC_F+yLeftC)/2;
xRightW_F=xRightW_M+wW*cos(X_record(4,i)-S_record(i));
yRightW_F=yRightW_M+wW*sin(X_record(4,i)-S_record(i));
xRightW_T=xRightW_M-wW*cos(X_record(4,i)-S_record(i));
yRightW_T=yRightW_M-wW*sin(X_record(4,i)-S_record(i));
xLeftW_F=xLeftW_M+wW*cos(X_record(4,i)-S_record(i));
yLeftW_F=yLeftW_M+wW*sin(X_record(4,i)-S_record(i));
xLeftW_T=xLeftW_M-wW*cos(X_record(4,i)-S_record(i));
yLeftW_T=yLeftW_M-wW*sin(X_record(4,i)-S_record(i));
xplot=[xNeck xRightT_F xRightT xLeftT xLeftT_F xNeck xNeck_F xLeftC xLeftW_M xLeftW_F xLeftW_T xLeftW_M xLeftC_F xRightC_F xRightW_M xRightW_F xRightW_T xRightW_M xRightC xNeck_F];
yplot=[yNeck yRightT_F yRightT yLeftT yLeftT_F yNeck yNeck_F yLeftC yLeftW_M yLeftW_F yLeftW_T yLeftW_M yLeftC_F yRightC_F yRightW_M yRightW_F yRightW_T yRightW_M yRightC yNeck_F];


set(h,'XData',xplot,'YData',yplot)
end