function CreateAvgImage(FileName,FigUi)
% CreateAvgImage(FileName,FigUi)
% Create the avg image with no ant as the median of all image with ant


%% Message box


MessageBox = uiprogressdlg(FigUi,'Title','Please Wait','Message','Calcuting Avg Image. It might take a long time','Cancelable','on');

%% Image 1
[NameImage,Nini,Nimage]= vm_ListAllImage(fullfile(FileName,'Input',['JaiGO1_0*.png' ...
    '']));
ImAVG1=GenerateAvgImage();
%% Image 2 
[NameImage,Nini,Nimage]= vm_ListAllImage(fullfile(FileName,'Input','JaiGO1_JaiGO2_*.png'));
ImAVG2=GenerateAvgImage();
%% Save Image

if(MessageBox.CancelRequested==0)
    [status,msg,msgID] = mkdir(fullfile(FileName,'dataref'));
    imwrite(ImAVG1,fullfile(FileName,'dataref','JaiGO1_000000.png'));
    imwrite(ImAVG2,fullfile(FileName,'dataref','JaiGO1_JaiGO2_1_000000.png'));
end





    function ImAVG=GenerateAvgImage()
        NstepMax=200;
        if(Nimage<=NstepMax)
            NStep=Nimage;
            Step=1;
        else
            NStep=NstepMax;
            Step=floor(Nimage/NStep);
        end
        
        Im0=imread(sprintf(NameImage,Nini));
        Im=zeros(size(Im0,1),size(Im0,2),NStep);
        
        for i=1:NStep
            if(MessageBox.CancelRequested==0)
                Im(:,:,i)=imread(sprintf(NameImage,Nini+(i-1)*Step));
            end
        end
        
        ImAVG=Im0*0;
        for i=1:size(Im0,1)
            if(MessageBox.CancelRequested==0)
                    ImAVG(i,:)=median(Im(i,:,:),3);
            end
        end
        
    end

end

    

