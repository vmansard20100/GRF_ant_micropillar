function IM2=vm_rotatecropimage(IM,ReshapeData)
% IM2=vm_rotatecropimage(IM,ReshapeData)
% Rotate and crop the image to match the top and bottom view. Top view
% (bright field) need to show a bigger field of view than the bottom view
% (fluo)
% 


XY=round(ReshapeData.XY);
Xl=min(XY(:,1)):max(XY(:,1));
Yl=min(XY(:,2)):max(XY(:,2));
IM2=IM( Yl,Xl);


if(ReshapeData.FlipHorizontal==1)
    IM2=IM2(:,end:-1:1);
end

if(ReshapeData.FlipVertical==1)
    IM2=IM2(end:-1:1,:);
end

% X1=[min(X(:,1)); min(X(:,2))];
% X2=[max(X(:,1)); max(X(:,2))];
% %%
% 
% dX=X2-X1;
% Angle=rad2deg(angle(dX(1)+1i*dX(2)))-40.59;
% IM2=imrotate(IM,Angle,'Crop');
% 
% Xc=[size(IM,2);size(IM,1)]/2;
% R = [cosd(Angle) sind(Angle); -sind(Angle) cosd(Angle)];
% 
% Y1=(R*(X1-Xc))+Xc;
% Y2=(R*(X2-Xc))+Xc;
% Y1=floor(Y1);
% Y2=floor(Y2);
% 
% IM2=IM2(Y1(2):Y2(2),Y1(1):Y2(1));
% IM2=IM2(:,end:-1:1);
end
