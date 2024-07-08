function PlotAnt(XYBody,XYLeg,PlotBody,PlotLeg)
% PlotAnt(XYBody,XYLeg,PlotBody,PlotLeg)
% plot a schematic of an ant for all the function of analysis and detect

if(~exist('PlotBody','var'))
    PlotBody=ploth([NaN],[NaN],'b');
end
if(~exist('PlotLeg','var'))
    PlotLeg=ploth([NaN],[NaN],'r');
end


if(size(XYLeg)==[2 6])

elseif(size(XYLeg)==[6 2])
    XYBody=XYBody';
    XYLeg=XYLeg';
else
    error('XYLeg is not the right size')
end
U=XYBody(:,1)-XYBody(:,2);
V= [U(2) ;-U(1)];
A=[U'; V'];
xRef=[0 -0.22 -0.22 -0.4 -0.5 -0.6 -0.7 -0.9 -1];
yRef=[0   0.07  0.    0    0    0    0    0.1  0];

XYRef=[xRef NaN xRef;yRef NaN -yRef];

XYBody2=A*XYRef+XYBody(:,1);
XYnan=[NaN; NaN];
XYLeg2=[ XYBody2(:,4) XYLeg(:,1)  XYnan  XYBody2(:,5)  XYLeg(:,2)  XYnan  XYBody2(:,6)  XYLeg(:,3)  XYnan...
    XYBody2(:,4) XYLeg(:,4)  XYnan  XYBody2(:,5)  XYLeg(:,5)  XYnan  XYBody2(:,6)  XYLeg(:,6)  XYnan];

set(PlotBody,'Xdata',XYBody2(1,:),'Ydata',XYBody2(2,:));
set(PlotLeg ,'Xdata',XYLeg2(1,:), 'Ydata',XYLeg2(2,:));

end