function AnalyseStepCalculation(FileName,FrameName)
% AnalyseStepCalculation(FileName,FrameName)
% Function of Anlysis


%% Figure Ui
FigUi = uifigure('Name','AnalyseStepCalculation by Vincent MANSARD','Position',[340 60 350 800]);
FigUi.Icon='icon/ant.png';
FigUi.DeleteFcn=@ExitDetectAnt;

EndBtn= uibutton(FigUi,...
    'Position',[50 70 250 30],...
    'Text','DONE',...
    'ButtonPushedFcn',@(btn,event) CheckEnd(btn));


ReadStepBtn= uibutton(FigUi,...
    'Position',[10 105 160 30],...
    'Text','Load Step File',...
    'ButtonPushedFcn',@(btn,event)ReadStep(btn));

CalculateStepBtn= uibutton(FigUi,...
    'Position',[175 105 160 30],...
    'Text','Calculate Step',...
    'ButtonPushedFcn',@(btn,event)UpdateCalulateStep(btn));



DrawResultBtn= uibutton(FigUi,...
    'Position',[50 140 250 30],...
    'Text','Save Figure (optional)',...
    'ButtonPushedFcn',@(btn,event) DrawResult(btn));

ForceBg = uibuttongroup   (FigUi,'Position',[10  200     150 110],'SelectionChangedFcn',@UpdatePlotForce);
ForceRb(1) = uiradiobutton(ForceBg,'Position',[10 10+18*2 140 15],'Text','Amplitude');
ForceRb(2) = uiradiobutton(ForceBg,'Position',[10 10+18*1 140 15],'Text','In the u direction');
ForceRb(3) = uiradiobutton(ForceBg,'Position',[10 10+18*0 140 15],'Text','In the v direction');
LegLbl1= uilabel(ForceBg,'Position',[10 80 140 30],'Text','Which Force to plot?',...
    'BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');


