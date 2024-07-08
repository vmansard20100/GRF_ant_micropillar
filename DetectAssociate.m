function AntArray = DetectAssociate(FileName,FrameName)
% function AntArray = DetectAssociate(FileName,FrameName)
% Function of the Detect step
% Associate the force of each pillar to a specific leg
% Association based on the smallest distance between the leg and the force 

%% Figure
FigUi = uifigure('Name','DetectAssociate by Dorian GAUTIER','Position',[340 60 350 800]);
FigUi.Icon='icon/ant.png';
FigUi.KeyPressFcn=@ReadKeyboard;
FigUi.DeleteFcn=@ExitDetectAnt;

EndBtn= uibutton(FigUi,...
    'Position',[50 70 250 30],...
    'Text','DONE',...
    'ButtonPushedFcn',@(btn,event) CheckEnd(btn));

NextBtn = uibutton(FigUi,...
    'Position',[210 110 90 30],...
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


ForceThresholdPnl=  uipanel(FigUi,'Position',[10 180 330 60]);
ForceThresholdLbl= uilabel(ForceThresholdPnl,'Position',[10 10 110 40],'Text','Force Threshold',...
    'BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
ForceThresholdBox= uieditfield(ForceThresholdPnl,"numeric",'Position',[125 15 70 30], 'ValueChangedFcn',@UpdateAssociate);
ForceThresholdPlusBtn  = uibutton(ForceThresholdPnl,'Position',[200      10 30 40],'Text','++','ButtonPushedFcn',@(btn,event)(IncreaseForceThreshold(btn,event,+0.1)));
ForceThresholdPlusBtn  = uibutton(ForceThresholdPnl,'Position',[200+32*1 10 30 40],'Text','+','ButtonPushedFcn',@(btn,event)(IncreaseForceThreshold(btn,event,+0.01)));
ForceThresholdMinusBtn = uibutton(ForceThresholdPnl,'Position',[200+32*2 10 30 40],'Text','-','ButtonPushedFcn',@(btn,event)(IncreaseForceThreshold(btn,event,-0.01)));
ForceThresholdMinusBtn = uibutton(ForceThresholdPnl,'Position',[200+32*3 10 30 40],'Text','--','ButtonPushedFcn',@(btn,event)(IncreaseForceThreshold(btn,event,-0.1)));

DLimPnl=  uipanel(FigUi,'Position',[10 250 330 60]);
DLimLbl= uilabel(DLimPnl,'Position',[10 10 110 40],'Text','Distance Max',...
    'BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
DLimBox= uieditfield(DLimPnl,"numeric",'Position',[125 15 70 30], 'ValueChangedFcn',@UpdateAssociate);
DLimBtn  = uibutton(DLimPnl,'Position',[200      10 30 40],'Text','+10','ButtonPushedFcn',@(btn,event)(IncreaseDLim(btn,event,+10)));
DLimBtn  = uibutton(DLimPnl,'Position',[200+32*1 10 30 40],'Text','+','ButtonPushedFcn',@(btn,event)(IncreaseDLim(btn,event,+1)));
DLimBtn = uibutton(DLimPnl,'Position',[200+32*2 10 30 40],'Text','-','ButtonPushedFcn',@(btn,event)(IncreaseDLim(btn,event,-1)));
DLimBtn = uibutton(DLimPnl,'Position',[200+32*3 10 30 40],'Text','-10','ButtonPushedFcn',@(btn,event)(IncreaseDLim(btn,event,-10)));



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

AxesBox=axes(Fig,'ButtonDownFcn',@(btn,event)(ClickPillarZero(btn)));



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
ListPillarZero=[];

ImShow=[];
PlotBody=[];
PlotLeg=[];
PlotDetectedForce=gobjects(6,1);
PlotLegForce=gobjects(1);
PlotPillarZero=gobjects(2,1);
%% Run
Ind=1;
ForceThresholdBox.Value=0.25;
DLimBox.Value=100;
ReadData();
SelectTypePlot();
PlotAll();
ReadImage();
UpdateAssociate();

               
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

    function UpdateAssociate(varargin)
        D=zeros(6,1);
        
        for ii=1:Nimage
            FI=find(Movement.Amplitude(ii,:)>=ForceThresholdBox.Value);
            AssoMvt(ii).Position=zeros(length(FI),2);
            AssoMvt(ii).Disp=zeros(length(FI),2);
            AssoMvt(ii).Associate=zeros(length(FI),1);
            
            PositionLeg=reshape(AntArray(ii,3:8,1:2),6,2);
            for jj=1:length(FI)
                AssoMvt(ii).Position(jj,1:2)=reshape(Movement.Position(FI(jj),1:2),1,2);
                AssoMvt(ii).Disp(jj,1:2)=reshape(Movement.Disp(ii,FI(jj),1:2),1,2);
                
                Position=AssoMvt(ii).Position(jj,1:2);
                for kk=1:6
                    D(kk)=sqrt((Position(1)-PositionLeg(kk,2))^2+(Position(2)-PositionLeg(kk,1))^2);
                end
                [MIN,pos]=min(D);
                if(MIN<=DLimBox.Value)
                    AssoMvt(ii).Associate(jj)=pos;
                else
                    AssoMvt(ii).Associate(jj)=0;
                end
            end
            
            for jj=1:6
                FI=find(AssoMvt(ii).Associate==jj);
                TotalLegMvt(jj).Position(ii,1:2)=reshape(AntArray(ii,jj+2,1:2),1,2);
                if(~isempty(FI))
                    TotalLegMvt(jj).Disp(ii,1:2)=sum(AssoMvt(ii).Disp(FI,1:2),1);
                    TotalLegMvt(jj).BaryCenter(ii,1:2)=[NaN NaN];
                else
                    TotalLegMvt(jj).Disp(ii,1:2)=[0 0];
                    TotalLegMvt(jj).BaryCenter(ii,1:2)=[NaN NaN];
                end
            end
        end
        PlotImage();
    end

    function ReadKeyboard(btn,event)
        char=get(btn,'CurrentCharacter');
        switch char
            case 'n'
                Next(btn,event,1)
            case 'v'
                Next(btn,event,-1);
            % case {'1','2','3','4','5','6','7','8'}
                % SetPartSelect(str2num(char));
            otherwise
        end
    end

    function Next(btn,event,Step)
        Ind=max(min(Ind+Step,Nimage),1);
        ReadImage();
        PlotImage();       
    end

    function UpdateFrame(varargin)
    Ind=max(min(FrameBox.Value,Nimage),1);
    ReadImage();
    PlotImage();
    end
    
    function PlotAll(varargin)
        ImShow=imshow([],[0 1],'parent',AxesBox);
        title('','Parent',AxesBox);
        AxesBox.ButtonDownFcn=@(btn,event)(ClickPillarZero(btn));
        ImShow.ButtonDownFcn=@ClickPillarZero;
        hold on
        PlotBody=plot([NaN],[NaN],'g');
        PlotLeg =plot([NaN],[NaN],'c');

        
        symb='x^dv^dv';
        col ='gmmmyyy';
        for ii=1:7
            P=plot([NaN],[1],[symb(ii) col(ii)]);
            PlotDetectedForce(ii)=P;
        end


        PlotLegForce=quiver([NaN],[1],[1],[1],'g','AutoScale','off');
        PlotPillarZero(1)=plot(NaN,1,'r+');
        PlotPillarZero(2)=plot(NaN,1,'ro');
        hold off


        AxesBox.ButtonDownFcn=@(btn,event)(ClickPillarZero(btn));
        ImShow.ButtonDownFcn=@ClickPillarZero;
        PlotBody.ButtonDownFcn=@ClickPillarZero;
        PlotLeg.ButtonDownFcn=@ClickPillarZero;
        for ii=1:7
        PlotDetectedForce(ii).ButtonDownFcn=@ClickPillarZero;
        end
        PlotLegForce.ButtonDownFcn=@ClickPillarZero;
        PlotPillarZero(1).ButtonDownFcn=@ClickPillarZero;
        PlotPillarZero(2).ButtonDownFcn=@ClickPillarZero;
    end

    function PlotImage(varargin)
        FrameBox.Value=Ind;
        ImShow.CData=(Im(:,:)-IntMin)/(IntMax-IntMin);
        hold on;
        DoPlotDetectedForce(Ind);
        DoPlotAnt(Ind);
        DoPlotLegForce(Ind);
        DoPlotPillarZero();
        hold off;
        AxesBox.Title.String=strcat('Frame ',num2str(Ind),'/',num2str(Nimage));
        figure(Fig);
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
                
        PlotAnt(XYBody,XYLeg,PlotBody,PlotLeg); 
        if(~PlotAntChBx.Value) 
            PlotBody.XData=PlotBody.XData*NaN;
            PlotLeg.XData =PlotLeg.XData*NaN;
        end
    end

    function DoPlotDetectedForce(Index)
        for ii=1:7
            FI=find(AssoMvt(Index).Associate==(ii-1));
            PlotDetectedForce(ii).XData=AssoMvt(Index).Position(FI,2);
            PlotDetectedForce(ii).YData=AssoMvt(Index).Position(FI,1);
            if(~PlotDetectedChBx.Value) 
                PlotDetectedForce(ii).XData=PlotDetectedForce(ii).XData*NaN;
            end
        end
    end

    function DoPlotLegForce(Index)
        Position=zeros(6,2);
        Disp=zeros(6,2);
        for ii=1:6
            Position(ii,1:2)=TotalLegMvt(ii).Position(Index,1:2);
            Disp    (ii,1:2)=TotalLegMvt(ii).Disp    (Index,1:2);
        end
        ArrowScale=ArrowScaleBox.Value;
        PlotLegForce.XData=Position(:,1);
        PlotLegForce.YData=Position(:,2);
        PlotLegForce.UData=Disp(:,2)*ArrowScale;
        PlotLegForce.VData=Disp(:,1)*ArrowScale;

        if(~PlotTotalForceChBx.Value)
            PlotLegForce.XData=PlotLegForce.XData*NaN
        end
    end


    function DoPlotPillarZero()
        for ii=1:2
            PlotPillarZero(ii).XData=Movement.Position(ListPillarZero,2);
            PlotPillarZero(ii).YData=Movement.Position(ListPillarZero,1);
        end
    end

   function IncreaseForceThreshold(btn,event,Step)
        ForceThresholdBox.Value=max(ForceThresholdBox.Value+Step,0);
        UpdateAssociate();
    end

    function IncreaseDLim(btn,event,Step)
        DLimBox.Value=max(DLimBox.Value+Step,0);
        UpdateAssociate();
    end

    function ReadImage()
        Im=double(imread(sprintf(NameImage,Ind-1+Nini)));
        Im=Im-ImRef;
        if(isnan(IntMin) || isnan(IntMax))
            IntMax=max(Im(:));
            IntMin=min(Im(:));
        end
    end

    function ClickPillarZero(varargin)
        XX=get(gca,'CurrentPoint');
        X=XX(1,1);
        Y=XX(2,2);

        [MIN,pos]=min(  (Movement.Position(:,2)-X).^2 + (Movement.Position(:,1)-Y).^2);
        if (MIN<50^2)
            FI=find(ListPillarZero==pos);
            if(isempty(FI))
                ListPillarZero=[ListPillarZero pos];
            else
                ListPillarZero=ListPillarZero(ListPillarZero~=pos);
            end
        end

        Movement.Disp=Movement.DispSave;
        Movement.Amplitude=Movement.AmplitudeSave;
        for ii=ListPillarZero
            Movement.Disp(:,ii,1)=0;
            Movement.Disp(:,ii,2)=0;
            Movement.Amplitude(:,ii)=0;
        end
        DoPlotPillarZero();
        UpdateAssociate();
    end

    function ReadData()
        FileName2=fullfile(FileName,'step2',[ 'mvt_' FrameName '.mat']);
        load(FileName2,'Movement');
        Nimage=size(Movement.Amplitude,1);
        



        for ii=1:size(Movement.Disp,1)
            Xm=median(Movement.Disp(ii,:,1));
            Ym=median(Movement.Disp(ii,:,2));
            for jj=1:size(Movement.Disp,2)
                Movement.Disp(ii,jj,1)=Movement.Disp(ii,jj,1)-Xm;
                Movement.Disp(ii,jj,2)=Movement.Disp(ii,jj,2)-Ym;
                Movement.Amplitude(ii,jj)=sqrt(Movement.Disp(ii,jj,1).^2+Movement.Disp(ii,jj,2).^2);
            end
        end
                
        Movement.DispSave=Movement.Disp;
        Movement.AmplitudeSave=Movement.Amplitude;
        
       
        FileName2=fullfile(FileName,'step2',[ 'ant_' FrameName '.mat']);
        load(FileName2,'AntArray');
        
        FileName2=fullfile(FileName,'step2',[ 'TotalMvt_' FrameName '.mat']);
        if(exist(FileName2,'file'))
            load(FileName2,'SortedMvt');
            ForceThresholdBox.Value=SortedMvt.param.ForceThreshold;
            DLimBox.Value=SortedMvt.param.DLim;
        end
    end

    function SaveData()
        SortedMvt.Data=AssoMvt;
        SortedMvt.param.ForceThreshold=ForceThresholdBox.Value;
        SortedMvt.param.DLim=DLimBox.Value;            
        save(fullfile(FileName,'step2',['TotalMvt_' FrameName '.mat']),'TotalLegMvt','SortedMvt');
    end

    function DrawResult(varargin)
        [status,msg,msgID] = mkdir(fullfile(FileName,'step2',sprintf('TotalMvt_%s',FrameName)));
        MessageBox = uiprogressdlg(FigUi,'Title','Please Wait','Message','Drawing Result','Cancelable','on');
        for ii=1:Nimage
            if(MessageBox.CancelRequested==0)
                Ind=ii;
                ReadImage();
                PlotImage();
                FileName2=fullfile(FileName,'step2',sprintf('TotalMvt_%s',FrameName),sprintf('TotalMvt_%s_%0.4d.png',FrameName,ii));
                print(Fig,FileName2,'-dpng','-r200');
                MessageBox.Message= sprintf('Drawing Result - image %d/%d',ii,Nimage);
            end
        end
    end

    function CheckEnd(btn,event)
        ExitDetectAnt()
    end

    function ExitDetectAnt(btn,event)
        SaveData();
        delete(Fig);
        delete(FigUi);
    end
end