function AntArray = DetectAnt(FileName,FrameName)
%   function AntArray = DetectAnt(ImAll)
% track the body of the ant
% AntArray   contains coordonates of the ant body for every image
% All Images of the body

%% Figure
FigUi = uifigure('Name','DetectAnt by Dorian GAUTIER','Position',[30 70 350 800]);
FigUi.Icon='icon/ant.png';
FigUi.KeyPressFcn=@ReadKeyboard;
FigUi.DeleteFcn=@ExitDetectAnt;

EndBtn= uibutton(FigUi,...
    'Position',[50 10 250 30],...
    'Text','DONE',...
    'ButtonPushedFcn',@(btn,event) CheckEnd(btn));


StepSizeLbl= uilabel(FigUi,...
    'Position',[50 80 100 26],...
    'Text','Step Size',...
    'BackgroundColor',[0.7 0.7 0.7],'FontWeight','Bold','HorizontalAlignment','Center');
StepSizeBox= uieditfield(FigUi,"numeric",'Position',[150 80 40 26],'Value',5,'Limits',[1 200],'RoundFractionalValues','on');


NextBtn = uibutton(FigUi,...
    'Position',[220 50 90 30],...
    'Text','Next (b> n>>)',...
    'ButtonPushedFcn',@(btn,event) Next(btn,event,+StepSizeBox.Value));


PreviousBtn = uibutton(FigUi,...
    'Position',[30 50 110 30],...
    'Text','Previous (<<x <c)',...
    'ButtonPushedFcn',@(btn,event) Next(btn,event,-StepSizeBox.Value));


FrameLbl= uilabel(FigUi,...
    'Position',[140 52 40 26],...
    'Text','Frame',...
    'BackgroundColor',[0.7 0.7 0.7],'FontWeight','Bold','HorizontalAlignment','Center');

FrameBox= uieditfield(FigUi,"numeric",'Position',[180 52 40 26], 'ValueChangedFcn',@UpdateFrame);







SelectBtn(1)= uibutton(FigUi,...
    'Position',[140 235 70 50],...
    'Text','Head (1)',...
    'ButtonPushedFcn',@(btn,event) ClickSelect(btn));

SelectBtn(2)= uibutton(FigUi,...
    'Position',[140 110 70 50],...
    'Text','Tail (2)',...
    'ButtonPushedFcn',@(btn,event) ClickSelect(btn));

SelectBtn(3)= uibutton(FigUi,...
    'Position',[220 225 70 50],...
    'Text','RF leg(3)',...
    'ButtonPushedFcn',@(btn,event) ClickSelect(btn));

SelectBtn(4)= uibutton(FigUi,...
    'Position',[220 170 70 50],...
    'Text','RM leg (4)',...
    'ButtonPushedFcn',@(btn,event) ClickSelect(btn));

SelectBtn(5)= uibutton(FigUi,...
    'Position',[220 115 70 50],...
    'Text','RB Leg (5)',...
    'ButtonPushedFcn',@(btn,event) ClickSelect(btn));

SelectBtn(6)= uibutton(FigUi,...
    'Position',[60 225 70 50],...
    'Text','LF Leg (6)',...
    'ButtonPushedFcn',@(btn,event) ClickSelect(btn));

SelectBtn(7)= uibutton(FigUi,...
    'Position',[60 170 70 50],...
    'Text','LM Leg (7)',...
    'ButtonPushedFcn',@(btn,event) ClickSelect(btn));

SelectBtn(8)= uibutton(FigUi,...
    'Position',[60 115 70 50],...
    'Text','LB Leg (8)',...
    'ButtonPushedFcn',@(btn,event) ClickSelect(btn));




StepTypeBG=uibuttongroup(FigUi,'Position',[60 290 230 70],'SelectionChangedFcn',@UpdateStep);
StepTypeRB(1)=uiradiobutton(StepTypeBG,'Position',[10  10 100 20],'Text','(1) Head/Tail');
StepTypeRB(2)=uiradiobutton(StepTypeBG,'Position',[120 10 100 20],'Text','(2) 6 Legs');
StepTypeLbl= uilabel(StepTypeBG,'Position',[10 10+22*1 210 30],'Text','Which steps ?','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');

