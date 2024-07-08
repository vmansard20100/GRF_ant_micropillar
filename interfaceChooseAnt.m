function interfaceChooseAnt(FileName)

%% Create App Figure
fig2 = uifigure('Name', 'AntForcesAnalysis (2/3) by Dorian GAUTIER', 'Position', [20 60 250 800]);
fig2.Icon = 'icon/ant.png';
fig2.Resize = 'off';

%% Folder Path Display
FolderBox = uitextarea(fig2, 'Position', [10 650 230 66], 'Value', FileName);
FolderBox.Editable = 'off';

%% File List and Selection
FileList = uilistbox(fig2, 'Position', [20 240 200 400], 'ValueChangedFcn', @UpdateFile);
FileList.Items = {'No selection'};

FileBox = uitextarea(fig2, 'Position', [20 210 200 22], 'Value', 'No file selected');
FileBox.Editable = 'off';

%% Action Buttons
RunDetectAntBtn = uibutton(fig2, 'Position', [20 160 200 40], 'Text', 'Detect Ant Position', ...
    'ButtonPushedFcn', @(btn, event) RunDetectAnt());

RunDetectPillarBtn = uibutton(fig2, 'Position', [20 110 200 40], 'Text', 'Detect Pillar Array', ...
    'ButtonPushedFcn', @(btn, event) RunDetectPillar());

RunDetectMvtBtn = uibutton(fig2, 'Position', [20 60 200 40], 'Text', 'Detect Pillar Movement', ...
    'ButtonPushedFcn', @(btn, event) RunDetectMvt());

RunDetectAssociateBtn = uibutton(fig2, 'Position', [20 10 200 40], 'Text', 'Associate Movement to Leg', ...
    'ButtonPushedFcn', @(btn, event) RunDetectAssociate());

%% Initial Updates
UpdateFileList();
UpdateFile();

%% Function Definitions

    function UpdateFileList(~, ~)
        DIR = dir(fullfile(FileName, 'step1', 'Frame_*-*'));
        DIR = DIR([DIR.isdir]);
        Items = {DIR.name};
        if isempty(Items)
            Items = {'No selection'};
        end
        FileList.Items = Items;
    end

    function UpdateFile(~, ~)
        FileBox.Value = FileList.Value;
    end

    function RunDetectAnt()
        FrameName = FileBox.Value{1};
        DetectAnt(FileName, FrameName);
    end

    function RunDetectPillar()
        FrameName = FileBox.Value{1};
        DetectPillar(FileName, FrameName);
    end   

    function RunDetectMvt()
        FrameName = FileBox.Value{1};
        DetectMvt(FileName, FrameName);
    end   

    function RunDetectAssociate()
        FrameName = FileBox.Value{1};
        DetectAssociate(FileName, FrameName);
    end  

end
