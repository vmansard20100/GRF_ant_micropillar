function AntArray = AnalyseForce(FileName,FrameName)
%   function AntArray = DetectAnt(ImAll)
% track the body of the ant
% AntArray   contains coordonates of the ant body for every image
% All Images of the body
%% Figure
clc
FigUi = uifigure('Name','AntForcesAnalysis by Dorian GAUTIER','Position',[340 60 350 800]);
FigUi.Icon='icon/ant.png';
FigUi.KeyPressFcn=@ReadKeyboard;
FigUi.DeleteFcn=@ExitDetectAnt;

EndBtn= uibutton(FigUi,...
    'Position',[50 70 250 30],...
    'Text','DONE',...
    'ButtonPushedFcn',@(btn,event) CheckEnd(btn));

NextBtn = uibutton(FigUi,...
    'Position',[220 110 90 30],...
    'Text','Next (n) >>',...
    'ButtonPushedFcn',@(btn,event) Next(btn,event,+1));


PreviousBtn = uibutton(FigUi,...
    'Position',[50 110 90 30],...
    'Text','<< Previous (v)',...
    'ButtonPushedFcn',@(btn,event) Next(btn,event,-1));


FrameLbl= uilabel(FigUi,...
    'Position',[140 112 40 26],...
    'Text','Frame',...
    'BackgroundColor',[0.7 0.7 0.7],'FontWeight','Bold','HorizontalAlignment','Center');

FrameBox= uieditfield(FigUi,"numeric",'Position',[180 112 40 26], 'ValueChangedFcn',@UpdateFrame);


DrawResultBtn= uibutton(FigUi,...
    'Position',[50 145 250 30],...
    'Text','Draw Result (optional)',...
    'ButtonPushedFcn',@(btn,event) DrawResult(btn));