PlotPnl=  uipanel(FigUi,'Position',[10 320 330 280]);
DStepMaxLbl= uilabel(PlotPnl,'Position',[10 120 130 20],'Text','Max Dist for step(pix)',...
    'BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
DStepMaxBox= uieditfield(PlotPnl,"numeric",'Position',[140 120 50 20],'Value',30, 'ValueChangedFcn',@UpdateCalulateStep);
NFrameMinLbl= uilabel(PlotPnl,'Position',[195 120 80 20],'Text','#Min frame',...
    'BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
NFrameMinBox= uieditfield(PlotPnl,"numeric",'Position',[280 120 40 20],'Value',10, 'ValueChangedFcn',@UpdateCalulateStep);

ForceConversionLbl= uilabel(PlotPnl,'Position',[10 85 120 20],'Text','F conversion(uN/pix)',...
    'BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
ForceConversionBox= uieditfield(PlotPnl,"numeric",'Position',[130 85 50 20],'Value',5.5, 'ValueChangedFcn',@UpdatePlotForce);
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

TypePlotBg = uibuttongroup(PlotPnl,'Position',[10 165 310 105],'SelectionChangedFcn',@UpdateTypePlot);
TypePlotRb(1) = uiradiobutton(TypePlotBg,'Position',[10 10+18*3 290 15],'Text','By side');
TypePlotRb(2) = uiradiobutton(TypePlotBg,'Position',[10 10+18*2 290 15],'Text','By tripod');
TypePlotLbl= uilabel(TypePlotBg,'Position',[10 75 290 30],'Text','How to group legs?',...
    'BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');



InfoLbl= uilabel(FigUi,...
    'Position',[50 670 250 120],...
    'Text','',...
    'BackgroundColor',[0.7 0.7 0.7],'FontWeight','Bold','HorizontalAlignment','Center');
InfoLbl.Text=sprintf('Some info here');

%% Figure
Fig1=figure('Position',[700  60 500 900]);
% Fig1.KeyPressFcn=@ReadKeyboard;
Fig1.DeleteFcn=@ExitDetectAnt;

PositionAxesBox=0.06+0.96/6*(0:5);
PositionAxesBox=PositionAxesBox([6 5 4 3 2 1]);
for i=1:6
    % AxesBox1(i)=subplot(6,1,i);
    AxesBox1(i)=subplot('Position',[0.1 PositionAxesBox(i) 0.85 0.9/6-0.02]);
    box on;
end


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

PlotForce=[];
Ind=1;

%% Intial action

ReadData();
CalculateForce();
CalculateStep();

PlotAll();
UpdatePlotForce();


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
            u(1,1)=AntArray(ii,1,1)-AntArray(ii,2,1);
            u(2,1)=AntArray(ii,1,2)-AntArray(ii,2,2);

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

    function CalculateStep(varargin)
        dStepMax=DStepMaxBox.Value;
        NFrameMin=NFrameMinBox.Value;
        Step=cell(6,1);
        for ii=1:6
            Xl=AntArray(:,ii+2,1);
            Yl=AntArray(:,ii+2,2);
            Nstep=0;

            jj=1;
            while(jj<Nimage)

                ch=1;
                kk=jj+1;
                NFrame=1;
                Xm=Xl(jj);
                Ym=Yl(jj);

                while(ch && kk<=Nimage)

                    dStep=sqrt( (Xl(kk)-Xm ).^2 + (Yl(kk)-Ym).^2 );
                    if(dStep<dStepMax)
                        ch=1;
                        % Xm=(Xm*Nstep+Xl(kk))/(Nstep+1);
                        % Ym=(Ym*Nstep+Yl(kk))/(Nstep+1);
                        NFrame=NFrame+1;
                        kk=kk+1;
                    else
                        ch=0;
                    end
                end

                if(NFrame>=NFrameMin)
                    Nstep=Nstep+1;
                    Step{ii}(Nstep,[1 2])=[jj kk-1];
                end
                jj=kk;
            end
        end
    end

    function CutOffForce(varargin)
        CalculateForce();
        UpdatePlotForce();
    end

    function PlotAll(varargin)

        Label{1}='F (\muN) R1';
        Label{2}='F (\muN) R2';
        Label{3}='F (\muN) R3';

        Label{4}='F (\muN) L1';
        Label{5}='F (\muN) L2';
        Label{6}='F (\muN) L3';

        for ii=1:6
            axes(AxesBox1(ii));
            P1(ii)=plot([0],[0],'b-');
            ylabel(Label{ii});
        end
        PlotForce=P1;
        axes(AxesBox1(6));
        xlabel('time (s)');
    end

    function UpdateTypePlot(varargin)

        PositionAxesBox=0.06+0.96/6*(0:5);

        switch(TypePlotBg.SelectedObject.Text)
            case TypePlotRb(1).Text

                PositionAxesBox=PositionAxesBox([6 5 4 3 2 1]);

            case TypePlotRb(2).Text
                PositionAxesBox=PositionAxesBox([6 2 4 3 5 1]);

        end

        for ii=1:6
            AxesBox1(ii).Position=[0.1 PositionAxesBox(ii) 0.85 0.9/6-0.02];
        end

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
        end
        PlotRectangle();
    end

    function UpdateCalulateStep(varargin)
        CalculateStep();
        UpdatePlotForce();
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

                if(ii<=3)
                    FaceColor= [1 0 0 0.3];
                else
                    FaceColor= [0 0 1 0.2];
                end
                R=rectangle('Position',[t1 YLim(1) dt YLim(2)-YLim(1) ],'EdgeColor','none','FaceColor', FaceColor);
                Rectangle(end+1)=R;
            end
        end

    end

    function ReadData()
        FileName2=fullfile(FileName,'step2',[ 'ant_' FrameName '.mat']);
        load(FileName2,'AntArray');

        FileName2=fullfile(FileName,'step2',[ 'TotalMvt_' FrameName '.mat']);
        load(FileName2,'TotalLegMvt');

        Nimage=size(AntArray,1);
        % ReadStep();
    end

    function ReadStep(varargin)
        FileName2=fullfile(FileName,'step3',[ 'step_' FrameName '.txt']);

        if(exist(FileName2,'file'))
            Step=cell(6,1);

            Fid=fopen(FileName2,'r');

            for ii=1:6
                ch=0;
                while(~ch & ~feof(Fid))
                    tline = fgetl(Fid)
                    ch = startsWith(tline,'leg','IgnoreCase',true);
                end
                a=1;
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
            UpdatePlotForce();
        end
    end

    function WriteResult(varargin)
        FileName2=fullfile(FileName,'step3',[ 'step_' FrameName '.txt']);
        ch=0;
        if(exist(FileName2,'File'))
            answer = questdlg('Would you like to overwrite the step?','Overwrite?','Yes','No','No');
            switch answer
                case 'Yes'
                    ch=1;
                case 'No'
                    ch=0;
            end
        else
            ch=1;
        end
        if(ch==1)
            Fid=fopen(FileName2,'w');
            fprintf(Fid,'// Files to save the the different steps of the ants. You have to write the all the step in the following format. For instance if you notice there is a step between image 4 and 35 and between 48 and 52 for Leg1 you write \n ');
            fprintf(Fid,'// Leg 1\n ');
            fprintf(Fid,'// 2 35\n');
            fprintf(Fid,'// 48 52\n');
            fprintf(Fid,'==============================================\n\n');

            for ii=1:6
                fprintf(Fid,'Leg %d\n',ii);
                for jj=1:size(Step{ii},1)
                    fprintf(Fid,'%d %d\n',Step{ii}(jj,1),Step{ii}(jj,2));
                end
                fprintf(Fid,'\n');

            end
            fclose(Fid);
        end

    end

    function DrawResult(varargin)
        FileName2=fullfile(FileName,'step3',sprintf('ForceGraph_%s.png',FrameName));
        print(Fig1,FileName2,'-dpng','-r200');
    end

    function CheckEnd(varargin)
        WriteResult();
        ExitDetectAnt()
    end

    function ExitDetectAnt(varargin)
        delete(Fig1);
        delete(FigUi);
    end


end