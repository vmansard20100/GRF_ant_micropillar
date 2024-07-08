function [Xd,Yd]=vm_getshiftimage(CORR)
% [Xd,Yd]=vm_getshiftimage(CORR)
% Calculate the displacement Xd and Yd based on the maximum of the
% correlation matrix CORR which is produced usin vm_correlationimage.m

X1=(size(CORR,1)+1)/2;
Y1=(size(CORR,2)+1)/2;


[~,pos]=max(CORR(:));
[Xm,Ym]=ind2sub(size(CORR),pos);
if(Xm==1 || Xm==size(CORR,1) || Ym==1 || Ym==size(CORR,2))
    Xd=0;
    Yd=0;
    warning('max of correlation on border');
else
    S=1;
    x=zeros((2*S+1)^2,1);
    y=x;
    z=x;
    
    for i=1:(2*S+1)
        for j=1:(2*S+1)
            I=(i-1)*(2*S+1)+j;
            x(I)=Xm+(i-S-1);
            y(I)=Ym+(j-S-1);
            z(I)=CORR(x(I),y(I));
        end
    end
    
    p=polyfitn([x,y],z,[0 0;1 0;2 0;0 1;0 2;1 1]);
    
    a00=p.Coefficients(1);
    a10=p.Coefficients(2);
    a20=p.Coefficients(3);
    a01=p.Coefficients(4);
    a02=p.Coefficients(5);
    a11=p.Coefficients(6);
    
    Delta=4*a20*a02-a11^2;
    Xd=(-2*a10*a02+a01*a11)/Delta;
    Xd=Xd-(size(CORR,1)+1)/2;
    Yd=(-2*a01*a20+a10*a11)/Delta;
    Yd=Yd-(size(CORR,2)+1)/2;

end
end