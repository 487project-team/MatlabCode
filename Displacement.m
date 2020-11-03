function  [displace] = Displacement(disp0)
clc;
%large0 = 10; small0 = 10;
% take large and small angles (ZERO button)
    % store zero angles
disp0 = 0;
if (disp0 == 0) %large0 == 0 || small0 == 0)
   disp("Tare");
   [outputlarge, outputsmall ] = DialIndicator()
else
    disp("Read");
    [outputlarge, outputsmall ] = DialIndicator()
end

if (outputlarge == 400)
    displace = 'error';
    return;
end

% establishes corrected hand angles to a 0-360 degree scale
largegauge = -1*outputlarge + 90
if (largegauge < 0)
    largegauge = largegauge + 360
end
if(outputsmall >399)
    smallgauge = outputsmall
elseif (outputsmall < 90)
    smallgauge = outputsmall + 270
else
    smallgauge = outputsmall - 90
end

    % small angle (if 0-9) gets converted to degrees
    if (smallgauge > 400)
        % determines if small number is > or < revolutions 
        if (largegauge > 180)
            smallrev = smallgauge - 401
        else
            smallrev = smallgauge - 400          
        end
    elseif (smallgauge == 400)
        smallrev = 0
    else
        smallrev = floor((360 - smallgauge)/36)
    end
    
displace = (smallrev * 360 + largegauge) / 3.6 - disp0
if (disp0 == 0)
    disp0 = displace;
end

%to fix case 2:
   % total small angle movement gives approximate total displacement
   % that gives a range the large hand should be in
   % calculated difference between lage hand angles + 360*n




end