LegBg = uibuttongroup   (FigUi,'Position',[10  200     330 110],'SelectionChangedFcn',@UpdateLeg);   
LegRb(1) = uiradiobutton(LegBg,'Position',[200 10+18*2 100 15],'Text','(1) Top');
LegRb(2) = uiradiobutton(LegBg,'Position',[200 10+18*1 100 15],'Text','(2) Middle');
LegRb(3) = uiradiobutton(LegBg,'Position',[200 10+18*0 100 15],'Text','(3) Bottom');
LegRb(4) = uiradiobutton(LegBg,'Position',[80  10+18*2 100 15],'Text','(4) Top');
LegRb(5) = uiradiobutton(LegBg,'Position',[80  10+18*1 100 15],'Text','(5) Middle');
LegRb(6) = uiradiobutton(LegBg,'Position',[80  10+18*0 100 15],'Text','(6) Bottom');
LegLbl1= uilabel(LegBg,'Position',[10 80 310 30],'Text','Which Leg?',...
     'BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
 LegLbl2= uilabel(LegBg,'Position',[10 55 310 30],'Text','Left         /Head\         Right',...
     'BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');

PlotPnl=  uipanel(FigUi,'Position',[10 320 330 280]);
PlotDetectedChBx =uicheckbox(PlotPnl,'Position',[10 10 310 30],'Text','Plot Associated Pillar?','Value',1,'ValueChangedFcn',@PlotImage);
PlotAntChBx       =uicheckbox(PlotPnl,'Position',[10 45 310 30],'Text','Plot Ant?','Value',1,'ValueChangedFcn',@PlotImage);
PlotTotalForceChBx=uicheckbox(PlotPnl,'Position',[10 80 310 30],'Text','Plot Total Force?','Value',1,'ValueChangedFcn',@PlotImage);
ArrowScaleLbl= uilabel(PlotPnl,'Position',[10 115 110 40],'Text','Size of the Arrow',...
    'BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
ArrowScaleBox= uieditfield(PlotPnl,"numeric",'Position',[125 120 70 30],'Value',10, 'ValueChangedFcn',@PlotImage);


TypePlotBg = uibuttongroup(PlotPnl,'Position',[10 165 310 105],'SelectionChangedFcn',@UpdateTypePlot);   
TypePlotRb(1) = uiradiobutton(TypePlotBg,'Position',[10 10+18*3 290 15],'Text','From Top Standard');
TypePlotRb(2) = uiradiobutton(TypePlotBg,'Position',[10 10+18*2 290 15],'Text','From Bottom Standard');
TypePlotRb(3) = uiradiobutton(TypePlotBg,'Position',[10 10+18*1 290 15],'Text','From Top Differential');
TypePlotRb(4) = uiradiobutton(TypePlotBg,'Position',[10 10      290 15],'Text','From Bottom Differential');
ArrowScaleLbl= uilabel(TypePlotBg,'Position',[10 75 290 30],'Text','Which type of background?',...
     'BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');



InfoLbl= uilabel(FigUi,...
    'Position',[50 670 250 120],...
    'Text','',...
    'BackgroundColor',[0.7 0.7 0.7],'FontWeight','Bold','HorizontalAlignment','Center');
InfoLbl.Text=sprintf('Check how the Pillar movements \n are associated to the legs \n\nUse Keyboard\n(v or n) to change image\n\n Data saved in "TotalMvt_Frame*-*.mat"\n under the variable "TotalLegMvt"'); 



Fig=figure('Position',[750 60 900 900]);
Fig.KeyPressFcn=@ReadKeyboard;
Fig.DeleteFcn=@ExitDetectAnt;

Ax1=subplot(4,2,[ 1 3 5 ]);
ImPlot1=imshow(zeros(10));
hold on
Plot11=plot(NaN,NaN,':c');
Plot12=plot(NaN,NaN,'-c');
Plot13=plot(NaN,NaN,'oy');
Quiver1=quiver(1,1,1,1,'g','AutoScale','off');
% Plot14=plot(NaN,NaN,'b');
hold off
Title1=title('No Image Yet');

Ax2=subplot(4,2,[ 2 4 6 ]);
ImPlot2=imshow(zeros(10));
hold on
Plot21=plot(NaN,NaN,':c');
Plot22=plot(NaN,NaN,'-c');
Plot23=plot(NaN,NaN,'xy');
Quiver2=quiver(1,1,1,1,'g','AutoScale','off');
              
hold off
Title2=title('Leg - ??');

Ax3=subplot(4,2,[ 7 8 ]);
Plot31=plot(1,1);
hold on
Plot32=plot([0 0],[NaN NaN],'k');
hold off

%% Variable
NameImage='';
Nini=NaN;
Nimage=NaN;
IntMax=NaN;
IntMin=NaN;
IntMaxRef=NaN;
IntMinRef=NaN;
Im=[];
ImRef=[];
AntArray=[];
Movement=[];
Ind=NaN;
PartSelect=NaN;
AssoMvt=[];
TotalLegMvt=[];
Leg=1;


%% Run
Ind=1;
ForceThresholdBox.Value=0.25;
DLimBox.Value=100;
ReadData();
SelectTypePlot();
ReadImage();
PlotImage();

               
    function UpdateTypePlot(varargin)
        SelectTypePlot();
        ReadImage();
        PlotImage();
    end

    function SelectTypePlot(varargin)
        switch(TypePlotBg.SelectedObject.Text)
            
            case TypePlotRb(1).Text
                ImRef=double(imread(fullfile(FileName,'step1',FrameName,'Ant_ref.png')));
                ImRef=ImRef*0;
                [NameImage,Nini,Nimage]= vm_ListAllImage(fullfile(FileName,'step1',FrameName,'Ant','Ant*.png'));
                IntMin=NaN;
            case TypePlotRb(2).Text
                ImRef=double(imread(fullfile(FileName,'step1',FrameName,'Pillar_ref.png')));
                ImRef=ImRef*0;
                [NameImage,Nini,Nimage]= vm_ListAllImage(fullfile(FileName,'step1',FrameName,'Pillar','Pillar*.png'));
                IntMin=NaN;
            case TypePlotRb(3).Text
                ImRef=double(imread(fullfile(FileName,'step1',FrameName,'Ant_ref.png')));
                ImRef=ImRef;
                [NameImage,Nini,Nimage]= vm_ListAllImage(fullfile(FileName,'step1',FrameName,'Ant','Ant*.png'));
                IntMin=-50; IntMax=50;
            case TypePlotRb(4).Text
                ImRef=double(imread(fullfile(FileName,'step1',FrameName,'Pillar_ref.png')));
                [NameImage,Nini,Nimage]= vm_ListAllImage(fullfile(FileName,'step1',FrameName,'Pillar','Pillar*.png'));
                IntMin=-12; IntMax=12;
        end

    end
    
    function UpdateLeg(varargin)
        SelectLeg();
        PlotImage();
    end

    function SelectLeg(varargin) 
    Leg=1;
    for ii=1:6
        if(strcmp(LegBg.SelectedObject.Text,LegRb(ii).Text))
            Leg=ii;
        end
    end
    end

    function UpdateFrame(varargin)
    Ind=max(min(FrameBox.Value,Nimage),1);
    ReadImage();
    PlotImage();
    end
    
    function ReadKeyboard(btn,event)
        char=get(btn,'CurrentCharacter');
        switch char
            case 'n'
                Next(btn,event,1)
            case 'v'
                Next(btn,event,-1);
            otherwise
        end
    end

    function Next(btn,event,Step)
        Ind=max(min(Ind+Step,Nimage),1);
        ReadImage();
        PlotImage();       
    end

    function PlotImage(varargin)
        FrameBox.Value=Ind;
        ImPlot1.CData=(Im-IntMin)/(IntMax-IntMin);
        ImPlot2.CData=(Im-IntMin)/(IntMax-IntMin);
        DoPlotAnt(Ind); 
        PlotLegForce(Ind);
        Ax1.XLim= [1 size(Im,2)];
        Ax1.YLim= [1 size(Im,1)];
        
        Xleg=TotalLegMvt(Leg).Position(Ind,1);
        Yleg=TotalLegMvt(Leg).Position(Ind,2);
        
        Plot13.XData=Xleg;
        Plot13.YData=Yleg;
        
%         Plot23.XData=Xleg;
%         Plot23.YData=Yleg;        
        
        SizeFrame=100;
        Ax2.XLim= [Xleg-SizeFrame Xleg+SizeFrame];
        Ax2.YLim= [Yleg-SizeFrame Yleg+SizeFrame];
        
        
        Title1.String=strcat('Frame ',num2str(Ind),'/',num2str(Nimage));
        Title2.String=sprintf('Leg %d',Leg);
        
        Plot31.XData=1:Nimage;
        Plot31.YData=sqrt(TotalLegMvt(Leg).Disp(:,1).^2+TotalLegMvt(Leg).Disp(:,2).^2);
        Plot32.XData=[Ind Ind]; 
        Plot32.YData=[NaN NaN];
        Plot32.YData=Ax3.YLim;
        
        figure(Fig);
    end

    function DoPlotAnt(Index)
    
    if(PlotAntChBx.Value)
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

        PlotAnt(XYBody,XYLeg,Plot12,Plot11); 
        PlotAnt(XYBody,XYLeg,Plot22,Plot21); 
        
        % Xm=(Xh+Xt)/2;
        % X=[Xh  Xt  Xm  Xr1  Xm  Xr2 Xm Xr3  Xm  Xl1  Xm  Xl2  Xm  Xl3];
        % 
        % Plot11.XData=X(1,:);
        % Plot11.YData=X(2,:);
        % 
        % Plot21.XData=X(1,:);
        % Plot21.YData=X(2,:);
        % 
        % X=[Xh Xt];
        % Plot12.XData=X(1,:);
        % Plot12.YData=X(2,:);
        % 
        % Plot22.XData=X(1,:);
        % Plot22.YData=X(2,:);        
    else
        Plot11.YData=Plot11.YData*NaN;
        Plot12.YData=Plot12.YData*NaN;
        Plot21.YData=Plot21.YData*NaN;
        Plot22.YData=Plot22.YData*NaN;
    end
    
    end

    function PlotLegForce(Index)
        if(PlotTotalForceChBx.Value)
            X=zeros(6,1);
            Y=X;
            U=X;
            V=X;
            for ii=1:6
                X(ii)=TotalLegMvt(ii).Position(Index,1);
                Y(ii)=TotalLegMvt(ii).Position(Index,2);
                U(ii)=TotalLegMvt(ii).Disp(Index,2);
                V(ii)=TotalLegMvt(ii).Disp(Index,1);
            end;
            Quiver1.XData=X;
            Quiver1.YData=Y;
            Quiver1.UData=U*ArrowScaleBox.Value;
            Quiver1.VData=V*ArrowScaleBox.Value;
            
            Quiver2.XData=X;
            Quiver2.YData=Y;
            Quiver2.UData=U*ArrowScaleBox.Value;
            Quiver2.VData=V*ArrowScaleBox.Value;   
        else
            Quiver1.UData=Quiver1.UData*NaN;
            Quiver2.UData=Quiver2.UData*NaN;
        end
    
    end

    function ReadImage()
        Im=double(imread(sprintf(NameImage,Ind-1+Nini)));
        Im=Im-ImRef;
        if(isnan(IntMin) || isnan(IntMax))
            IntMax=max(Im(:));
            IntMin=min(Im(:));
        end
    end

    function ReadData()
        FileName2=fullfile(FileName,'step2',[ 'TotalMvt_' FrameName '.mat']);
        load(FileName2,'TotalLegMvt');
        
        FileName2=fullfile(FileName,'step2',[ 'ant_' FrameName '.mat']);
        load(FileName2,'AntArray');
    end

    function DrawResult(varargin)
        [status,msg,msgID] = mkdir(fullfile(FileName,'step3',sprintf('TotalMvt_%s_Leg_%d',FrameName,Leg)));
        MessageBox = uiprogressdlg(FigUi,'Title','Please Wait','Message','Drawing Result','Cancelable','on');
        for ii=1:Nimage
            if(MessageBox.CancelRequested==0)
                Ind=ii;
                ReadImage();
                PlotImage();
                FileName2=fullfile(FileName,'step3',sprintf('TotalMvt_%s_Leg_%d',FrameName,Leg),sprintf('TotalMvt_%s__Leg_%d_%0.4d.png',FrameName,Leg,ii));
                print(Fig,FileName2,'-dpng','-r200');
                MessageBox.Message= sprintf('Drawing Result - image %d/%d',ii,Nimage);
            end
        end
    end

    function CheckEnd(btn,event)
        ExitDetectAnt()
    end

    function ExitDetectAnt(btn,event)
        delete(Fig);
        delete(FigUi);
    end
 end