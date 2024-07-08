% Create an interface for analysing videos
%  FUNCTION
% update:
% 2022-1108 VM : New folder organization ("file"/input)

function interfaceCreateMovie(FileName)


%% Create Windows
fig1 = uifigure('Name','AntForcesAnalysis (1/3)','Position',[20 60 1400 800]);
fig1.Icon='icon/ant.png';
fig1.Resize='off';

FileBox = uitextarea(fig1,...
    'Position',[20 750 200 22],...
    'Value','');
FileBox.Editable='off';


ImBox= uiimage(fig1,...
    'Position', [300 100 800 600]);

FrameLbl = uilabel(fig1,...
    'Position',[370 50 100 22],...
    'Text','Frame-??',...
    'BackgroundColor',[0.7 0.7 0.7],'FontWeight','Bold','HorizontalAlignment','Center');


DisplayNextFrameBtn = uibutton(fig1,...
    'Position',[490 50 22 22],...
    'Text','>',...
    'ButtonPushedFcn',@(btn,event) DisplayNextFrame(btn));

DisplayPreviousFrameBtn = uibutton(fig1,...
    'Position',[328 50 22 22],...
    'Text','<',...
    'ButtonPushedFcn',@(btn,event) DisplayPreviousFrame(btn));

SelectFrame1Btn = uibutton(fig1,...
    'Position',[600 50 100 22],...
    'Text','Select first frame video',...
    'ButtonPushedFcn',@(btn,event) SelectFrame1(btn));

SelectFrame2Btn = uibutton(fig1,...
    'Position',[720 50 100 22],...
    'Text','Select last frame video',...
    'ButtonPushedFcn',@(btn,event) SelectFrame2(btn));

AddListbtn = uibutton(fig1,...
    'Position',[850 50 220 22],...
    'Text','Add to the list',...
    'ButtonPushedFcn',@(btn,event) AddList(btn));

Calibrationbtn = uibutton(fig1,...
    'Position',[1100 50 150 22],...
    'Text','Remake Calibration',...
    'ButtonPushedFcn',@(btn,event) Calibration(btn));

% ExistingSeqBox = uitextarea(fig1,...
%     'Position',[20 350 200 22],...
%     'Value','No video');

GenerateVideobtn = uibutton(fig1,...
    'Position',[20 100 200 22],...
    'Text','Create sequences',...
    'ButtonPushedFcn',@(btn,event) GenerateVideo(btn));

ExistingSeqList = uilistbox(fig1,...
    'Position',[20 500 200 200]);

CreationSeqList = uilistbox(fig1,...
    'Position',[20 200 200 200]);

ExistingSeqLbl =  uilabel(fig1,...
     'Position',[20 470 200 22],...
     'Text','Existing sequences',...
     'BackgroundColor',[0.7 0.7 0.7],'FontWeight','Bold','HorizontalAlignment','Center');

CheckSynchrobtn = uibutton(fig1,...
    'Position',[20 440 200 22],...
    'Text','Check Synchro',...
    'ButtonPushedFcn',@(btn,event) CheckSynchro(btn));

CreationSeqLbl = uilabel(fig1,...
    'Position',[20 170 200 22],...
    'Text','Sequences',...
    'BackgroundColor',[0.7 0.7 0.7],'FontWeight','Bold','HorizontalAlignment','Center');


FrameStepBox= uitextarea(fig1,...
    'Position',[1250 150 70 22],...
    'Value','5',...
    'ValueChangedFcn',@UpdateFrameStep);

FrameStepLbl = uilabel(fig1,...
    'Position',[1150 150 100 22],...
    'Text','Frame Step',...
    'BackgroundColor',[0.7 0.7 0.7],'FontWeight','Bold','HorizontalAlignment','Center');

IntensityBox= uitextarea(fig1,...
    'Position',[1250 100 70 22],...
    'Value','200',...
    'ValueChangedFcn',@UpdateIntensity);

IntensityLbl = uilabel(fig1,...
    'Position',[1150 100 100 22],...
    'Text','Image Intensity',...
    'BackgroundColor',[0.7 0.7 0.7],'FontWeight','Bold','HorizontalAlignment','Center');


FlipPnl=  uipanel(fig1,'Position',[1150 200 170 80],'Title','Flip Image Reference?');
FlipHorizontalChBx= uicheckbox(FlipPnl,'Position',[5  5 200 20],'Text','Horizontal Flip','Value',1);
FlipVerticalChBx  = uicheckbox(FlipPnl,'Position',[5  30 200 20],'Text','Vertical Flip'  ,'Value',0);


%% Initialize Data

[NameImage1,NiniFrame,NmaxFrame]= vm_ListAllImage(fullfile(FileName,'Input'  ,'JaiGO1_0*.*'));
[NameImage2,NiniFrame,NmaxFrame]= vm_ListAllImage(fullfile(FileName,'Input'  ,'JaiGO1_JaiGO2_1_*.*'));

