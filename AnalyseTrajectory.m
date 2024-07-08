function AntArray = AnalyseTrajectory(FileName,FrameName)
% AntArray = AnalyseTrajectory(FileName,FrameName)
% function to plot the trajectory over time of the center of mass of the
% insect 

%% Figure
Fig=figure('Position',[750 60 900 900]);
% Fig.KeyPressFcn=@ReadKeyboard;
Fig.DeleteFcn=@ExitDetectAnt;

%% Variable

AntArray=[];
XYTrajectory=[];
Nimage=NaN;
Length=NaN;
ImRef=[];
%% Intial action

ReadData();
CalculateTrajectoryAverage();
PlotResult();
SaveResult();


%% Function
    function CalculateTrajectoryAverage()
        Nimage=size(AntArray,1);
        XYTrajectory=zeros(Nimage,2);

        for ii=1:Nimage
            XYTrajectory(ii,1)=mean(AntArray(ii,1:2,1));
            XYTrajectory(ii,2)=mean(AntArray(ii,1:2,2));
        end

        dLength=zeros(Nimage-1,1);
        for ii=1:(Nimage-1)
            dLength(ii)=sqrt(sum((XYTrajectory(ii,:)-XYTrajectory(ii+1,:)).^2));
        end
        Length=sum(dLength);

    end

    function PlotResult()
        imshow(ImRef,[],'Border','Tight');
        PlotTrajectory=ploth(XYTrajectory(:,1),XYTrajectory(:,2),'.r');
        
        PlotBody1=ploth(0,0,'-y','LineWidth',1);
        PlotLeg1 =ploth(0,0,'y','LineWidth',0.5);

        PlotBody2=ploth(0,0,'-y','LineWidth',1);
        PlotLeg2 =ploth(0,0,'y','LineWidth',0.5);
   
        PlotAnt(reshape(AntArray(1,1:2,1:2),[2 2]),reshape(AntArray(1,3:8,1:2),[6 2]),PlotBody1,PlotLeg1 );
        PlotAnt(reshape(AntArray(Nimage,1:2,1:2),[2 2]),reshape(AntArray(Nimage,3:8,1:2),[6 2]),PlotBody2,PlotLeg2);
    end

    function SaveResult()
        ConversionSize=20/1431;%mm/pixel
        FrameRate=60;%frame/second

        Lengthmm=Length*ConversionSize;
        dTemps=Nimage/FrameRate;
        Speed=Length/Nimage;
        Speedmms=Lengthmm/dTemps;
        Message=sprintf('Length of the trajectory %0.1fpix (%0.2fmm)\n speed %0.2fpix/frame (%0.2fmm/s)\n Conversion : %0.2emm/pix == %0.1fframe/s',Length,Lengthmm,Speed,Speedmms,ConversionSize,FrameRate);
        f = msgbox(Message);
        pause(5);
        [~,~]=mkdir(fullfile(FileName,'step3'));
        vm_save_image(fullfile(FileName,'step3',[ 'Trajectory_' FrameName ]),[1 1]*5,Fig,0);
        Fid=fopen(fullfile(FileName,'step3',[ 'Trajectory_' FrameName '.txt']),'w');
        fwrite(Fid,Message);
        fclose(Fid);
        delete(f);
    end
    function ReadData()
        FileName2=fullfile(FileName,'step2',[ 'ant_' FrameName '.mat']);
        load(FileName2,'AntArray');
        ImRef=imread(fullfile(FileName,'step1',FrameName, 'Pillar_ref.png'));

        Nimage=size(AntArray,1);
    end

    function ExitDetectAnt(varargin)
        delete(Fig);
    end
end