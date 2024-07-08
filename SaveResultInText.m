function SaveResultInText(FileName,FrameName)
%  SaveResultInText(FileName,FrameName)
% Transfert the data from a .mat file into a text file
% Read head of the file to know the organization of the produced data

load(fullfile(FileName,'step2',['ant_' FrameName '.mat']),'AntArray');
load(fullfile(FileName,'step2',['TotalMvt_' FrameName '.mat']),'TotalLegMvt');


fid=fopen(fullfile(FileName,'step3',['Result_' FrameName '.txt']),'w');


Nim=size(AntArray,1);

if(fid>0)
    f = waitbar(0.5,'Save data. Please wait...');
    Label={'Head' 'Gaster' 'LegR1' 'LegR1_pillar' 'LegR2' 'LegR2_pillar' 'LegR3' 'LegR3_pillar' 'LegL1' 'LegL1_pillar' 'LegL2' 'LegL2_pillar' 'LegL3' 'LegL3_pillar'};
    Label={'Head' 'Gast' 'LegR1' 'R1' 'LegR2' 'R2' 'LegR3' 'R3' 'LegL1' 'L1' 'LegL2' 'L2' 'LegL3' 'L3'};
    Label2=cell(14,1);
    Label2(:)={'_'};
    Label2(4:2:end)={'disp'};
    Label3={'X' 'Y'};
    
    fprintf(fid,'Frame\t');
    for i=1:14
        for j=1:2
            fprintf(fid,[Label{i}  Label2{i} Label3{j} '\t']);
        end
    end
    fprintf(fid,'\n');
    for i=1:Nim
        fprintf(fid,'%0.3d\t',i-1);
        fprintf(fid,'%0.2f\t%0.2f\t',AntArray(i,1,1),AntArray(i,1,1)); % Head
        fprintf(fid,'%0.2f\t%0.2f\t',AntArray(i,2,1),AntArray(i,2,1)); % Gaster
        fprintf(fid,'%0.2f\t%0.2f\t',AntArray(i,3,1),AntArray(i,3,1)); % L1
        fprintf(fid,'%0.2f\t%0.2f\t',TotalLegMvt(1).Disp(i,1),TotalLegMvt(1).Disp(i,2)); % Pillar_L1
        fprintf(fid,'%0.2f\t%0.2f\t',AntArray(i,4,1),AntArray(i,4,1)); % L2
        fprintf(fid,'%0.2f\t%0.2f\t',TotalLegMvt(2).Disp(i,1),TotalLegMvt(2).Disp(i,2)); % Pillar_L2
        fprintf(fid,'%0.2f\t%0.2f\t',AntArray(i,5,1),AntArray(i,5,1)); % L3
        fprintf(fid,'%0.2f\t%0.2f\t',TotalLegMvt(3).Disp(i,1),TotalLegMvt(3).Disp(i,2)); % Pillar_L3
        fprintf(fid,'%0.2f\t%0.2f\t',AntArray(i,6,1),AntArray(i,6,1)); % R1
        fprintf(fid,'%0.2f\t%0.2f\t',TotalLegMvt(4).Disp(i,1),TotalLegMvt(4).Disp(i,2)); % Pillar_R1
        fprintf(fid,'%0.2f\t%0.2f\t',AntArray(i,7,1),AntArray(i,7,1)); % R2
        fprintf(fid,'%0.2f\t%0.2f\t',TotalLegMvt(5).Disp(i,1),TotalLegMvt(5).Disp(i,2)); % Pillar_R2
        fprintf(fid,'%0.2f\t%0.2f\t',AntArray(i,8,1),AntArray(i,8,1)); % R3
        fprintf(fid,'%0.2f\t%0.2f\n',TotalLegMvt(6).Disp(i,1),TotalLegMvt(6).Disp(i,2)); % Pillar_R3
    end
    fclose(fid);
    pause(1);
    close(f);
else
    f = msgbox('Imposible to open the open the file to save the data ');
end






end

