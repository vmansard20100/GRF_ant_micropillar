function AnalyseZoomForce(FileName,FrameName)
% AnalyseZoomForce(FileName,FrameName)
% Function of analysis which plot the force zoom on a specific leg


%% Figure Ui
FigUi = uifigure('Name','AntForceZoomAnalysis by Vincent MANSARD','Position',[340 60 350 800]);
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

ForceBg = uibuttongroup   (FigUi,'Position',[10  200     150 110],'SelectionChangedFcn',@UpdatePlotForce);
ForceRb(1) = uiradiobutton(ForceBg,'Position',[10 10+18*2 140 15],'Text','Amplitude');
ForceRb(2) = uiradiobutton(ForceBg,'Position',[10 10+18*1 140 15],'Text','In the u direction');
ForceRb(3) = uiradiobutton(ForceBg,'Position',[10 10+18*0 140 15],'Text','In the v direction');
LegLbl1= uilabel(ForceBg,'Position',[10 80 140 30],'Text','Which Force to plot?',...
    'BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');


PlotPnl=  uipanel(FigUi,'Position',[10 320 330 280]);
PlotForceChBx=uicheckbox(PlotPnl,'Position',[10 5 310 30],'Text','Save Force simulatenously?','Value',0,'ValueChangedFcn',@UpdatePlotImage);
ArrowScaleLbl= uilabel(PlotPnl,'Position',[10 120 80 20],'Text','Arrow Size',...
    'BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
ArrowScaleBox= uieditfield(PlotPnl,"numeric",'Position',[90 120 50 20],'Value',100, 'ValueChangedFcn',@UpdatePlotImage);
ForceConversionLbl= uilabel(PlotPnl,'Position',[140 120 120 20],'Text','F conversion(uN/pix)',...
    'BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
ForceConversionBox= uieditfield(PlotPnl,"numeric",'Position',[260 120 50 20],'Value',5.5, 'ValueChangedFcn',@UpdatePlotForce);
BoxeSizeXLbl= uilabel(PlotPnl,'Position',[10 90 80 20],'Text','Boxe Size X',...
    'BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
BoxeSizeXBox= uieditfield(PlotPnl,"numeric",'Position',[90 90 50 20],'Value',1200, 'ValueChangedFcn',@UpdatePlotImage);
BoxeSizeYLbl= uilabel(PlotPnl,'Position',[140 90 80 20],'Text','Boxe Size Y',...
    'BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
BoxeSizeYBox= uieditfield(PlotPnl,"numeric",'Position',[220 90 50 20],'Value',800, 'ValueChangedFcn',@UpdatePlotImage);
AmplitudeForceLbl= uilabel(PlotPnl,'Position',[10 60 105 20],'Text','Amplitude Force',...
    'BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
AmplitudeForceBox= uieditfield(PlotPnl,"numeric",'Position',[130 60 30 20],'Value',10, 'ValueChangedFcn',@UpdatePlotForce);
FrameRateLbl= uilabel(PlotPnl,'Position',[160 60 105 20],'Text','Frame Rate (fps)',...
    'BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
FrameRateBox= uieditfield(PlotPnl,"numeric",'Position',[265 60 50 20],'Value',62, 'ValueChangedFcn',@UpdatePlotForce);
CutOffLbl= uilabel(PlotPnl,'Position',[10 35 105 20],'Text','Force CutOff (pix)',...
    'BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
CutOffBox= uieditfield(PlotPnl,"numeric",'Position',[130 35 30 20],'Value',0.2, 'ValueChangedFcn',@CutOffForce);
AvgForceLbl= uilabel(PlotPnl,'Position',[160 35 105 20],'Text','Avg Force',...
    'BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
AvgForceBox= uieditfield(PlotPnl,"numeric",'Position',[265 35 30 20],'Value',0, 'ValueChangedFcn',@CutOffForce);
ZoomRotatePlotChBx=uicheckbox(PlotPnl,'Position',[10 135 310 30],'Text','Zoom & rotate image?','Value',1,'ValueChangedFcn',@UpdateTypePlot);

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
InfoLbl.Text=sprintf('Save image and (option) the force graph \n Convention for the force : \n Amplitude (norm value) \n Force u parallele to the ant body (horizontal +=right/-=left) \n Force V hortogonal (vertical +=down/-=up)');

%% Figure
Fig1=figure('Position',[700  60 500 900]);
Fig1.KeyPressFcn=@ReadKeyboard;
Fig1.DeleteFcn=@ExitDetectAnt;

PositionAxesBox=0.06+0.96/6*(0:5);
PositionAxesBox=PositionAxesBox([6 5 4 3 2 1]);
for i=1:6
    % AxesBox1(i)=subplot(6,1,i);
    AxesBox1(i)=subplot('Position',[0.1 PositionAxesBox(i) 0.85 0.9/6-0.02]);
    box on;
end


Fig2=figure('Position', [1200 60 700 450]);
Fig2.KeyPressFcn=@ReadKeyboard;
Fig2.DeleteFcn=@ExitDetectAnt;
AxesBox2=axes(Fig2);%,'ButtonDownFcn',@(btn,event)(ClickAnt(btn)));
%% Variable

AntArray=[];
TotalLegMvt=[];
XYTrajectory=[];
NameImage="";
Nimage=NaN;
Nini=NaN;

ForceX=[];
ForceY=[];
ForceU=[];
ForceV=[];
ForceAmplitude=[];
ForceSave=[];

Step=[];
Rectangle=[];

ImRef=[];
ImRefSave=[];
Im=[];

IntMax =NaN;
IntMin =NaN;
IntMax2=NaN;
IntMin2=NaN;

XYc=[];
XYc2=[];

PlotIm=[];
PlotBody=[];
PlotLeg=[];
PlotQuiver=[];
PlotForce=[];
PlotForcePosition=[];
Ind=1;
Angle=0;

AngleAngle=27.8;
%% Intial action
SelectTypePlot();
ReadData();
ReadImage();
CalculateForce();

PlotAll();
UpdatePlotForce();
UpdatePlotImage();

%% Function

    function CalculateForce(varargin)
        ForceU=zeros(Nimage,6);
        ForceV=ForceU;
        ForceAmplitude=ForceU;

        AvgForceBox.Value=max(round(AvgForceBox.Value),0);
        ForceX=zeros(Nimage,6);
        ForceY=ForceX;
        for jj=1:6
            ForceX(:,jj)=TotalLegMvt(jj).Disp(:,1);
            ForceY(:,jj)=TotalLegMvt(jj).Disp(:,2);
            if(AvgForceBox.Value>0)
                for ii=1:Nimage
                    ForceX(ii,jj)=mean(TotalLegMvt(jj).Disp(max(ii-AvgForceBox.Value,1):min(ii+AvgForceBox.Value,Nimage),1));
                    ForceY(ii,jj)=mean(TotalLegMvt(jj).Disp(max(ii-AvgForceBox.Value,1):min(ii+AvgForceBox.Value,Nimage),2));
                end
            end
        end

        for ii=1:Nimage
            ii
            u(1,1)= AntArray(ii,1,1)-AntArray(ii,2,1);
            u(2,1)=-(AntArray(ii,1,2)-AntArray(ii,2,2));
            u=u./norm(u);
            v=[u(2);-u(1)];

            
            for jj=1:6
                F=[ForceX(ii,jj) ForceY(ii,jj)];
                if(norm(F)>=CutOffBox.Value)
                    ForceU(ii,jj)=F*u;
                    ForceV(ii,jj)=F*v;
                    ForceAmplitude(ii,jj)=norm(F);
                else
                    ForceU(ii,jj)=0;
                    ForceV(ii,jj)=0;
                    ForceAmplitude(ii,jj)=0;
                end
            end

        end
    end

    function CutOffForce(varargin)
        CalculateForce();
        UpdatePlotForce();
        UpdatePlotImage();
    end

    function PlotAll(varargin)
        Label{1}='F (\muN) Front Right';
        Label{2}='F (\muN) Middle Right';
        Label{3}='F (\muN) Back Right';

        Label{4}='F (\muN) Front Left';
        Label{5}='F (\muN) Middle Left';
        Label{6}='F (\muN) Back Left';

        for ii=1:6
            axes(AxesBox1(ii));
            P1(ii)=plot([0],[0],'b-');
            P2(ii)=ploth([0],[NaN],'ro');
            ylabel(Label{ii});
        end
        PlotForce=P1;
        PlotForcePosition=P2;
        axes(AxesBox1(6));
        xlabel('time (s)');

        axes(AxesBox2);
        PlotIm=imshow(Im*0,[0 1],'Border','Tight','InitialMagnification','Fit');
        box on
        PlotBody=ploth(0,0,'c' );
        PlotLeg =ploth(0,0,':m','LineWidth',2);
        hold on
        PlotQuiver=quiver(0,0,0,0,'g','Autoscale','off');
        hold off
    end

    function UpdateTypePlot(varargin)
        SelectTypePlot();
        ReadImage();
        UpdatePlotImage();
    end

    function UpdatePlotForce(varargin)
        switch(ForceBg.SelectedObject.Text)
            case ForceRb(1).Text
                ForceSave=ForceAmplitude;
                Ylim=([0 1]);
            case ForceRb(2).Text
                ForceSave=ForceU;
                Ylim=([-1 1]);
            case ForceRb(3).Text
                ForceSave=ForceV;
                Ylim=([-1 1]);
        end
        
        ForceSave=ForceSave*ForceConversionBox.Value;

        for ii=1:6
            PlotForce(ii).XData=(0:(Nimage-1))/FrameRateBox.Value;
            PlotForce(ii).YData=ForceSave(:,ii);
            AxesBox1(ii).XLim=([0 (Nimage-1)/FrameRateBox.Value]);
            AxesBox1(ii).YLim=(Ylim*AmplitudeForceBox.Value);

            PlotForcePosition(ii).XData=Ind/FrameRateBox.Value;
            if(~isnan(PlotForcePosition(ii).YData))
                PlotForcePosition(ii).YData=ForceSave(Ind,ii);
            end
        end
        PlotRectangle();
    end

    function UpdatePlotImage(varargin)

        PlotIm.CData=(Im-IntMin)/(IntMax-IntMin);
        if(ZoomRotatePlotChBx.Value)
            [Xh,Yh]=RotatePoint(AntArray(Ind,1,1),AntArray(Ind,1,2),1);
            [Xt,Yt]=RotatePoint(AntArray(Ind,2,1),AntArray(Ind,2,2),1);
            Xm=(Xh+Xt)/2;
            Ym=(Yh+Yt)/2;
            AxesBox2.XLim=[-0.5 0.5]*BoxeSizeXBox.Value+Xm;
            AxesBox2.YLim=[-0.5 0.5]*BoxeSizeYBox.Value+Ym;

        else
           Xmin=min(AntArray(:,:,1),[],'all');
           Xmax=max(AntArray(:,:,1),[],'all');

           Ymin=min(AntArray(:,:,2),[],'all');
           Ymax=max(AntArray(:,:,2),[],'all');
           
           AxesBox2.XLim=[Xmin-10 Xmax+10];
           AxesBox2.YLim=[Ymin-10 Ymax+10];
        end

        XYBody=zeros(2,2);
        XYLeg=zeros(6,2);
        
        for ii=1:2
            [XYBody(ii,1),XYBody(ii,2)]=RotatePoint(AntArray(Ind,ii,1),AntArray(Ind,ii,2),1);
        end

        for ii=1:6
            [XYLeg(ii,1),XYLeg(ii,2)]=RotatePoint(AntArray(Ind,ii+2,1),AntArray(Ind,ii+2,2),1);
        end

        PlotAnt(XYBody,XYLeg,PlotBody,PlotLeg);


        PlotQuiver.XData=XYLeg(:,1);
        PlotQuiver.YData=XYLeg(:,2);
        
        if(ZoomRotatePlotChBx.Value)
            PlotQuiver.VData=  (ForceU(Ind,:)*ArrowScaleBox.Value)';
            PlotQuiver.UData= -(ForceV(Ind,:)*ArrowScaleBox.Value)';
        else
            PlotQuiver.VData=(ForceX(Ind,:)*ArrowScaleBox.Value)';
            PlotQuiver.UData=(ForceY(Ind,:)*ArrowScaleBox.Value)';
        end
        
        a=1;

        if(PlotForceChBx.Value)
            for ii=1:6
                PlotForcePosition(ii).XData=(Ind-1)/FrameRateBox.Value;
                PlotForcePosition(ii).YData=ForceSave(Ind,ii);
            end
        else
            for ii=1:6
                PlotForcePosition(ii).YData=NaN;
            end
        end

        FrameBox.Value=Ind;
    end

    function PlotRectangle()
        for ii=1:length(Rectangle)
            delete(Rectangle(ii));
        end

        Time=(0:Nimage)/FrameRateBox.Value;
        Rectangle=gobjects(0);

        for ii=1:6
            Nstep=size(Step{ii},1);
            axes(AxesBox1(ii));
            YLim=AxesBox1(ii).YLim;
            for jj=1:(Nstep)
                Lt=length(Time);
                S1=min(max(1,Step{ii}(jj,1)),Lt);
                S2=min(max(1,Step{ii}(jj,2)),Lt);
                if(S1>1)
                    t1=(Time(S1-1)+Time(S1))/2;
                else
                    t1=Time(S1);
                end

                if(S2<Lt)
                    t2=(Time(S2)+Time(S2+1))/2;
                else
                    t2=Time(S2);
                end
                dt=t2-t1;

                % disp([jj t1 dt])
                    
                R=rectangle('Position',[t1 YLim(1) dt YLim(2)-YLim(1) ],'EdgeColor','none','FaceColor', [1 0 0 0.3]);                
                Rectangle(end+1)=R;
            end
        end
        
    end

    function [X2,Y2]=RotatePoint(X,Y,Direction)
        if(Direction>0)
            R=[cosd(Angle) sind(Angle) ; -sind(Angle) cosd(Angle)];
            A=R*([X;Y]-XYc)+XYc2;
        else
            R=[cosd(-Angle) sind(-Angle) ; -sind(-Angle) cosd(-Angle)];
            A=R*([X;Y]-XYc2)+XYc;
        end
        X2=A(1);
        Y2=A(2);
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

    function ReadData()
        FileName2=fullfile(FileName,'step2',[ 'ant_' FrameName '.mat']);
        load(FileName2,'AntArray');

        FileName2=fullfile(FileName,'step2',[ 'TotalMvt_' FrameName '.mat']);
        load(FileName2,'TotalLegMvt');

        ReadStep();
    end

    function ReadStep()
        FileName2=fullfile(FileName,'step3',[ 'step_' FrameName '.txt']);

        if(exist(FileName2,'file'))
            Step=cell(6,1);

            Fid=fopen(FileName2,'r');
            
            for ii=1:6
                ch=0;
                while(~ch & ~feof(Fid))
                    tline = fgetl(Fid);
                    ch = startsWith(tline,'leg','IgnoreCase',true);
                end
                if(~feof(Fid))
                    Leg=sscanf(tline,'%s %d');
                    Leg=Leg(end);
                    if(Leg>0 & Leg<7)
                        A=fscanf(Fid,'%d %d\n');
                        Step{Leg}=zeros(length(A)/2,2);
                        Step{Leg}(:,1)=A(1:2:end);
                        Step{Leg}(:,2)=A(2:2:end);
                    end

                end
            end
            fclose(Fid);
        else
            Step=cell(6,1);
            
            Fid=fopen(FileName2,'w');
            fprintf(Fid,'// Files to save the the different steps of the ants. You have to write the all the step in the following format. For instance if you notice there is a step between image 4 and 35 and between 48 and 52 for Leg1 you write \n ');
            fprintf(Fid,'// Leg 1\n ');
            fprintf(Fid,'// 2 35\n');
            fprintf(Fid,'// 48 52\n');
            fprintf(Fid,'==============================================\n\n');

            for ii=1:6
                fprintf(Fid,'Leg %d\n\n',ii);
            end
            fclose(Fid);
        end


    end

    function ReadImage()
        Im=double(imread(sprintf(NameImage,Ind-1+Nini)));
        Im=Im-ImRef;
        if(isnan(IntMin) || isnan(IntMax))
            IntMax=max(Im(:));
            IntMin=min(Im(:));
        end


        dX=(AntArray(Ind,1,1)-AntArray(Ind,2,1));
        dY=(AntArray(Ind,1,2)-AntArray(Ind,2,2));
        if(ZoomRotatePlotChBx.Value)
            Angle=angle(dX+1i*dY)*180/pi; 
        else
            Angle=0;
        end

        Im=imrotate(Im,Angle);
        % ImRef=imrotate(ImRefSave,Angle);
        XYc =(size(ImRef)/2)';
        XYc =XYc ([2 1]);
        XYc2=(size(Im)/2)';
        XYc2=XYc2([2 1]);
    end

    function UpdateFrame(varargin)
        Ind=max(min(FrameBox.Value,Nimage),1);
        ReadImage();
        UpdatePlotImage();
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
        UpdatePlotImage();
    end

    function DrawResult(varargin)
        [status,msg,msgID] = mkdir(fullfile(FileName,'step3',sprintf('ZoomForce_%s',FrameName)));
        if(PlotForceChBx.Value)
            [status,msg,msgID] = mkdir(fullfile(FileName,'step3',sprintf('ZoomForce_%s',FrameName),'ForceGraph'));
        end
      
        if(~ZoomRotatePlotChBx.Value)
            [status,msg,msgID] = mkdir(fullfile(FileName,'step3',sprintf('ZoomForce_%s',FrameName),'NoZoom'));
        end
        

        MessageBox = uiprogressdlg(FigUi,'Title','Please Wait','Message','Drawing Result','Cancelable','on');
        for ii=1:Nimage
            if(MessageBox.CancelRequested==0)
                Ind=ii;
                ReadImage();
                UpdatePlotImage();
                % figure(Fig2);
                if(ZoomRotatePlotChBx.Value)
                    FileName2=fullfile(FileName,'step3',sprintf('ZoomForce_%s',FrameName),sprintf('ZoomForce_%s_%0.4d.png',FrameName,ii));
                else
                    FileName2=fullfile(FileName,'step3',sprintf('ZoomForce_%s',FrameName),'NoZoom',sprintf('ZoomForce_%s_%0.4d.png',FrameName,ii));
                end
                print(Fig2,FileName2,'-dpng','-r200');
                if(PlotForceChBx.Value)
                    % figure(Fig1);
                    FileName2=fullfile(FileName,'step3',sprintf('ZoomForce_%s',FrameName),'ForceGraph',sprintf('ForceGraph_%s_%0.4d.png',FrameName,ii));
                    print(Fig1,FileName2,'-dpng','-r100');
                end
                MessageBox.Message= sprintf('Drawing Result - image %d/%d',ii,Nimage);
            end
        end
    end

    function CheckEnd(varargin)
        ExitDetectAnt()
    end

    function ExitDetectAnt(varargin)
        delete(Fig1);
        delete(Fig2);
        delete(FigUi);
    end


end