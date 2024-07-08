function vm_save_image(fname,SIZE,fig,ChClick,Resolution)
% vm_save_image(fname,SIZE,fig,ChClick,Resolution)
% Function to save a figure into a .png and .mat file


% you run the function then you type a name of the figure then you
%click on the figure
%then it's done
%
%To change the finale size of the fig, you have to modify the variable SIZE
FONTSIZE=10;
if(~exist('fname','var'))
    fname='figure_save';
end

if(~exist("SIZE",'var'))
    SIZE=[1 1]*7; % size of the figure in cm
end
if(~exist("fig",'var'))
    fig=gcf;
end
if(~exist('ChClick','var'))
    ChClick=1;
end
if(~exist('Resolution','var'))
    Resolution='-r500';
end

savefig([fname '.fig']);


isdock=get(fig,'WindowStyle');
pos0=get(fig,'Position');
units=get(fig,'unit');

AxesBoxe=get(fig,'Children');
AxesBoxe=AxesBoxe(isgraphics(AxesBoxe,'axes'));
for i=1:length(AxesBoxe)
    xlimmode{i}=get(AxesBoxe(i),'XLimMode');
    ylimmode{i}=get(AxesBoxe(i),'YlimMode');
    fs{i}=get(AxesBoxe(i),'fontsize');
    ylab{i}=get(AxesBoxe(i),'ylabel');
    xlab{i}=get(AxesBoxe(i),'xlabel');
    fsy{i}=get(ylab{i},'fontsize');
    fsx{i}=get(xlab{i},'fontsize');
    xtm{i}=get(AxesBoxe(i),'XtickMode');
    ytm{i}=get(AxesBoxe(i),'YtickMode');
end





for i=1:length(AxesBoxe)
    set(AxesBoxe(i),'XLimMode','manual');
    set(AxesBoxe(i),'YLimMode','manual');
    set(AxesBoxe(i),'XtickMode','Manual');
    set(AxesBoxe(i),'YtickMode','Manual');
    set(AxesBoxe(i),'LineWidth',1);
    set(AxesBoxe(i),'fontsize',FONTSIZE);
    set(AxesBoxe(i),'Box','on');
    set(xlab{i},'fontsize',FONTSIZE);
    set(ylab{i},'fontsize',FONTSIZE);

    Lines=get(AxesBoxe(i),'Children');
    Lines=Lines(isgraphics(Lines,'line'));
    for j=1:length(Lines)
        % set(Lines(j),'Linewidth',1);
    end
end
pos1=[2 4 SIZE];
set(fig,'windowStyle','normal');
set(fig,'Units','centimeters')
set(fig,'PaperUnits','centimeters')
set(fig,'position',pos1,'PaperPosition',[0 0 pos1(3) pos1(4) ],'PaperSize',[pos1(3) pos1(4)]);





figure(fig);
if(ChClick==1)
    display('click on the figure if it looks fine');
    bp=waitforbuttonpress;
end
f = msgbox(['Wait while we save the figure into: ' fname '.png']);
% print('-dpdf',[fname '.pdf']);
print(fig,'-dpng',[fname '.png'],Resolution);
% print('-dmeta',[fname '.emf']);
delete(f);

set(fig,'units',units);
set(fig,'position',pos0);
set(fig,'WindowStyle',isdock);
for i=1:length(AxesBoxe)
    set(AxesBoxe(i),'XLimMode',xlimmode{i});
    set(AxesBoxe(i),'YLimMode',ylimmode{i});
    set(AxesBoxe(i),'fontsize',fs{i});
    set(xlab{i},'fontsize',fsx{i});
    set(ylab{i},'fontsize',fsy{i});
    set(AxesBoxe(i),'XtickMode',xtm{i});
    set(AxesBoxe(i),'YtickMode',ytm{i});
end
end
