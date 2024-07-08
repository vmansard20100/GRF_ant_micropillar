function [FileName2,Nini,Nmax]=vm_ListAllImage(FileName)
%[FileName2,Nini,Nmax]=vm_ListAllImage(FileName)
% list all image of a folder Filename

DIR=dir(FileName);

if(isempty(DIR))
    FileName2='';
    Nini=NaN;
    Nmax=0;
elseif(length(DIR)==1)
    [~,Name1,Ext] = fileparts(DIR(1) .name);
    isstrprop(Name1(end),'digit');
    Nini=str2num(Name1(end));
    Ndigit=1;
    FileName2=fullfile(DIR(1).folder,...
        [Name1(1:end-Ndigit) '%0.' num2str(Ndigit) 'd' Ext]);
    FileName2=strrep(FileName2,'\','/');
    Nmax=1;
    

else
    [~,Name1,Ext] = fileparts(DIR(1) .name);

    FI=find( isstrprop(Name1,'digit')==0);
    Ndigit=length(Name1)-FI(end);
    FileName2=fullfile(DIR(1).folder,...
        [Name1(1:end-Ndigit) '%0.' num2str(Ndigit) 'd' Ext]);
    FileName2=strrep(FileName2,'\','/');
    i=0;
    while(~exist(sprintf(FileName2,i),'file'))
        i=i+1;
    end
    Nini=i;
    
    i=1;
    while(exist(sprintf(FileName2,i+Nini-1),'file'))
        i=i+1;
    end
    Nmax=i-1;
end
    
    