ReshapeData1=[];
ReshapeData2=[];
ReshapeData3=[];



%% Run
Calibration();
Frame = 1;
FrameStep=5;
ImageIntensity=200.0;
UpdateFrame();
UpdateFrameList();


%% function

    function UpdateFrameList()
        CreationSeqList.Items={};
        FrameList     = dir(fullfile(FileName,'Step1','Frame*'));
        Items=cell(1,length(FrameList));
        for i=1:length(FrameList)
            Items{i}=FrameList(i).name;
        end
        ExistingSeqList.Items=Items;
    end

    function DisplayNextFrame(btn)
        if(Frame==1)
            Frame=FrameStep;
        else
            Frame=Frame+FrameStep;
        end
        Frame=min(Frame,NmaxFrame);
        UpdateFrame();
    end

    function DisplayPreviousFrame(btn)
        if(Frame==NmaxFrame)
            Frame=(ceil(NmaxFrame/FrameStep)-1)*FrameStep;
        else
            Frame=Frame-FrameStep;
        end
        Frame=max(Frame,1);
        UpdateFrame();
        
    end

    function UpdateFrame()
        FrameLbl.Text=strcat('Frame-',int2str(Frame));
        Im=imread(sprintf(NameImage1,Frame+NiniFrame-1));
        ImC=vm_rotatecropimage(Im,ReshapeData1);
        %         ImR=imwarp(ImC,ReshapeData2,'OutputView',ReshapeData3);
        Im2=[];
        Im2=zeros(size(ImC,1),size(ImC,2),3);
        Im2(:,:,1)=double(ImC)/ImageIntensity;
        Im2(:,:,2)=Im2(:,:,1);
        Im2(:,:,3)=Im2(:,:,1);
        
        ImBox.ImageSource = Im2;

    end

    function UpdateIntensity(btn,event)
        ImposeNumeric(btn,event);
        ImageIntensity=str2num(IntensityBox.Value{1});
        UpdateFrame();
    end

    function UpdateFrameStep(btn,event)
        ImposeNumeric(btn,event);
        FrameStep=str2num(FrameStepBox.Value{1});
%         FrameStepLbl.Text=sprintf('FrameStep (%d)',FrameStep);
    end
    
    function ImposeNumeric(btn,event)
       Char=btn.Value{1};
       btn.Value{1}=Char(ismember(Char,'0123456789.'));          
    end

    function SelectFrame1(btn)
        SelectFrame1Btn.Text=strcat('First frame : ',int2str(Frame));
    end

    function SelectFrame2(btn)
        SelectFrame2Btn.Text=strcat('Last frame : ',int2str(Frame));
    end

    function AddList(btn)
        
        Frame1=str2double(SelectFrame1Btn.Text(14:end));
        Frame2=str2double(SelectFrame2Btn.Text(13:end));
        
        if( ~isnan(Frame1) && ~isnan(Frame2) && Frame1<Frame2)
            CreationSeqList.Items=[CreationSeqList.Items,sprintf('%d - %d',Frame1,Frame2)];
        end
        
        SelectFrame1Btn.Text='Select first frame video';
        SelectFrame2Btn.Text='Select last frame video';
        
    end

    function GenerateVideo(btn)     
