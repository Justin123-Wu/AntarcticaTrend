function [lvlType1, lvlType2, etime, press, pFlag, gph, zFlag, temp, tFlag, rh, dpdp, wdir, wspd ] = parseAntLine( line ) %string input, and output is the corresponding data columns which correspond to the documentation provided 
% -------------------------------
% Variable        Columns Type  
% -------------------------------
% LVLTYP1         1-  1   Integer
% LVLTYP2         2-  2   Integer
% ETIME           4-  8   Integer
% PRESS          10- 15   Integer
% PFLAG          16- 16   Character
% GPH            17- 21   Integer
% ZFLAG          22- 22   Character
% TEMP           23- 27   Integer
% TFLAG          28- 28   Character
% RH             29- 33   Integer
% DPDP           35- 39   Integer
% WDIR           41- 45   Integer
% WSPD           47- 51   Integer
% -------------------------------
%line = '20 -9999  67700 -9999  -311B-9999    22 -9999 -9999'

lvlType1= str2double(line(1:1));
lvlType2= str2double(line(2:2));
etime = parseETime( line );
press = str2double(line(10:15));
pFlag = line(16:16);
gph = str2double(line(17:21));
zFlag = line(22:22);
temp = str2double(line(23:27));
tFlag = line(28:28);
rh = str2double(line(29:33));
dpdp = str2double(line(35:39));
wdir = str2double(line(41:45));
wspd = str2double(line(47:51));


%cleaning the data
if dpdp==-9999
    dpdp=nan;
else
    dpdp = dpdp/10;
end

if gph<0
    gph = nan;
end

if temp==-9999 
    temp=nan;
elseif temp == -8888
    temp=nan;
else
    temp = temp/10;
end

if wspd==-9999 
    wspd=nan;
elseif wspd == -8888
    wspd=nan;
else
    wspd = wspd/10;
end

if press==-9999
    press=nan;
end

if rh==-9999
    rh=nan;
elseif rh == -8888
    rh=nan;
end
rh=rh/10;

end

%----------------------------------------------------------
% elapsed time 
%  ETIME           4-  8   Integer
%
%ETIME		is the elapsed time since launch. The format is MMMSS, where
%		MMM represents minutes and SS represents seconds, though
%		values are not left-padded with zeros. The following special
%		values are used:
%
%		-8888 = Value removed by IGRA quality assurance, but valid
%		        data remain at the same level.
%		-9999 = Value missing prior to quality assurance.
%
%----------------------------------------------------------
function et_sec = parseETime( line )
    tmp = str2double(line(4:8));
    if tmp<0
        et_sec = nan;
        return;
    end
    mmm_str = strtrim(line(4:6));
    sec_str = strtrim(line(7:8));

    mmm=0;
    if ~isempty(mmm_str)
        mmm = str2double( mmm_str );
    end
    ss = 0;
    if ~isempty(sec_str)
        ss = str2double( sec_str );
    end
    et_sec = 60*mmm + ss;
end
