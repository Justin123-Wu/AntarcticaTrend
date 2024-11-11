function [hasSbiRow, sbiStrengthRow, sbiThicknessRow, sbiInvTempRow, sbiInvHeightRow] = calSbiMonthlyRaw( tempProfTab )
%---------------------------------------------------------------------------
%input:
%tempProfTab: numHeightPts x 32, each row has
%           [height, day1Temp(C),day2Temp(C), ..., day31Temp(C)]
%output:
%hasSbiRow,     1 x 32, [nan, day1HasSBI, ..., day31HasSBI]
%sbiStrengthRow,1 x 32, [nan, day1SbiStrength, ..., day31SbiStrength] 
%sbiThicknessRow,   1 x 32, [nan, day1SbiDepth, ..., day31SbiDepth] 
%sbiInvTempRow,1 x 32, [nan, day1SbiInversionTemperature, ..., day31SbiInversionTemperature] 
%sbiInvHeightRow,   1 x 32, [nan, day1SbiInversionHeight, ..., day31SbiInversionHeight] 
%---------------------------------------------------------------------------
hasSbiRow = nan(1,32);
sbiStrengthRow = nan(1,32);
sbiThicknessRow = nan(1,32);
sbiInvTempRow = nan(1,32);
sbiInvHeightRow = nan(1,32);

%[yy,mm,dd, isSbiFlag, sbiStrength(c), sbiThickeness]
%isSbiFlag: 0 non-SBI
%isSbiFlag: 1 SBI
%isSbiFlag: -1 unknown
for dd=1:31
    [isSBI,strength_c, thickness_m, inversionTemp_c, inversionHeight_m] = checkSBI4OneDayObservation(tempProfTab(:,1), tempProfTab(:,1+dd));
    
    hasSbiRow(1+dd) = isSBI;
    sbiStrengthRow(1+dd) = strength_c;
    sbiThicknessRow(1+dd) = thickness_m;
    sbiInvTempRow(1+dd) = inversionTemp_c;
    sbiInvHeightRow(1+dd) = inversionHeight_m;
end

end

%given interploted height and temperature for one day, check if there is an
%SBI. if present, calculate its strength and thickness
function [isSBI,strength_c, thickness_m, inversionTemp_c, inversionHeight_m] = checkSBI4OneDayObservation(vH, vT )
assert( length(vT) == length(vH) );

%not robust
%[isSBI,strength_c, thickness_m, inversionTemp_c, inversionHeight_m] = sbi_method1( vH, vT);

[isSBI,strength_c, thickness_m, inversionTemp_c, inversionHeight_m] = sbi_method2( vH, vT);


end

function [isSBI,strength_c, thickness_m, inversionTemp_c, inversionHeight_m] = sbi_method1( vH, vT)

strength_c = nan;
thickness_m = nan;
inversionTemp_c = nan;
inversionHeight_m = nan;

if isnan(vT(2)) || isnan(vT(1))
    isSBI = -1; %unknown
    return;
end

if vT(2)-vT(1)<=0
    isSBI = 0; %NON-SBI
    return;
end

hasturningPoint = false;
inversionIdx = nan;
HT =  UtilFuncs.remove_nan( [vH(:), vT(:)] );
[m, ~] = size(HT);
for i = 3 : m
    if HT(i,2) - HT(i-1,2) <= 0
        hasturningPoint = true;
        inversionIdx = i-1;
        break
    end
end

if( hasturningPoint)
    isSBI = 1;
    strength_c = HT(inversionIdx, 2)  - HT(1, 2);  %temperature (C)
    thickness_m = HT(inversionIdx, 1) - HT(1, 1);  %height (m)
    inversionTemp_c =  HT(inversionIdx, 2);
    inversionHeight_m = HT(inversionIdx, 1);
else
    isSBI = 0; %NON-SBI
end

end


function [isSBI,strength_c, thickness_m, inversionTemp_c, inversionHeight_m] = sbi_method2( vH, vT)

isSBI = -1;  %unknown
strength_c = nan;
thickness_m = nan;
inversionTemp_c = nan;
inversionHeight_m = nan;

if isnan(vT(1))
    return;
end

[maxT, idx] = max(vT);
if isnan(maxT)
    return;
end

thickness_m = vH(idx) - vH(1);
if thickness_m<10 || thickness_m>1600
    isSBI = 0; %Non-SBI
    thickness_m = nan;
    return;
end


isSBI = 1;  %SBI
strength_c = maxT-vT(1);
inversionTemp_c = vT(idx);
inversionHeight_m = vH(idx);

end