TypePlotBg = uibuttongroup(FigUi,'Position',[5 370 150 105],'SelectionChangedFcn',@UpdateTypePlot);
TypePlotLbl   = uilabel      (TypePlotBg,'Position',[10 10+18*3+14 140 30],'Text','Which main image?','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
TypePlotRb(1) = uiradiobutton(TypePlotBg,'Position',[10 10+18*3 140 15],'Text','Top Standard');
TypePlotRb(2) = uiradiobutton(TypePlotBg,'Position',[10 10+18*2 140 15],'Text','Bottom Standard');
TypePlotRb(3) = uiradiobutton(TypePlotBg,'Position',[10 10+18*1 140 15],'Text','Top Differential');
TypePlotRb(4) = uiradiobutton(TypePlotBg,'Position',[10 10      140 15],'Text','Bottom Differential');

TypePlotBg2 = uibuttongroup(FigUi,'Position',[160 370 180 105],'SelectionChangedFcn',@UpdateTypePlot);
TypePlotLbl2   = uilabel      (TypePlotBg2,'Position',[5 10+18*3+14 170 30],'Text','Which secondary image?','BackgroundColor','none','FontWeight','Bold','HorizontalAlignment','Center');
TypePlotRb2(1) = uiradiobutton(TypePlotBg2,'Position',[10 10+18*3 140 15],'Text','Top Standard');
TypePlotRb2(2) = uiradiobutton(TypePlotBg2,'Position',[10 10+18*2 140 15],'Text','Bottom Standard');
TypePlotRb2(3) = uiradiobutton(TypePlotBg2,'Position',[10 10+18*1 140 15],'Text','Top Differential');
TypePlotRb2(4) = uiradiobutton(TypePlotBg2,'Position',[10 10      140 15],'Text','Bottom Differential');


BoxeSizeXLbl= uilabel(FigUi,'Position',[10 480 100 26],'Text','Zoom size X','BackgroundColor',[0.7 0.7 0.7],'FontWeight','Bold','HorizontalAlignment','Center');
BoxeSizeXBox= uieditfield(FigUi,"numeric",'Position',[110 480 40 26],'Value',1200,'Limits',[1 2000],'RoundFractionalValues','on','ValueChangedFcn',@UpdatePlotImage);
BoxeSizeYLbl= uilabel(FigUi,'Position',[160 480 100 26],'Text','Zoom size Y','BackgroundColor',[0.7 0.7 0.7],'FontWeight','Bold','HorizontalAlignment','Center');
BoxeSizeYBox= uieditfield(FigUi,"numeric",'Position',[260 480 40 26],'Value',800,'Limits',[1 2000],'RoundFractionalValues','on','ValueChangedFcn',@UpdatePlotImage);


CompleteGapBtn= uibutton(FigUi,'Position',[30 520 280 30],'Text','Complete Gap','ButtonPushedFcn',@CompleteGap);



InfoLbl= uilabel(FigUi,...
    'Position',[10 560 330 80],...
    'Text','',...
    'BackgroundColor',[0.7 0.7 0.7],'FontWeight','Bold','HorizontalAlignment','Center');



InfoLbl.Text=sprintf('Click successively on Head / Tail / 6 Legs\nUse Keyboard:\n(w or c) to change image\n (1-8) to change Ant Part');




%%
Fig=figure('Position',[450 50 1400 900]);
Fig.KeyPressFcn=@ReadKeyboard;
Fig.DeleteFcn=@ExitDetectAnt;

AxesBox(1)=axes(Fig,...
    'ButtonDownFcn',@(btn,event)(ClickAnt(btn)),'XTick',[],'YTick',[],'InnerPosition',[0.01 0.01 0.7 0.98]);

AxesBox(2)=axes(Fig,...
    'ButtonDownFcn',@(btn,event)(ClickAnt(btn)),'XTick',[],'YTick',[],'InnerPosition',[0.72 0.225 0.27 0.27]);

AxesBox(3)=axes(Fig,...
    'ButtonDownFcn',@(btn,event)(ClickAnt(btn)),'XTick',[],'YTick',[],'InnerPosition',[0.72 0.505 0.27 0.27]);
%% Variable
Nimage=NaN;
IntMax=NaN;
IntMin=NaN;
IntMax2=NaN;
IntMin2=NaN;
Im=[];
Im2=[];
ImRef=[];
ImRef2=[];

AntArray=[];
Ind=NaN;
PartSelect=NaN;
NameImage='';
NameImage2='';
Nini=NaN;
PlotIm=[];
PlotAnt=[];
Step=NaN;
Angle=NaN;
XYc =[NaN;NaN];
XYc2=[NaN;NaN];
ZoomSize=100;
% ImZoom=zeros(ZoomSize);

%% Run
Ind=1;
Step=1;
SelectTypePlot();
ReadImage();
ReadData();
SetPartSelect(1);
PlotAll();
UpdateStep();


    function Next(btn,event,NStep)
        IndSave=Ind;
        Ind=Ind+(NStep);
        if(Ind>Nimage)
            if(IndSave==Nimage)
                Ind=1;
            else
                Ind=Nimage;
            end
        elseif(Ind<=0)
            if(IndSave==1)
                Ind=Nimage;
            else
                Ind=1;
            end
        end

        switch Step
            case 1
                % SetPartSelect(1);
            case 2
                % SetPartSelect(3);
        end
        ReadImage();
        UpdatePlotImage();
        UpdatePlotAllAnt();
    end

    function UpdateFrame(varargin)
        Ind=max(min(FrameBox.Value,Nimage),1);
        switch Step
            case 1
                SetPartSelect(1);
            case 2
                %                 SetPartSelect(3);
        end
        ReadImage();
        UpdatePlotImage();
        UpdatePlotAllAnt();
    end

    function PlotAll(varargin)
        PLOTIM(1)=imshow(Im*0,'Parent',AxesBox(1));
        PLOTIM(1).ButtonDownFcn=@ClickAnt;

        PLOTIM(2)=imshow(Im(1:ZoomSize,1:ZoomSize)*0,'Parent',AxesBox(2));
        PLOTIM(2).ButtonDownFcn=@ClickAnt;

        PLOTIM(3)=imshow(Im(1:ZoomSize,1:ZoomSize)*0,'Parent',AxesBox(3));
        PLOTIM(3).ButtonDownFcn=@ClickAnt;

        PlotIm=PLOTIM;
        col= 'yymmmggg';
        symb='os^dv^dv';
        hold(AxesBox(1),'on');
        hold(AxesBox(2),'on');
        hold(AxesBox(3),'on');

        for ii=1:8
            PLOT(ii)    =plot(0, 0 ,[col(ii) symb(ii)],'Parent',AxesBox(1));
            PLOT(ii+9)  =plot(0, 0 ,[col(ii) symb(ii)],'Parent',AxesBox(2));
            PLOT(ii+9*2)=plot(0, 0 ,[col(ii) symb(ii)],'Parent',AxesBox(3));
        end
        PLOT(9)    =plot(0,0,'p','MarkerSize',4,'MarkerEdgeColor','c','MarkerFaceColor','c','Parent',AxesBox(1));
        PLOT(9+9)  =plot(0,0,'p','MarkerSize',4,'MarkerEdgeColor','c','MarkerFaceColor','c','Parent',AxesBox(2));
        PLOT(9+9*2)=plot(0,0,'p','MarkerSize',4,'MarkerEdgeColor','c','MarkerFaceColor','c','Parent',AxesBox(3));

        hold(AxesBox(3),'off');
        hold(AxesBox(2),'off');
        hold(AxesBox(1),'off');

        title('No Image','Parent',AxesBox(1));
        title('Zoom','Parent',AxesBox(3));

        PlotAnt=PLOT;
        for ii=1:3*9
            PlotAnt(ii).ButtonDownFcn=@ClickAnt;
        end

        UpdatePlotImage();
        UpdatePlotAllAnt();
    end

    function UpdatePlotImage(varargin)


        PlotIm(1).CData=(Im-IntMin)/(IntMax-IntMin);
        PlotIm(3).CData=(Im-IntMin)/(IntMax-IntMin);
        PlotIm(2).CData=(Im2-IntMin2)/(IntMax2-IntMin2);

        switch Step
            case 1
                AxesBox(1).XLim=[1 size(Im,2)];
                AxesBox(1).YLim=[1 size(Im,1)];
            case 2
                [Xh,Yh]=RotatePoint(AntArray(Ind,1,1),AntArray(Ind,1,2),1);
                [Xt,Yt]=RotatePoint(AntArray(Ind,2,1),AntArray(Ind,2,2),1);

                Xm=(Xh+Xt)/2;
                Ym=(Yh+Yt)/2;

                AxesBox(1).XLim=[-0.5 0.5]*BoxeSizeXBox.Value+Xm;
                AxesBox(1).YLim=[-0.5 0.5]*BoxeSizeYBox.Value+Ym;
        end
        title(strcat('Frame ',num2str(Ind),'/',num2str(Nimage)),'Parent',AxesBox(1));
        UpdateZoom();
        FrameBox.Value=Ind;
    end

    function UpdateZoom(varargin)

        XX=PlotAnt(PartSelect).XData; %Using Data From the Graph
        YY=PlotAnt(PartSelect).YData;

        if(isnan(XX))
            XX=PlotAnt(9).XData; % Using Data From the reminder (star) graph
            YY=PlotAnt(9).YData;
        end
        if(isnan(XX))
            XX=size(Im,1)/2;
            YY=size(Im,2)/2;
        end

        AxesBox(2).XLim=[-ZoomSize/2 ZoomSize/2]+XX;
        AxesBox(2).YLim=[-ZoomSize/2 ZoomSize/2]+YY;

        AxesBox(3).XLim=[-ZoomSize/2 ZoomSize/2]+XX;
        AxesBox(3).YLim=[-ZoomSize/2 ZoomSize/2]+YY;
    end

    function UpdatePlotAnt(PS)
        switch Step
            case 1
                PlotAnt(PS).XData=AntArray(Ind,PS,1);
                PlotAnt(PS).YData=AntArray(Ind,PS,2);

                PlotAnt(PS+9).XData=AntArray(Ind,PS,1);
                PlotAnt(PS+9).YData=AntArray(Ind,PS,2);

                PlotAnt(PS+18).XData=AntArray(Ind,PS,1);
                PlotAnt(PS+18).YData=AntArray(Ind,PS,2);
            case 2
                [X2,Y2]=RotatePoint(AntArray(Ind,PS,1),AntArray(Ind,PS,2),1);
                PlotAnt(PS).XData=X2;
                PlotAnt(PS).YData=Y2;

                PlotAnt(PS+9).XData=X2;
                PlotAnt(PS+9).YData=Y2;

                PlotAnt(PS+18).XData=X2;
                PlotAnt(PS+18).YData=Y2;
        end
    end

    function UpdatePlotReminder()
        if(Ind==1)
            FI=[];
        else
            FI=find( ~isnan(AntArray(1:Ind-1,PartSelect,1)));
        end
        if(~isempty(FI))
            switch Step
                case 1
                    XX=AntArray(FI(end),PartSelect,1);
                    YY=AntArray(FI(end),PartSelect,2);
                case 2
                    [XX,YY]=RotatePoint(AntArray(FI(end),PartSelect,1),AntArray(FI(end),PartSelect,2),1);
            end
        else
            XX=NaN;
            YY=NaN;
        end
        PlotAnt(9).XData=XX;
        PlotAnt(9).YData=YY;

        PlotAnt(18).XData=XX;
        PlotAnt(18).YData=YY;

        PlotAnt(27).XData=XX;
        PlotAnt(27).YData=YY;
    end

    function UpdatePlotAllAnt()
        for ii=1:8
            UpdatePlotAnt(ii);
        end

        UpdatePlotReminder();
        UpdateZoom();

        figure(Fig);

    end

    function UpdateStep(varargin)
        Step=0;
        for ii=1:2
            if(eq(StepTypeBG.SelectedObject,StepTypeRB(ii)))
                Step=ii;
            end
        end
        switch Step
            case 1
                for ii=1:2 SelectBtn(ii).Enable='on'; end
                for ii=3:8 SelectBtn(ii).Enable='off'; end
                SetPartSelect(1)

            case 2
                CH1=~any(isnan(AntArray(:,1,1)));
                CH2=~any(isnan(AntArray(:,2,1)));
                CH1=1;
                CH2=1;
                if(CH1 && CH2)
                    for ii=1:2 SelectBtn(ii).Enable='off'; end
                    for ii=3:8 SelectBtn(ii).Enable='on'; end
                    SetPartSelect(3)
                    Ind=1;
                else
                    Step=1;
                end
        end
        ReadImage();
        UpdatePlotImage();
        UpdatePlotAllAnt();


    end

    function SetPartSelect(PS)
        switch Step
            case 1
                if(PS>=1 && PS<=2)PartSelect=PS; end
            case 2
                if(PS>=3 && PS<=8)PartSelect=PS; end
        end

        for ii=1:8
            SelectBtn(ii).BackgroundColor=[0.96 0.96 0.96];
        end
        SelectBtn(PartSelect).BackgroundColor=[0.96 0.5 0.5];

        UpdatePlotAllAnt();
    end

    function ClickSelect(btn,event)
        PS=0;
        for ii=1:8
            if(btn==SelectBtn(ii))
                PS=ii;
            end
        end
        if(PS~=0) SetPartSelect(PS); end
    end

    function ClickAnt(btn,event)
        switch Step
            case 1
                XX=get(gca,'CurrentPoint');
                AntArray(Ind,PartSelect,1:2)=[XX(1,1) XX(2,2)];
                UpdatePlotAnt(PartSelect);
                UpdateZoom();
                if(PartSelect==2 & Ind==Nimage)
                    msgbox('You completed all the head/tail selection. Please check and click on COMPLETE GAP and change the step','this is not the end')
                end

            case 2
                XX=get(gca,'CurrentPoint');
                [XX2,YY2]=RotatePoint(XX(1,1),XX(2,2),-1);
                AntArray(Ind,PartSelect,1:2)=[XX2 YY2];
                UpdatePlotAnt(PartSelect);
                UpdateZoom();
                if(Ind==Nimage)
                    if(PartSelect<8)
                        msgbox('Click for this leg completed. Go back to image 1 and complete the same job with the next leg','this is not the end')
                    else
                        msgbox('You completed all the body part selection. Please check and click on COMPLETE GAP and DONE','this is the end')
                    end
                end
        end
    end

    function ReadKeyboard(btn,event)
        char=get(btn,'CurrentCharacter');
        switch char
            case 'n'
                Next(0,0,+StepSizeBox.Value)
            case 'b'
                Next(0,0,+1)
            case 'c'
                Next(0,0,-1);
            case 'x'
                Next(0,0,-StepSizeBox.Value);
            case {'1','2','3','4','5','6','7','8'}
                SetPartSelect(str2double(char));
            otherwise
        end
    end

    function CompleteGap(varargin)
        switch Step
            case 1
                List=1:2;
                ch=1;
                for ii=List
                    if(isnan(AntArray(1,ii,1)) || isnan(AntArray(end,ii,1)))
                        ch=0;
                    end
                end

                if(ch==1)
                    for ii=List
                        FI=find(~isnan(AntArray(:,ii,1)));
                        for jj=1:(length(FI)-1)
                            if(FI(jj+1)-FI(jj)>1)
                                for kk=1:2
                                    F1=FI(jj); F2=FI(jj+1);
                                    A1=AntArray(F1,ii,kk);
                                    A2=AntArray(F2,ii,kk);
                                    a =(A2-A1)/(F2-F1);
                                    AntArray((F1+1):(F2-1),ii,kk)= a*(1:(F2-F1-1))+A1;
                                end
                            end
                        end
                    end
                else
                    msgbox('Not enough click to complete the gap','this is not the end');
                end
            case 2
                List=3:8;
                ch=1;
                for ii=List
                    if(isnan(AntArray(1,ii,1)) )
                        ch=0;
                    end
                end

                if(ch==1)
                    for ii=List
                        FI=find(~isnan(AntArray(:,ii,1)));
                        if(FI(end)<size(AntArray,1))
                            FI=[FI ;size(AntArray,1)+1];
                        end
                        for jj=1:(length(FI)-1)
                            if(FI(jj+1)-FI(jj)>1)
                                F1=FI(jj);
                                F2=FI(jj+1);
                                AntArray((F1+1):(F2-1),ii,1)= AntArray(F1,ii,1);
                                AntArray((F1+1):(F2-1),ii,2)= AntArray(F1,ii,2);
                            end
                        end
                    end
                else
                    msgbox('Not enough click to complete the gap','this is not the end');
                end
        end
    end

    function CheckEnd(btn,event)
        AA=AntArray(:,:,1);
        AA=AA';
        FI=find(isnan(AA));
        if(isempty(FI))
            ExitDetectAnt()
        else
            [PS,Ind,~]=ind2sub(size(AA),FI(1));
            SetPartSelect(PS);
            PlotAnt();
            SaveData();
            msgbox('Data saved BUT You did not complete all the click. We changed the Frame/body part onto an unselected one','this is not the end');
        end
    end

    function ExitDetectAnt(btn,event)
        SaveData();
        delete(Fig);
        delete(FigUi);
    end

    function UpdateTypePlot(varargin)
        SelectTypePlot();
        ReadImage();
        UpdatePlotImage();
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

        switch(TypePlotBg2.SelectedObject.Text)
            case TypePlotRb2(1).Text
                ImRef2=double(imread(fullfile(FileName,'step1',FrameName,'Ant_ref.png')));
                ImRef2=ImRef*0;
                [NameImage2,Nini,Nimage]= vm_ListAllImage(fullfile(FileName,'step1',FrameName,'Ant','Ant*.png'));
                IntMin2=NaN;
            case TypePlotRb2(2).Text
                ImRef2=double(imread(fullfile(FileName,'step1',FrameName,'Pillar_ref.png')));
                ImRef2=ImRef*0;
                [NameImage2,Nini,Nimage]= vm_ListAllImage(fullfile(FileName,'step1',FrameName,'Pillar','Pillar*.png'));
                IntMin2=NaN;
            case TypePlotRb2(3).Text
                ImRef2=double(imread(fullfile(FileName,'step1',FrameName,'Ant_ref.png')));
                [NameImage2,Nini,Nimage]= vm_ListAllImage(fullfile(FileName,'step1',FrameName,'Ant','Ant*.png'));
                IntMin2=-50; IntMax2=50;
            case TypePlotRb2(4).Text
                ImRef2=double(imread(fullfile(FileName,'step1',FrameName,'Pillar_ref.png')));
                [NameImage2,Nini,Nimage]= vm_ListAllImage(fullfile(FileName,'step1',FrameName,'Pillar','Pillar*.png'));
                IntMin2=-12; IntMax2=12;
        end

    end

    function ReadImage()
        Im=double(imread(sprintf(NameImage,Ind-1+Nini)));
        Im=Im-ImRef;
        if(isnan(IntMin) || isnan(IntMax))
            IntMax=max(Im(:));
            IntMin=min(Im(:));
        end

        Im2=double(imread(sprintf(NameImage2,Ind-1+Nini)));
        Im2=Im2-ImRef2;
        if(isnan(IntMin2) || isnan(IntMax2))
            IntMax2=max(Im2(:));
            IntMin2=min(Im2(:));
        end

        switch Step
            case 1
                % ImRef=ImRefSave;
            case 2
                dX=(AntArray(Ind,1,1)-AntArray(Ind,2,1));
                dY=(AntArray(Ind,1,2)-AntArray(Ind,2,2));
                Angle=angle(dX+1i*dY)*180/pi;
                XYc =(size(Im)/2)';
                XYc =XYc ([2 1]);
                Im=imrotate(Im,Angle);
                Im2=imrotate(Im2,Angle);
                XYc2=(size(Im)/2)';
                XYc2=XYc2([2 1]);
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

    function ReadData()
        FileName2=fullfile(FileName,'step2',['ant_' FrameName '.mat']);
        if(exist(FileName2,'file'))
            load(FileName2,'AntArray');
            if(size(AntArray,[1 2 3])~=[Nimage,8,2])
                AntArray=zeros(Nimage,8,2)*NaN;
            end
        else
            AntArray=zeros(Nimage,8,2)*NaN;
        end


    end

    function SaveData()
        [~,~,~] = mkdir(fullfile(FileName,'step2'));
        if(~isempty(AntArray))
            save(fullfile(FileName,'step2',['ant_' FrameName '.mat']),'AntArray');
        end
    end
end