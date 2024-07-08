function DetectMvt(FileName,FrameName)
%function DetectMvt(FileName,FrameName)
%Detect Mvt of each seperate Pillar compare to the ref image
%FileName  (eg c:/.../Data/2021-0630)
%FrameName (eg Fram_23-27)

%% Figure
clc;

FigUi = uifigure('Name','DetectMvt by Dorian GAUTIER','Position',[340 60 400 800]);
FigUi.Icon='icon/ant.png';
FigUi.DeleteFcn=@ExitDetectMvt;

EndBtn= uibutton(FigUi,'Position',[50 10 300 40],'Text','DONE','ButtonPushedFcn',@(btn,event) CheckEnd(btn));
DrawMvtBtn= uibutton(FigUi,'Position',[50 60 300 40],'Text','Draw Movement (optional)','ButtonPushedFcn',@(btn,event) DrawMvt(btn));
CalculMvtBtn= uibutton(FigUi,'Position',[50 110 300 40],'Text','Calculate Movement','ButtonPushedFcn',@(btn,event) CalculMvt(btn));

% ThresholdPnl=  uipanel(FigUi,'Position',[20 160 360 60]);
% ThresholdLbl= uilabel(ThresholdPnl,'Position',[10 10 80 40],'Text','Threshold','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
% ThresholdBox= uieditfield(ThresholdPnl,"numeric",'Position',[120 15 100 30],'Editable','off');

SqSizePnl=  uipanel(FigUi,'Position',[20 160 360 60]);
SqSizeLbl= uilabel(SqSizePnl,'Position',[10 10 80 40],'Text','Boxes Size','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
SqSizeBox= uieditfield(SqSizePnl,"numeric",'Position',[120 15 100 30],'Editable','off');


PlotPnl=  uipanel(FigUi,'Position',[20 230 360 150],'Title','Drawing Parameter');
ArrowScaleLbl= uilabel(PlotPnl,'Position',[10 5 80 20],'Text','Arrow Size','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
ArrowScaleBox= uieditfield(PlotPnl,"numeric",'Position',[100 5 80 20]);
PlotAntChBx= uicheckbox(PlotPnl,'Position',[10 30 150 20],'Text','Plot Ant during Drawing?','Value',1);

PlotTypeBG=uibuttongroup(PlotPnl,'Position',[10 50 300 70]);
PlotTypeRB(1)=uiradiobutton(PlotTypeBG,'Position',[10 5+22*1 160 20],'Text','Grey Differential Image');
PlotTypeRB(2)=uiradiobutton(PlotTypeBG,'Position',[10 5      160 20],'Text','RGB image');
PlotTypeLbl= uilabel(PlotTypeBG,'Position',[10 0+22*2 160 30],'Text','Which type of Plot ?','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');


DetectPnl=  uipanel(FigUi,'Position',[20 390 360 300],'Title','Detection Parameters');
ThresholdLbl= uilabel(DetectPnl,'Position',[0 5 180 20],'Text','Threshold for mask estimation','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
ThresholdBox= uieditfield(DetectPnl,"numeric",'Position',[185 5 50 20],'ValueChangedFcn',@(btn,event) UpdateMaskArray(btn));
ShowMaskBtn= uibutton(DetectPnl,'Position',[240 5 90 20],'Text','Show Mask','ButtonPushedFcn',@(btn,event) VisualizeMaskArray(btn));
ThNumberAvgdLbl= uilabel(DetectPnl,'Position',[0 30 260 20],'Text','#Min of moving images for bg substraction?','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
ThNumberAvgBox= uieditfield(DetectPnl,"numeric",'Position',[285 30 50 20],'Value',10);
ThMeanAvgdLbl= uilabel(DetectPnl,'Position',[0 55 270 20],'Text','Threshold param to consider a  moving pillar?','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
ThMeanAvgBox= uieditfield(DetectPnl,"numeric",'Position',[285 55 50 20],'Value',20);
RelativeDetectChBx= uicheckbox(DetectPnl,'Position',[5 80 300 20],'Text','Use Relative Detection during cross Correlation?','Value',0);
SubstractAvgChBx=   uicheckbox(DetectPnl,'Position',[5 105 300 20],'Text','Substract Avg Background?','Value',0,'Enable','off');
DetectionSelectedPillarChBx= uicheckbox(DetectPnl,'Position',[5 130 300 20],'Text','Only detect mvt of selected pillars?','Value',0,'Enable','off');
SubstractAvgBtn=      uibutton(DetectPnl,'Position',  [210 115 110 30],'Text','Calculate Average','ButtonPushedFcn',@(btn,event) AvgImage(btn),'Enable','off');
AlignImageChBx=     uicheckbox(DetectPnl,'Position',[5 155 100 20],'Text','Align Images?','Value',0,'Enable','off');
AlignImageBtn=      uibutton(DetectPnl,'Position',  [110 155 110 20],'Text','Align Images','ButtonPushedFcn',@(btn,event) AlignImage(btn));



DetectTypeBG=uibuttongroup(DetectPnl,'Position',[10 180 200 70]);
DetectTypeRB(1)=uiradiobutton(DetectTypeBG,'Position',[10 5+22*1 160 20],'Text','Cross Correlation');
DetectTypeRB(2)=uiradiobutton(DetectTypeBG,'Position',[10 5      160 20],'Text','BW threshold');
DetectTypeLbl= uilabel(DetectTypeBG,'Position',[10 0+22*2 160 30],'Text','Which type of Detection?','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
MaximumPixDisdLbl= uilabel(DetectPnl,'Position',[200 220 180 20],'Text','Maximum displacement','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
MaximumPixDisdLbl2= uilabel(DetectPnl,'Position',[200 205 180 20],'Text','measured (pixel)','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
MaximumPixDisdBox= uieditfield(DetectPnl,"numeric",'Position',[265 185 50 20],'Value',4);


InfoLbl= uilabel(FigUi,...
    'Position',[20 700 360 100],...
    'Text','',...
    'BackgroundColor',[0.7 0.7 0.7],'FontWeight','Bold','HorizontalAlignment','Center');
InfoLbl.Text=sprintf('Calculate the Pillar movements \n you have nothing to do \n\n The optional button "Draw" enable to vizualize \n the result which is save in external files \n you can only set parameters for the Drawing part');

%%

Fig=figure('Position',[850 60 800 800]);
Fig.DeleteFcn=@ExitDetectMvt;


%% Variable

IntMax=NaN;
IntMin=NaN;
ImRef=[];
ImBwRef=[];

ImRefArray={};
ImAvgArray={};
MaskArray={};
% IntMeanRef=[];
% IntMean=[];
TFormArray={};
ChMvt=[]; %Bolean to say if there is movement or not.
Im=[];


Pillar=[];
Mvt=[];
PosRef=[];

AntArray=[];

Index=NaN;
NameImage='';
Nini=NaN;
Nimage=NaN;
Npillar=NaN;
A=0;
B=0;
C=0;
a=0;
b=0;
c=0;

Param.Threshold=0;
Param.DetectType=1;
Param.IsRelativeDetect=0;

%% Variable parametring
ArrowScaleBox.Value=20;
%% Run
ReadData();
ReadImage();
UpdateMaskArray();

%% Function

    function CalculMvt(varargin)
        
        Param.DetectType=1;
        for ii=1:2
            if(eq(DetectTypeBG.SelectedObject,DetectTypeRB(ii)))
                Param.DetectType=ii;
            end
        end
        Param.IsRelativeDetect=RelativeDetectChBx.Value;
        Param.AlignImage=AlignImageChBx.Value;
        Param.SubstractAvg=SubstractAvgChBx.Value;
        Param.DetectionSelectedPillar=DetectionSelectedPillarChBx.Value;
        Param.PlotAnt=PlotAntChBx.Value;
        Param.MaximumPixDis=MaximumPixDisdBox.Value;
        switch Param.DetectType
            case 1
                % profile on
                CalculMvtCrossCorrelation()
                % profile off
                % profile viewer
            case 2
                CalculMvtBW();
        end
        
        % for ii=1:Nimage
        %     Xavg=median(Mvt(ii,:,1));
        %     Yavg=median(Mvt(ii,:,2));
        % 
        %     Mvt(ii,:,1)=Mvt(ii,:,1)-Xavg;
        %     Mvt(ii,:,2)=Mvt(ii,:,2)-Yavg;
        % end
        
         SaveData()
    end   

    function CalculMvtCrossCorrelation()
        Rfixed = imref2d(size(ImRef));
        MessageBox = uiprogressdlg(FigUi,'Title','Please Wait','Message','Detecting Position','Cancelable','on');
        for ii=1:Nimage
            if(MessageBox.CancelRequested==0)
                Im=imread(sprintf(NameImage,ii-1+Nini));
                if(Param.AlignImage) Im = imwarp(Im,TFormArray{ii},"OutputView",Rfixed); end
                for jj=1:Npillar

                    if(Param.DetectionSelectedPillar==1 && ChMvt(ii,jj)==0)
                        Mvt(ii,jj,1:2)=[0,0];
                    else
                        Im2=double(Im(Pillar.XYSquare(jj,1,1):Pillar.XYSquare(jj,1,2),Pillar.XYSquare(jj,2,1):Pillar.XYSquare(jj,2,2)));
                        % Im2=Im2*IntMeanRef(jj)/IntMean(ii,jj);
                        if( RelativeDetectChBx.Value==1 && ii>1)
                            ImRefDetectMvt2=double(ImRefDetectMvt(Pillar.XYSquare(jj,1,1):Pillar.XYSquare(jj,1,2),Pillar.XYSquare(jj,2,1):Pillar.XYSquare(jj,2,2)));
                            if(Param.SubstractAvg)
                                [dXd,dYd]=CrossCorrelation(Im2-ImAvgArray{jj},ImRefDetectMvt2-ImAvgArray{jj},jj);
                            else
                                [dXd,dYd]=CrossCorrelation(Im2,ImRefDetectMvt2,jj);
                            end
                            Mvt(ii,jj,1)=Mvt(ii-1,jj,1)+dXd;
                            Mvt(ii,jj,2)=Mvt(ii-1,jj,2)+dYd;
                        else
                            if(Param.SubstractAvg)
                                [Mvt(ii,jj,1),Mvt(ii,jj,2)]=CrossCorrelation(Im2-ImAvgArray{jj},ImRefArray{jj}-ImAvgArray{jj},jj);
                            else
                                [Mvt(ii,jj,1),Mvt(ii,jj,2)]=CrossCorrelation(Im2,ImRefArray{jj},jj);
                            end
                        end
                    end

                    % [status, msg, msgID] = mkdir(sprintf('./temp/%0.2d',jj));
                    % imwrite(uint8(Im2),sprintf('./temp/%0.2d/im_%0.2d.png',jj,ii));
                    % imwrite(uint8(ImRefArray{jj}),sprintf('./temp/%0.2d/im_ref.png',jj));

                end

                Index=ii;
                PlotImage();
                if(Param.PlotAnt)
                    hold on
                    DoPlotAnt(Index);
                    hold off
                end
                drawnow;

                ImRefDetectMvt = Im;

                MessageBox.Message= sprintf('Detecting Position - image %d/%d',ii,Nimage);
                MessageBox.Value=ii/Nimage;
            end
        end
        delete(MessageBox);
    end
    
    function CalculMvtBW()   
        MessageBox = uiprogressdlg(FigUi,'Title','Please Wait','Message','Detecting Position','Cancelable','on');    
        for ii=1:Nimage
            if(MessageBox.CancelRequested==0)
                Im=(imread(sprintf(NameImage,ii-1+Nini)));  
                for jj=1:Npillar
                    Im2=double(Im(Pillar.XYSquare(jj,1,1):Pillar.XYSquare(jj,1,2),Pillar.XYSquare(jj,2,1):Pillar.XYSquare(jj,2,2)));
                    [XYc]=CalculPositionBW(Im2);
                    Mvt(ii,jj,1)=XYc(1)-PosRef(jj,1);
                    Mvt(ii,jj,2)=XYc(2)-PosRef(jj,2);
                end
                
                
                [status, msg, msgID] = mkdir(sprintf('./temp/%0.2d',jj));
                imwrite(uint8(Im2),sprintf('./temp/%0.2d/im_%0.2d.png',jj,ii));
                imwrite(uint8(ImRefArray{jj}),sprintf('./temp/%0.2d/im_ref.png',jj));
                
                Index=ii;
                PlotImage();
                drawnow;
                
                MessageBox.Message= sprintf('Detecting Position - image %d/%d',ii,Nimage);
                MessageBox.Value=ii/Nimage;
            end
        end
        delete(MessageBox);
    end

    function AlignImage(varargin)

        MessageBox = uiprogressdlg(FigUi,'Title','Please Wait','Message','Aligning Images','Cancelable','on');
               
        for ii=1:Nimage
            if(MessageBox.CancelRequested==0)
                Im=imread(sprintf(NameImage,ii-1+Nini));
                % TFormArray{ii}= imregcorr(Im(1024+(-255:256),1280++(-255:256)),uint8(ImRef(1024+(-255:256),1280+(-255:256))),'rigid');
                
                Im1=single(Im(1024+(-255:256),1280++(-255:256)));
                Im2=single(ImRef(1024+(-255:256),1280+(-255:256)));
                Corr=vm_correlationimage(Im1,Im2,3);
                [Xd,Yd]=vm_getshiftimage(Corr);
                TFormArray{ii}= simtform2d(1,0,[Yd,Xd]);
                %  disp([ii TFormArray{ii}.Translation]);
                %  disp([ii,Yd,Xd]);
                % a=1;
            end
            MessageBox.Message= sprintf('Aligning images Position - image %d/%d',ii,Nimage);
            MessageBox.Value=ii/Nimage;
        end
        
        if(~MessageBox.CancelRequested)
            AlignImageChBx.Enable='on';
            AlignImageChBx.Value=1;
            AlignImageBtn.Enable='off';
            SubstractAvgBtn.Enable='on';
        end
        delete(MessageBox);
    end

    function AvgImage(varargin)

        Param.AlignImage=AlignImageChBx.Value;
        Param.ThMeanAvg=ThMeanAvgBox.Value
        Param.ThNumberAvg=ThNumberAvgBox.Value;

        ImAvgArray=ImRefArray;
        NAvg=ones(Npillar,1);
        S=zeros(Nimage,Npillar)*NaN;
        ChMvt=ones(Nimage,Npillar,'logical')*0;

        Rfixed = imref2d(size(ImRef));

        MessageBox = uiprogressdlg(FigUi,'Title','Please Wait','Message','Averaging Images','Cancelable','on');
        
        IntMean=zeros(Nimage,Npillar);
        IntMeanRef=zeros(Npillar,1);
        for jj=1:Npillar
            IntMeanRef(jj)=mean(ImRefArray{jj}(MaskArray{jj}));
        end

        for ii=1:Nimage
            if(MessageBox.CancelRequested==0)
                Im=imread(sprintf(NameImage,ii-1+Nini));
                if(Param.AlignImage) Im = imwarp(Im,TFormArray{ii},"OutputView",Rfixed); end

                for jj=1:Npillar
                    Im2=single(Im(Pillar.XYSquare(jj,1,1):Pillar.XYSquare(jj,1,2),Pillar.XYSquare(jj,2,1):Pillar.XYSquare(jj,2,2)));
                    IntMean(ii,jj)=mean(Im2(MaskArray{jj}));
                    
                    % Im2=Im2;

                    Im3=Im2*IntMeanRef(jj)/IntMean(ii,jj)-ImRefArray{jj};
                    Avg=mean((Im3(MaskArray{jj})).^2);
                    S(ii,jj)=Avg;
                    if(Avg>=Param.ThMeanAvg)
                        ChMvt(ii,jj)=1;
                        NAvg(jj)=NAvg(jj)+1;
                        ImAvgArray{jj}=ImAvgArray{jj}+Im2;
                    else
                        ChMvt(ii,jj)=0;
                    end
                end
                a=1;
                if(mod(ii,10)==0 || ii==Nimage)
                    figure(Fig);
                    imshow(ImRef,[], 'InitialMagnification', 'fit');
                    hold on
                    DoPlotAnt(ii);
                    hold off
                    FI=find(NAvg>=Param.ThNumberAvg);
                    ploth(Pillar.Position(FI,2),Pillar.Position(FI,1),'ro');
                    FI=find(NAvg>=2 & NAvg<Param.ThNumberAvg);
                    ploth(Pillar.Position(FI,2),Pillar.Position(FI,1),'pg');
                    drawnow
                end
                MessageBox.Message= sprintf('Averaging images - image %d/%d',ii,Nimage);
                MessageBox.Value=ii/Nimage;
            end
        end

        for jj=1:Npillar
            if(NAvg(jj)>=Param.ThNumberAvg)
                ImAvgArray{jj}=ImAvgArray{jj}/NAvg(jj);
            else
                ImAvgArray{jj}(:)=0;
            end
        end
        a=1;
        if(~MessageBox.CancelRequested)
            SubstractAvgChBx.Enable='on';
            % SubstractAvgChBx.Value=1;

            DetectionSelectedPillarChBx.Enable='on';
            DetectionSelectedPillarChBx.Value=1;
        end
        delete(MessageBox);
    end

    function [Xd,Yd]=CrossCorrelation(Im,ImRefDetectMvt,IndPillar)
        Im=Im-mean(Im(MaskArray{IndPillar}));
        Im(~MaskArray{IndPillar})=0;
        
        ImRefDetectMvt=ImRefDetectMvt-mean(ImRefDetectMvt(MaskArray{IndPillar}));
        ImRefDetectMvt(~MaskArray{IndPillar})=0;
        
        Corr=vm_correlationimage(ImRefDetectMvt,Im,Param.MaximumPixDis);
        [Xd,Yd]=vm_getshiftimage(Corr);
        
        
    end

    function [XYc]=CalculPositionBW(Im)
        ImBw2=Im>ThresholdBox.Value;
        RP=regionprops(ImBw2,'Centroid','Area');
        [~,pos]=max([RP.Area]);
        XYc(1)=RP(pos).Centroid(1);
        XYc(2)=RP(pos).Centroid(2);
    end

    function DrawMvt(varargin)
        [~,~,~] = mkdir(fullfile(FileName,'step2',sprintf('Mvt_%s',FrameName)));
        MessageBox = uiprogressdlg(FigUi,'Title','Please Wait','Message','Drawing Result','Cancelable','on');
        
        
        Im2=zeros(size(Im,1),size(Im,2),3);
        Im2(:,:,2)=(ImRef-IntMin)/(IntMax-IntMin)*1.5;
        
        for ii=1:1:Nimage
            if(MessageBox.CancelRequested==0)
                Im=double(imread(sprintf(NameImage,ii-1+Nini)));
                
                switch PlotTypeBG.SelectedObject
                    case PlotTypeRB(1)
                        imshow(Im-ImRef,[-15 15]);
                    case PlotTypeRB(2)
                        Im2(:,:,3)=(Im-IntMin)/(IntMax-IntMin)*1.5;
                        imshow(Im2);
                end
                hold on;
                ArrowScale=ArrowScaleBox.Value;
                quiver(Pillar.Position(:,2),Pillar.Position(:,1),Mvt(ii,:,2)'*ArrowScale,Mvt(ii,:,1)'*ArrowScale,'g','AutoScale','off')
                if(PlotAntChBx.Value)  DoPlotAnt(ii); end
                hold off
                title([' image ' num2str(ii) '/' num2str(Nimage) ]);
                
                FileName2=fullfile(FileName,'step2',sprintf('Mvt_%s',FrameName),sprintf('Mvt_%s_%0.4d.png',FrameName,ii));
                print(Fig,FileName2,'-dpng','-r200');
                
                MessageBox.Message= sprintf('Drawing Result - image %d/%d',ii,Nimage);
            end
        end
        delete(MessageBox);
    end

     function DoPlotAnt(Index)
         
        Xh=reshape(AntArray(Index,1,:),2,1);
        Xt=reshape(AntArray(Index,2,:),2,1);

        Xr1=reshape(AntArray(Index,3,:),2,1);
        Xr2=reshape(AntArray(Index,4,:),2,1);
        Xr3=reshape(AntArray(Index,5,:),2,1);
        Xl1=reshape(AntArray(Index,6,:),2,1);
        Xl2=reshape(AntArray(Index,7,:),2,1);
        Xl3=reshape(AntArray(Index,8,:),2,1);
        XYBody=[Xh Xt];
        XYLeg=[Xr1 Xr2 Xr3 Xl1 Xl2 Xl3];
        
        PlotBody=plot([NaN],[NaN],'g');
        PlotLeg =plot([NaN],[NaN],':c');
        
        PlotAnt(XYBody,XYLeg,PlotBody,PlotLeg); 
        % Xm=(Xh+Xt)/2;
        % 
        % X=[Xh  Xt  Xm  Xr1  Xm  Xr2 Xm Xr3  Xm  Xl1  Xm  Xl2  Xm  Xl3];
        % plot(X(1,:),X(2,:),':c');
        % X=[Xh Xt];
        % plot(X(1,:),X(2,:),'g');
     end

    function PlotImage(varargin)
        imshow(Im,[IntMin IntMax]);
        hold on;
        plot(Pillar.Position(:,2),Pillar.Position(:,1),'rx');
        ArrowScale=ArrowScaleBox.Value;
        quiver(Pillar.Position(:,2),Pillar.Position(:,1),Mvt(Index,:,2)'*ArrowScale,Mvt(Index,:,1)'*ArrowScale,'y','AutoScale','off')
        hold off
        title([' image ' num2str(Index) '/' num2str(Nimage) ]);
    end

    function CheckEnd(btn,event)
        FI=find(isnan(Mvt(:)));
        
        if(isempty(FI))
            ExitDetectMvt();
        else
            msgbox("Not completed. Impossible to end");
            SaveData();
        end
    end

    function ExitDetectMvt(btn,event)
        SaveData();
        delete(Fig);
        delete(FigUi);
    end

    function ReadImage()
        ImRef=double(imread(fullfile(FileName,'step1',FrameName,'Pillar_ref.png')));
        IntMax=max(ImRef(:));
        IntMin=min(ImRef(:));
        ImBwRef=ImRef>ThresholdBox.Value;
        
        ImRefArray=cell(size(Pillar.Position,1),1);
        PosRef=zeros(Npillar,2);
        
        for ii=1:Npillar
            
            ImRefArray{ii}=ImRef(Pillar.XYSquare(ii,1,1):Pillar.XYSquare(ii,1,2),Pillar.XYSquare(ii,2,1):Pillar.XYSquare(ii,2,2));
            PosRef(ii,1:2)=CalculPositionBW(ImRefArray{ii});
        end
       
        
    end

    function UpdateMaskArray(varargin)
        XYc=zeros(Npillar,2);
        Param.Threshold=ThresholdBox.Value;
        for ii=1:Npillar
            [MaskArray{ii},XYc(ii,:)]=CalculMask(ImRefArray{ii},0);       
            Pillar.Position(ii,1)=Pillar.XYSquare(ii,1,1)+XYc(ii,2);
            Pillar.Position(ii,2)=Pillar.XYSquare(ii,2,1)+XYc(ii,1);    
        end
          
        figure(Fig);
        imshow(ImRef,[], 'InitialMagnification', 'fit');
        ploth(Pillar.Position(:,2),Pillar.Position(:,1),'y.');
        ploth(Pillar.Position(:,2),Pillar.Position(:,1),'ro');
        drawnow
        
    end

    function VisualizeMaskArray(varargin)
        
        MessageBox = uiprogressdlg(FigUi,'Title','Please Wait','Message','Detecting Position','Cancelable','on');
        List=randperm(Npillar);
        for ii=1:Npillar
            if(MessageBox.CancelRequested==0)
                CalculMask(ImRefArray{List(ii)},1);
                MessageBox.Message= sprintf('Detecting Position - image %d/%d',ii,Npillar);
                MessageBox.Value=ii/Npillar;
            end
        end
        delete(MessageBox);
    end

    function [Mask,XYc]=CalculMask(Im,DoPlot)
        S1=size(Im,1);
        S2=size(Im,2);
        
        Mask=Im>Param.Threshold;
        Mask = bwareaopen(Mask ,100);
        se = strel('disk',2);
        Mask  = imclose(Mask ,se);
        %             Erode=Pillar.Param.Erode;
        Erode=5;
        se = strel('disk',Erode);
        Mask = imerode(Mask ,se);
        Mask2=Mask;
        RP = regionprops(Mask,'Area','Centroid');
        if(~isempty(RP))
            [~,pos]=max([RP.Area]);
            XYc=RP(pos).Centroid;
            [X,Y]=meshgrid(1:S1,1:S2);
            R=sqrt((X-XYc(1)).^2+(Y-XYc(2)).^2);
            Mask=zeros(S1,S2,'logical');
            Mask(R<10)=1;
            a=1;
        else
            Mask=ones(S1,S2,'logical');
            XYc=[NaN NaN];
        end
        
        if(DoPlot)
            Im3=zeros(S1,S2,3);
            Im3(:,:,1)=(Im-min(Im(:)))/(max(Im(:))-min(Im(:)));
            Im3(:,:,2)=(Im-min(Im(:)))/(max(Im(:))-min(Im(:)));
            Im3(:,:,3)=(Im-min(Im(:)))/(max(Im(:))-min(Im(:)));
            
            A=Im3(:,:,2);
            A(Mask2)=A(Mask2)-100;
            Im3(:,:,2)= A;
            
            A=Im3(:,:,3);
            A(Mask)=A(Mask)-100;
            Im3(:,:,3)= A;
            
            figure(Fig);
            imshow(Im3, 'InitialMagnification', 'fit');
            ploth(XYc(:,1),XYc(:,2),'yo');
            pause(0.2);
        end
    end

    function ReadData()
        [NameImage,Nini,Nimage]= vm_ListAllImage(fullfile(FileName,'step1',FrameName,'Pillar','Pillar*.png'));
        
        FileName2=fullfile(FileName,'step2','pillar.mat');
        if(exist(FileName2,'file'))
            load(FileName2,'Pillar');
            ThresholdBox.Value=Pillar.Param.Threshold;
            SqSizeBox.Value=Pillar.Param.SqSize;
            Npillar=size(Pillar.Position,1);
        else
            msgbox("Erreur pas de fichier pillar.mat");
        end
        
        
        FileName2=fullfile(FileName,'step2',['ant_' FrameName '.mat']);
        if(exist(FileName2,'file'))
            load(FileName2,'AntArray');
        else
            msgbox("Erreur pas de fichier ant_Frame*-*.mat");
        end
        
        FileName2=fullfile(FileName,'step2',['mvt_' FrameName '.mat']);
        if(exist(FileName2,'file'))
            load(FileName2,'Movement');
            Mvt=Movement.Disp;
            ThresholdBox.Value=Movement.Param.Threshold;
            DetectTypeBG.SelectedObject
            RelativeDetectChBx.Value=Movement.Param.IsRelativeDetect;
            DetectTypeRB(Movement.Param.DetectType).Value=1;
            
            if(size(Mvt,[1 2 3])==[Nimage Npillar 2])
                %                 msgbox("Données extraite de mvt_Frame*-*.mat");
                %                 figure(Fig);
            else
                Mvt=zeros(Nimage,Npillar,2)*NaN;
            end
        else
            Mvt=zeros(Nimage,Npillar,2)*NaN;
        end
    end

    function SaveData()
        if(~isempty(Mvt))
            Movement.Position=Pillar.Position;
            Movement.Disp    =Mvt;
            Movement.Amplitude=sqrt(Mvt(:,:,1).^2+Mvt(:,:,2).^2);
            Movement.Param=Param;
            [status,msg,msgID] = mkdir(fullfile(FileName,'step2'));
            save(fullfile(FileName,'step2',['mvt_' FrameName '.mat']),'Movement');
        end
    end

end