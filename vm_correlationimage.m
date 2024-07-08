function Corr=vm_correlationimage(Im1,Im2,Size)
% Corr=vm_correlationimage(Im1,Im2,Size)
% Calculate the correlation matrix between 2 images

Size=min([Size,size(Im1,1),size(Im1,2)]);
Sx=size(Im2,1);
Sy=size(Im2,2);
Corr=zeros(2*Size+1,2*Size+1);
Ndata=Corr;
FI=find(Im1~=0);
[Xi,Yi]=ind2sub(size(Im1),FI);


for i=-Size:Size
    for j=-Size:Size
        for k=1:length(Xi)
            x=Xi(k)+i;
            y=Yi(k)+j;
            if(x>0 && x<=Sx && y>0 && y<=Sy)
                if(Im2(x,y)~=0)
                    Corr(i+Size+1,j+Size+1)=Corr(i+Size+1,j+Size+1)+Im1(Xi(k),Yi(k))*Im2(x,y);
                    Ndata(i+Size+1,j+Size+1)=Ndata(i+Size+1,j+Size+1)+1;
                end
            end
        end
    end
end
Ndata=max(Ndata,5);
Corr=Corr./Ndata;


end