%         set(fig1,'Pointer','watch')
%         drawnow
        MessageBox = uiprogressdlg(fig1,'Title','Please Wait',...
            'Message','Creating File');
        MessageBox.Value = 0.;
 
        NSeq=length(CreationSeqList.Items);        
        for i=1:NSeq
            MessageBox.Message=strcat('Creating File',num2str(i),'/',num2str(NSeq));
            A=sscanf(CreationSeqList.Items{i}, '%d - %d');
            Frame1=A(1);
            Frame2=A(2);
            SeqName=sprintf('Frame_%d-%d',Frame1,Frame2);
            NFrame=Frame2-Frame1+1;
            [~,~,~] =mkdir(fullfile(FileName,'Step1',SeqName,'Ant'));
            [~,~,~] =mkdir(fullfile(FileName,'Step1',SeqName,'Pillar'));
            
            [Time1,Time2]=ReadTimeStamp(Frame1,Frame2);
            Ind1=1;
            Ind2=1;
            for j=1:NFrame
                MessageBox.Value = j/NFrame;
                Im=imread(sprintf(NameImage1,j+Frame1+NiniFrame-2));
                ImC=vm_rotatecropimage(Im,ReshapeData1);
                ImR=imwarp(ImC,ReshapeData2,'OutputView',ReshapeData3);

                for k=1:Time1(j)
                    imwrite(ImR,fullfile(FileName,'Step1',SeqName,'Ant',sprintf('Ant_%0.4d.png',Ind1-1)));
                    Ind1=Ind1+1;
                    % disp([j Time1(j) k Ind1]);
                end


                for k=1:Time2(j)
                    [~] = copyfile(sprintf(NameImage2,j+Frame1+NiniFrame-2),...
                        fullfile(FileName,'Step1',SeqName,'Pillar',sprintf('Pillar_%0.4d.png',Ind2-1)));
                    Ind2=Ind2+1;
                end
            end
            
            while(Ind1<Ind2)
                imwrite(ImR,fullfile(FileName,'Step1',SeqName,'Ant',sprintf('Ant_%0.4d.png',Ind1-1)));
                Ind1=Ind1+1;
            end

            while(Ind2<Ind1)
                [~] = copyfile(sprintf(NameImage2,NFrame+Frame1+NiniFrame-2),...
                    fullfile(FileName,'Step1',SeqName,'Pillar',sprintf('Pillar_%0.4d.png',Ind2-1)));
                Ind2=Ind2+1;
            end

            [NameImRef1,NiniRef1,~]= vm_ListAllImage(fullfile(FileName,'dataref'  ,'JaiGO1_0*.*'));
            [NameImRef2,NiniRef2,~]= vm_ListAllImage(fullfile(FileName,'dataref'  ,'JaiGO1_JaiGO2_*.*'));
            IMref1=imread(sprintf(NameImRef1,NiniRef1));
            ImC=vm_rotatecropimage(IMref1,ReshapeData1);
            ImR=imwarp(ImC,ReshapeData2,'OutputView',ReshapeData3);
            imwrite(ImR,fullfile(FileName,'Step1',SeqName,'Ant_ref.png'));
            [~] = copyfile(  sprintf(NameImRef2,NiniRef2),...
                fullfile(FileName,'Step1',SeqName,'Pillar_ref.png'));
                    
        end        
        close(MessageBox);
        UpdateFrameList();
    end

    function  [Time1,Time2]=ReadTimeStamp(Frame1,Frame2)
        if( exist(fullfile(FileName,'Input'  ,'JaiGO1time.csv'),'file'))
            fid=fopen(fullfile(FileName,'Input'  ,'JaiGO1time.csv'));
            fgetl(fid);fgetl(fid);
            A=fscanf(fid,'%f;%f\n');
            Time=A(2:2:end);
            dTime=diff(Time);
            Step=median(dTime);
            Time1=round(dTime/Step);
            Time1=[Time1; 1];
        else
            Time1=ones(1,NmaxFrame);
        end

        if( exist(fullfile(FileName,'Input'  ,'JaiGO1_JaiGO2_1time.csv'),'file'))
            fid=fopen(fullfile(FileName,'Input'  ,'JaiGO1_JaiGO2_1time.csv'));
            fgetl(fid);fgetl(fid);
            A=fscanf(fid,'%f;%f\n');
            Time=A(2:2:end);
            dTime=diff(Time);
            Time2=round(dTime/Step);
            Time2=[Time1; 1];
        else
            Time2=ones(1,NmaxFrame);
        end

        Time1=Time1(Frame1:Frame2);
        Time2=Time2(Frame1:Frame2);
        Time1(end)=1;
        Time2(end)=1;
        Time1(Time1<1)=1;
        Time2(Time2<1)=1;
    end

    function Calibration(btn)
        
        [NameImRef1,NiniRef1,~]= vm_ListAllImage(fullfile(FileName,'dataref'  ,'JaiGO1_0*.*'));
        [NameImRef2,NiniRef2,~]= vm_ListAllImage(fullfile(FileName,'dataref'  ,'JaiGO1_JaiGO2_1_*.*'));
        
        IMref1=imread(sprintf(NameImRef1,NiniRef1));
        IMref2=imread(sprintf(NameImRef2,NiniRef2));
        
        %% Crop image
        imshow(IMref1,[0,150]);
        title('click on top left corner and right bottom corner');
        ReshapeData1.XY=ginput(2);
        ReshapeData1.FlipHorizontal=FlipHorizontalChBx.Value;
        ReshapeData1.FlipVertical=FlipVerticalChBx.Value;
        IMcrop=vm_rotatecropimage(IMref1,ReshapeData1);

        
        subplot(2,1,1);
        imshow(IMcrop,[]);        
        title(sprintf('Top Image Cropped & image Flipped Horizontal %d == Vertical %d ',FlipHorizontalChBx.Value, FlipVerticalChBx.Value));
        subplot(2,1,2);
        imshow(IMref2,[]);        
        title('Both images need to be as similar as possible - use flip option if required');
        pause(1);
        
        
        %% Precise reshape image et compare
        ReshapeData2 = imregcorr(IMcrop,IMref2);
        ReshapeData3 = imref2d(size(IMref2));
        IMmoved= imwarp(IMcrop,ReshapeData2,'OutputView',ReshapeData3);
        clf;
        imshowpair(IMref2,IMmoved,'falsecolor');
        title('Top vs bottom (top image Reshaped)');
        pause(2);
        close(gcf);
        
    end

    function CheckSynchro(varargin) 
        Seq=ExistingSeqList.Value;
        App=CreateCheckSynchro();
        App.DataStart(FileName,Seq);
    end


end