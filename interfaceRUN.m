%% Create an interface for analysing videos

%% FUNCTION

function interfaceRUN
%% Initialization of constants
clc
close all
clear all

%% Create app figure
fig = uifigure('Name','AntForcesAnalysis by Dorian GAUTIER','Position',[10 50 1100 350]);
fig.Icon='icon/ant.png';
fig.Resize='off';

%% Create the Folder box
FolderBox = uitextarea(fig,...
    'Position',[20 300 600 22],...
    'Value','./data',...
    'ValueChangedFcn', @UpdateFolder);
FolderBox.Editable='on';

% Button for selecting folder
FolderBtn = uibutton(fig,...
    'Position',[630 300 22 22],...
    'Text','',...
    'ButtonPushedFcn',@(btn,event)FolderBtnFunc(btn));
% FolderBtn.Icon = 'icon/CreateMovie.png'; % Uncomment to add an icon to the button

%% Create file list
FileList = uilistbox(fig,...
    'Position',[20 50 200 240],...
    'ValueChangedFcn', @UpdateFileSelection);

% Display selected file
FileBox = uitextarea(fig,...
    'Position',[20 10 200 25],...
    'Value','No file selected');
FileBox.Editable='off';

% Button to update file list
step0Btn = uibutton(fig,...
    'Position',[230 10 50 50],...
    'Text','Update',...
    'ButtonPushedFcn',@UpdateFileSelection);

% Initial update of folder
UpdateFolder(FolderBox,0);

%% Step Buttons
% Button for step 0
step0Btn = uibutton(fig,...
    'Position',[300 125 150 150],...
    'Text','',...
    'ButtonPushedFcn',@(btn,event) step0(btn));
step0Btn.Icon = 'icon/Average.png';

% Button for step 1
step1Btn = uibutton(fig,...
    'Position',[500 125 150 150],...
    'Text','',...
    'ButtonPushedFcn',@(btn,event) step1(btn));
step1Btn.Icon = 'icon/CreateMovie.png';

% Button for step 2
step2Btn = uibutton(fig,...
    'Position',[700 125 150 150],...
    'Text','',...
    'ButtonPushedFcn',@(btn,event) step2(btn));
step2Btn.Icon = 'icon/ant2.png';

% Button for step 3
step3Btn = uibutton(fig,...
    'Position',[900 125 150 150],...
    'Text','',...
    'ButtonPushedFcn',@(btn,event) step3(btn));
step3Btn.Icon = 'icon/data2.png';

% Lamps to indicate status of each step
lampStep0 = uilamp(fig,...
    'Position',[350 50 50 50],...
    'Color','red');

lampStep1 = uilamp(fig,...
    'Position',[550 50 50 50],...
    'Color','red');

lampStep2 = uilamp(fig,...
    'Position',[750 50 50 50],...
    'Color','red');

lampStep3 = uilamp(fig,...
    'Position',[950 50 50 50],...
    'Color','red');

%% RUN
UpdateFolder(0,0)

%% All function

% Function to handle folder button click
    function FolderBtnFunc(btn)
        NewPath = uigetdir(FolderBox.Value{1},'Select the folder with your data');
        FolderBox.Value{1}=NewPath;
        UpdateFolder(FolderBox,0);
    end

% Function to update the folder and file list
    function UpdateFolder(btn,event)
        ListFile = dir(fullfile(FolderBox.Value{1} ,'','*'));
        ListFolder=ListFile([ListFile.isdir]);
        ListFolder=ListFolder(3:end);
        
        DirFlag=zeros(1,length(ListFolder));
        for i=1:length(ListFolder)
            File1=fullfile(FolderBox.Value{1} ,ListFolder(i).name,'Input');
            File2=fullfile(FolderBox.Value{1} ,ListFolder(i).name,'Step1');
            if(exist(File1,'dir') || exist(File2,'dir'))
                DirFlag(i)=1;
            end
        end
        ListFolder=ListFolder(DirFlag==1);
        
        NameFolder=cell(1,length(ListFolder)+1);
        NameFolder{1}='No file selected';
        for i=1:length(ListFolder)
            NameFolder{i+1}=ListFolder(i).name;
        end
        FileList.Items=NameFolder;
        UpdateFileSelection(btn,0);
    end

% Function to update the file selection
    function UpdateFileSelection(src,event)
        FileBox.Value = FileList.Value;
        FileName=fullfile(FolderBox.Value{1},FileBox.Value{1});
        
        if (strcmp(FileBox.Value,'No file selected'))
            lampStep0.Color='black';
            lampStep1.Color='black';
            lampStep2.Color='black';
            lampStep3.Color='black';
        else
            ExistInput  =exist(fullfile(FileName,'Input'),'Dir')  ;
            ExistDataRef=exist(fullfile(FileName,'dataref'),'Dir');
            ExistStep1  =exist(fullfile(FileName,'Step1'),'Dir');
            ExistStep2=~isempty(dir(fullfile(FileName,'Step2','TotalMvt_Frame*')));
            ExistStep3  =exist(fullfile(FileName,'Step3'),'Dir');
            
            % Update lamp colors based on existence of folders/files
            if(~ExistInput)
                lampStep0.Color='black';
            elseif(~ExistDataRef)
                lampStep0.Color='yellow';
            else
                lampStep0.Color='green';
            end
            
            if(~(ExistInput & ExistDataRef))
                lampStep1.Color='black';
            elseif(ExistStep1)
                lampStep1.Color='green';
            else
                lampStep1.Color='yellow';
            end
            
            if(~ExistStep1)
                lampStep2.Color='black';
            elseif(ExistStep2)
                lampStep2.Color='green';
            else
                lampStep2.Color='yellow';
            end
            
            if(~ExistStep2)
                lampStep3.Color='black';
            elseif(ExistStep3)
                lampStep3.Color='green';
            else
                lampStep3.Color='yellow';
            end
        end
    end

% Function for step 0 button click
    function step0(btn)
        FileName=fullfile(FolderBox.Value{1},FileBox.Value{1});
        if (~isequal(lampStep0.Color,[0 0 0]))
            CreateAvgImage(FileName,fig);
            UpdateFileSelection(FileList,0);
        end
    end

% Function for step 1 button click
    function step1(btn)
        FileName=fullfile(FolderBox.Value{1},FileBox.Value{1});
        if (~isequal(lampStep1.Color,[0 0 0]))
            interfaceCreateMovie(FileName);
            UpdateFileSelection(FileList,0);
        end
    end

% Function for step 2 button click
    function step2(btn)
        FileName=fullfile(FolderBox.Value{1},FileBox.Value{1});
        if (~isequal(lampStep2.Color,[0 0 0]))
            interfaceChooseAnt(FileName);
            UpdateFileSelection(FileList,0);
        end
    end

% Function for step 3 button click
    function step3(btn)
        FileName=fullfile(FolderBox.Value{1},FileBox.Value{1});
        if (~isequal(lampStep3.Color,[0 0 0]))
            App=InterfaceForceAnalysisApp;
            App.DataStart(FileName);
            UpdateFileSelection(FileList,0);
        end
    end

end
