function vargout=ploth(varargin)

plotedit on;
HOLD=ishold;
hold on
PL1=plot(varargin{:});

if(~HOLD) hold off; end;
if(nargout==1)
    vargout=PL1;
end;
end
