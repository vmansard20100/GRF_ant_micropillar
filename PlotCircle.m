function PlotCircle(Xc,Yc,Rc,color,Plot)
% PlotCircle(Xc,Yc,Rc,color,Plot)
% Plot a circle center on Xc and Yx with a radius Rc

if(~exist('color','var'))
    color='y';
end

t=0:(2*pi)/101:2*pi;
Npt=length(Xc);

X=zeros((length(t)+1)*Npt,1)*NaN;
Y=X;
for i=1:Npt
    X((i-1)*(length(t)+1)+(1:length(t)))=Xc(i)+cos(t)*Rc(i);
    Y((i-1)*(length(t)+1)+(1:length(t)))=Yc(i)+sin(t)*Rc(i);
end

if(exist('Plot','Var'))
    set(Plot,'XData',X,'YData',Y);
else
    ploth(X,Y,color);
end
end
