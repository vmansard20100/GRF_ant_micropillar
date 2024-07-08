function [xd,yd]=DistortedPt(xu,yu,xc,yc,K1,K2)
%[xd,yd]=DistortedPt(xu,yu,xc,yc,K1,K2)
% Distortion of pillar array position to take account of the camera
% distortion

r=sqrt((xu-xc).^2+(yu-yc).^2);
r=r/1000;
xd=xc+(xu-xc).*(1+K1*r.^2+K2*r.^4);
yd=yc+(yu-yc).*(1+K1*r.^2+K2*r.^4);
end