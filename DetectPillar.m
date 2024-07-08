 function DetectPillar(FileName,FrameName)
%function DetectPillar(FileName,FrameName)
%Detect the Pillar in the ref image
%FileName  (eg c:/.../Data/2021-0630)
%FrameName (eg Fram_23-27)

%% Figure
FigUi = uifigure('Name','DetectPillar by Dorian GAUTIER','Position',[340 60 350 800]);
FigUi.Icon='icon/ant.png';
FigUi.DeleteFcn=@ExitDetectPillar;

EndBtn= uibutton(FigUi,'Position',[10 20 330 40],'Text','DONE','ButtonPushedFcn',@(btn,event) CheckEnd(btn));

ArrayPnl=  uipanel(FigUi,'Position',[10 70 330 150]);
Distortion1Lbl= uilabel(ArrayPnl,'Position',[10 10 100 30],'Text','Distortion K1','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
Distortion1Box= uieditfield(ArrayPnl,"numeric",'Position',[115 10 50 30],'Value',0,'ValueChangedFcn',@UpdatePillarList);
Distortion2Lbl= uilabel(ArrayPnl,'Position',[170 10 100 30],'Text','Distortion K2','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
Distortion2Box= uieditfield(ArrayPnl,"numeric",'Position',[275 10 50 30],'Value',0,'ValueChangedFcn',@UpdatePillarList);
LengthArrayLbl= uilabel(ArrayPnl,'Position',[10 45 100 30],'Text','Length','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
LengthArrayBox= uieditfield(ArrayPnl,"numeric",'Position',[115 45 50 30],'Value',0,'ValueChangedFcn',@UpdatePillarList);
AngleArrayLbl= uilabel(ArrayPnl,'Position',[170 45 100 30],'Text','Angle °','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
AngleArrayBox= uieditfield(ArrayPnl,"numeric",'Position',[275 45 50 30],'Value',0,'ValueChangedFcn',@UpdatePillarList);
DiameterCenterLbl= uilabel(ArrayPnl,'Position',[10 80 150 30],'Text','Diameter of the base','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
DiameterCenterBox= uieditfield(ArrayPnl,"numeric",'Position',[165 80 50 30],'Value',0,'ValueChangedFcn',@UpdatePillarList);
XcenterLbl= uilabel(ArrayPnl,'Position',[10 115 150 30],'Text','Position Center : Xc','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
XcenterBox= uieditfield(ArrayPnl,"numeric",'Position',[165 115 50 30],'Value',0,'ValueChangedFcn',@UpdatePillarList);
YcenterLbl= uilabel(ArrayPnl,'Position',[220 115 50 30],'Text','Yc','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
YcenterBox= uieditfield(ArrayPnl,"numeric",'Position',[275 115 50 30],'Value',0,'ValueChangedFcn',@UpdatePillarList);


ParamPnl=  uipanel(FigUi,'Position',[10 225 330 115]);
YminLbl= uilabel(ParamPnl,'Position',[10 10 100 30],'Text','Ymin','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
YminBox= uieditfield(ParamPnl,"numeric",'Position',[115 10 50 30],'Value',0,'ValueChangedFcn',@UpdateThreshold);
YmaxLbl= uilabel(ParamPnl,'Position',[170 10 100 30],'Text','Ymax','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
YmaxBox= uieditfield(ParamPnl,"numeric",'Position',[275 10 50 30],'Value',0,'ValueChangedFcn',@UpdateThreshold);
XminLbl= uilabel(ParamPnl,'Position',[10 45 100 30],'Text','Xmin','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
XminBox= uieditfield(ParamPnl,"numeric",'Position',[115 45 50 30],'Value',0,'ValueChangedFcn',@UpdateThreshold);
XmaxLbl= uilabel(ParamPnl,'Position',[170 45 100 30],'Text','Xmax','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
XmaxBox= uieditfield(ParamPnl,"numeric",'Position',[275 45 50 30],'Value',0,'ValueChangedFcn',@UpdateThreshold);
ThresholdLbl= uilabel(ParamPnl,'Position',[5 80 70 30],'Text','Threshold','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
ThresholdBox= uieditfield(ParamPnl,"numeric",'Position',[80 80 30 30],'Value',0,'ValueChangedFcn',@UpdateThreshold);
ErodeLbl= uilabel(ParamPnl,'Position',[125 80 50 30],'Text','Erode','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
ErodeBox= uieditfield(ParamPnl,"numeric",'Position',[170 80 30 30],'Value',0,'ValueChangedFcn',@UpdateThreshold);
MinSizeLbl= uilabel(ParamPnl,'Position',[215 80 50 30],'Text','MinSize','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
MinSizeBox= uieditfield(ParamPnl,"numeric",'Position',[270 80 30 30],'Value',0,'ValueChangedFcn',@UpdateThreshold);
% 
% ThresholdPnl=  uipanel(FigUi,'Position',[10 190 330 60]);
% ThresholdLbl= uilabel(ThresholdPnl,'Position',[10 10 80 40],'Text','Threshold','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
% ThresholdBox= uieditfield(ThresholdPnl,"numeric",'Position',[100 15 60 30],'ValueChangedFcn',@UpdateThreshold);
% ThresholdPlusBtn  = uibutton(ThresholdPnl,'Position',[170 10 30 40],'Text','+10','ButtonPushedFcn',@(btn,event)(IncreaseThreshold(btn,event,+10)));
% ThresholdPlus2Btn  = uibutton(ThresholdPnl,'Position',[205 10 20 40],'Text','+','ButtonPushedFcn',@(btn,event)(IncreaseThreshold(btn,event,+1)));
% ThresholdMinus2Btn  = uibutton(ThresholdPnl,'Position',[230 10 20 40],'Text','-','ButtonPushedFcn',@(btn,event)(IncreaseThreshold(btn,event,-1)));
% ThresholdMinusBtn = uibutton(ThresholdPnl,'Position',[255 10 30 40],'Text','-10','ButtonPushedFcn',@(btn,event)(IncreaseThreshold(btn,event,-10)));



SqSizePnl=  uipanel(FigUi,'Position',[10 345 330 110]);
SqSizeLbl= uilabel(SqSizePnl,'Position',[10 10 80 40],'Text','Boxes Size','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
SqSizeBox= uieditfield(SqSizePnl,"numeric",'Position',[100 15 80 30], 'ValueChangedFcn',@UpdatePlot);
SqSizeChBx = uicheckbox(SqSizePnl,'Text','Activate Squares?','Value',0,'Position',[145 55 150 50],'ValueChangedFcn',@UpdatePlot);


InfoLbl= uilabel(FigUi,'Position',[10 460 330 200],'Text','','BackgroundColor',[0.7 0.7 0.7],'FontWeight','Bold','HorizontalAlignment','Center');
InfoLbl.Text=sprintf('The Goal is do detect as many pillars as possible\n\nTune the "threshold" to obtain the best result\nTune the "Erode parameter" to seperate the pillars \n Tune the "min size" and "max size" to remove noise \n\n When you are happy click on Square button and \n tune  the "square size" to visualize \n only one pillar by square');


%%

 Fig=figure('Position',[750 60 900 900]);
 Fig.DeleteFcn=@ExitDetectPillar;
Ax1=subplot(4,5,[1 2 3 4 6 7 8 9 11 12 13 14 16 17 18 19]);
Ax2=subplot(4,5,[5]);
Ax3=subplot(4,5,[10]);
Ax4=subplot(4,5,[15]);
Ax5=subplot(4,5,[20]);

%% Variable
ImRef=[];
IntMax=NaN;
IntMin=NaN;
ImBw=[];
XYSquare=[];
XYc=[];
XYPillar=[];
XY0=[];

IS='';
Plot11='';
Plot12='';
Plot13='';
Plot21='';
Plot22='';
Plot31='';
Plot32='';
Plot41='';
Plot42='';
Plot51='';
Plot52='';
%% Variable parametring
ThresholdBox.Value=35;
SqSizeBox.Value=27;
SqSizeChBx.Value=0;
ErodeBox.Value=9;
MinSizeBox.Value=12;

Distortion1Box.Value=-0.005;
Distortion2Box.Value=-0.0019;
XcenterBox.Value=0;
YcenterBox.Value=0;
XminBox.Value=1;
YminBox.Value=1;
XmaxBox.Value=1000;
YmaxBox.Value=1000;
DiameterCenterBox.Value=12;
LengthArrayBox.Value=46.5;
AngleArrayBox.Value=0;




%% Run
ReadImage();
ReadData();
PlotImage();
UpdateThreshold();

%% Function


    function PlotImage(varargin)
        Im3=zeros(size(ImBw,1),size(ImBw,2),3);
        Im3(:,:,1)=ImBw*1;
        Im3(:,:,2)=ImBw*1;
        
        Xm=size(ImRef,2)/2;
        Ym=size(ImRef,1)/2;    
        Xmin=XminBox.Value;
        Ymin=XminBox.Value;
        L1=30;
        L2=100;
        
        axes(Ax1);
        imshow((ImRef-IntMin)./(IntMax-IntMin));
        hold on;
        IS=imshow(Im3);
        IS.AlphaData=ImBw*.5;
        Plot11=plot(NaN,NaN,'y');
        Plot12=plot(NaN,NaN,'r');
        Plot13=ploth(NaN,NaN,'b');
        
        
        FAC=3.0;
        axes(Ax2)
        imshow((ImRef-IntMin)./(IntMax-IntMin)*FAC);
        Plot21=ploth(NaN,NaN,'y:');
        Plot22=ploth(NaN,NaN,'r:');

        
        axes(Ax3)
        imshow((ImRef-IntMin)./(IntMax-IntMin)*FAC);
        Plot31=ploth(NaN,NaN,'y');
        Plot32=ploth(NaN,NaN,'r');
        
        axes(Ax4)
        imshow((ImRef-IntMin)./(IntMax-IntMin)*FAC);
        Plot41=ploth(NaN,NaN,'y');
        Plot42=ploth(NaN,NaN,'r');

        axes(Ax5)
        imshow((ImRef-IntMin)./(IntMax-IntMin)*FAC);
        Plot51=ploth(NaN,NaN,'y');
        Plot52=ploth(NaN,NaN,'r');
        
    end
    
    function UpdatePlot(varargin) 
       PlotCircle(XYPillar(:,2),XYPillar(:,1),XYc(:,3),'y',Plot11);
       PlotCircle(XY0(2),XY0(1),DiameterCenterBox.Value,'r',Plot12);
       
       PlotCircle(XYPillar(:,2),XYPillar(:,1),XYc(:,3),'y',Plot21);
       PlotCircle(XY0(2),XY0(1),DiameterCenterBox.Value,'r',Plot22);
       
       PlotCircle(XYPillar(:,2),XYPillar(:,1),XYc(:,3),'y',Plot31);
       PlotCircle(XY0(2),XY0(1),DiameterCenterBox.Value,'r',Plot32);
       
       PlotCircle(XYPillar(:,2),XYPillar(:,1),XYc(:,3),'y',Plot41);
       PlotCircle(XY0(2),XY0(1),DiameterCenterBox.Value,'r',Plot42);
       
       PlotCircle(XYPillar(:,2),XYPillar(:,1),XYc(:,3),'y',Plot51);
       PlotCircle(XY0(2),XY0(1),DiameterCenterBox.Value,'r',Plot52);
       
        Xm=XY0(2);
        Ym=XY0(1);
        Xmin=XminBox.Value;
        Ymin=YminBox.Value;
        L1=SqSizeBox.Value;
        L2=100;
        L3=50;
        
        
        axes(Ax2)
        xlim([Xm-L1 Xm+L1]);
        ylim([Ym-L1 Ym+L1]);
        
        axes(Ax3);
        xlim([Xm Xm+2*L2]);
        ylim([Ym Ym+2*L2]);
        
        axes(Ax4)
        xlim([Xmin Xmin+2*L3]);
        ylim([Ym-L3 Ym+L3]);
        
        axes(Ax5)
        xlim([Xmin Xmin+2*L3]);
        ylim([Ymin Ymin+2*L3]);
        
        UpdateSquarePlot();
        
        figure(Fig);
    end

    function UpdateThreshold(varargin)
               ImBw=ImRef>ThresholdBox.Value; 
               ImBw = bwareaopen(ImBw,500);
               se = strel('disk',2);
               ImBw = imclose(ImBw,se);
               se = strel('disk',ErodeBox.Value);
               ImBw= imerode(ImBw,se);
               ImBw = bwareaopen(ImBw,MinSizeBox.Value);
               
               UpdateImage();
               UpdatePillarList();          
    end
  
    function UpdateImage(varargin)
        Im3=zeros(size(ImBw,1),size(ImBw,2),3);
        Im3(:,:,1)=ImBw*1;
        Im3(:,:,2)=ImBw*1;
        set(IS,'Cdata',Im3,'AlphaData',ImBw*0.5);
    end

    function UpdatePillarList(varargin )
        L=LengthArrayBox.Value;
        XY0=size(ImRef)/2;
        XY0(1)=XY0(1)+YcenterBox.Value;
        XY0(2)=XY0(2)+XcenterBox.Value;
        V1=[1 ;0]*L;
        V2=[1/2 ;1]*L;
        theta=AngleArrayBox.Value*pi/180;
        ROTATION=[cos(theta) -sin(theta); sin(theta) cos(theta) ];
        V1=ROTATION*V1;
        V2=ROTATION*V2;
        
        [Y X]=meshgrid(-30:30,-30:30);
%         [Y,X]=meshgrid(0,0);
        
%         XY0=[1300 1029];
        XYPillar=zeros(size(X,1)*size(X,2),2);
        XYPillar(:,1)=XY0(1)+X(:)*V1(1)+Y(:)*V2(1);
        XYPillar(:,2)=XY0(2)+X(:)*V1(2)+Y(:)*V2(2);
        
        
        [yd,xd]=DistortedPt(XYPillar(:,1),XYPillar(:,2),size(ImRef,1)/2,size(ImRef,2)/2,Distortion1Box.Value,Distortion2Box.Value);
        XYPillar(:,1)=yd;
        XYPillar(:,2)=xd;
        
        Xmin=XminBox.Value;
        Ymin=YminBox.Value;
        Xmax=XmaxBox.Value;
        Ymax=YmaxBox.Value;
        
        FI=find(XYPillar(:,1)>=Ymin & XYPillar(:,2)>=Xmin & XYPillar(:,1)<=Ymax & XYPillar(:,2)<=Xmax);
        XYPillar=XYPillar(FI,1:2);
        ChList=XYPillar(:,1)*0;
        
        XYSquare=zeros(size(XYPillar,1),2,2);
        XYc=zeros(size(XYPillar,1),3);
        SqSize=SqSizeBox.Value;
        for ii=1:size(XYPillar,1)
            
            XYSquare(ii,1,1)=max(round(XYPillar(ii,1))-SqSize,1);
            XYSquare(ii,1,2)=min(round(XYPillar(ii,1))+SqSize,size(ImRef,1));
            XYSquare(ii,2,1)=max(round(XYPillar(ii,2))-SqSize,1);
            XYSquare(ii,2,2)=min(round(XYPillar(ii,2))+SqSize,size(ImRef,2));
            
            XYc(ii,1)=XYPillar(ii,1)-XYSquare(ii,1,1)+1;
            XYc(ii,2)=XYPillar(ii,2)-XYSquare(ii,2,1)+1;
            XYc(ii,3)=DiameterCenterBox.Value;
            
            FI=find(ImBw(XYSquare(ii,1,1):XYSquare(ii,1,2),XYSquare(ii,2,1):XYSquare(ii,2,2))==1);
            if(isempty(FI))
                ChList(ii)=0;
            else
                ChList(ii)=1;
            end
        end
            FI=find(ChList);
            XYPillar=XYPillar(FI,1:2);
            XYSquare=XYSquare(FI,1:2,1:2);
            XYc=XYc(FI,1:3);
            UpdatePlot();
           
    end

     function UpdateSquarePlot(varargin)
         
         if(SqSizeChBx.Value)
             
             
             XYplot=zeros(6*size(XYPillar,1),2);
             for ii=1:size(XYPillar,1)
                 XYplot(6*(ii-1)+1,1:2)=[XYSquare(ii,1,1) XYSquare(ii,2,1) ];
                 XYplot(6*(ii-1)+2,1:2)=[XYSquare(ii,1,1) XYSquare(ii,2,2) ];
                 XYplot(6*(ii-1)+3,1:2)=[XYSquare(ii,1,2) XYSquare(ii,2,2) ];
                 XYplot(6*(ii-1)+4,1:2)=[XYSquare(ii,1,2) XYSquare(ii,2,1) ];
                 XYplot(6*(ii-1)+5,1:2)=[XYSquare(ii,1,1) XYSquare(ii,2,1) ];
                 
                 XYplot(6*(ii-1)+6,1:2)=[NaN NaN ];
             end
             set(Plot13,'Xdata',XYplot(:,2),'Ydata',XYplot(:,1));
         else
             set(Plot13,'Xdata',NaN,'Ydata',NaN);
         end
    end
    
    function ChSqSize(varargin)
        UpdateSquarePlot();
    end
        
    function CheckEnd(btn,event)
        if(length(XYSquare)>0 && length(XYPillar)>0)
            ExitDetectPillar();
        else
            msgbox("Not completed. Impossible to end");
        end;
    end

    function ExitDetectPillar(btn,event)
         SaveData();
         delete(Fig);
         delete(FigUi);      
    end

    function ReadImage()
        ImRef=double(imread(fullfile(FileName,'step1',FrameName,'Pillar_ref.png')));    
        IntMax=max(ImRef(:));
        IntMin=min(ImRef(:));
        ImBw=ImRef*0;
        
        XmaxBox.Value=size(ImRef,2);
        YmaxBox.Value=size(ImRef,1);
        a=1;
    end

    function ReadData()
        FileName2=fullfile(FileName,'step2','pillar.mat');
        if(exist(FileName2,'file'))
            load(FileName2,'Pillar');
       Pillar.Param.SqSize=SqSizeBox.Value;
        
        ThresholdBox.Value=Pillar.Param.Threshold;
        ErodeBox.Value=Pillar.Param.Erode;
        MinSizeBox.Value=Pillar.Param.MinSize;
        XminBox.Value=Pillar.Param.Xmin;
       XmaxBox.Value=Pillar.Param.Xmax;
        YminBox.Value=Pillar.Param.Ymin;
        YmaxBox.Value=Pillar.Param.Ymax;
        
        XcenterBox.Value=Pillar.Param.Xcenter;
        YcenterBox.Value=Pillar.Param.Ycenter;
        DiameterCenterBox.Value=Pillar.Param.Diameter;
        AngleArrayBox.Value=Pillar.Angle;
        
        end
    end

    function SaveData()
        Pillar.Position=XYPillar;
        Pillar.XYSquare=XYSquare;
        Pillar.XYc=XYc;
        
        Pillar.Param.SqSize=SqSizeBox.Value;
        
        Pillar.Param.Threshold=ThresholdBox.Value;
        Pillar.Param.Erode=ErodeBox.Value;
        Pillar.Param.MinSize=MinSizeBox.Value;
        Pillar.Param.Xmin=XminBox.Value;
        Pillar.Param.Xmax=XmaxBox.Value;
        Pillar.Param.Ymin=YminBox.Value;
        Pillar.Param.Ymax=YmaxBox.Value;
        
        Pillar.Param.Xcenter=XcenterBox.Value;
        Pillar.Param.Ycenter=YcenterBox.Value;
        Pillar.Param.Diameter=DiameterCenterBox.Value;
        Pillar.Angle=AngleArrayBox.Value;
        
        
%Pillar.Param.MaxSize=MaxSizeBox.Value;
        [status,msg,msgID] = mkdir(fullfile(FileName,'step2'));
        save(fullfile(FileName,'step2','pillar.mat'),'Pillar');
    end
 end