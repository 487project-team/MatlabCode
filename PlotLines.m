function  outputangle = PlotLines(linez,BWimg)
lines = linez;
i = 0;
%find center of image
center = round(size(BWimg)/2);
centerx = center(1,2);
centery = center(1,1);
centerarea = round((center(1,1))/4);

%exit function if no lines were detected
 lenlin = length(lines);
 if lenlin == 0
     outputangle = 400;
     return;
 end

%delete hough lines not originating from origin of face
y=0; x=0;
if lenlin > 0
    for k = 1:lenlin
        if abs(centerx - lines(lenlin - k+1).point1(1)) < centerarea && ...
           abs(centery - lines(lenlin - k+1).point1(2)) < centerarea
                    x = x + lines(lenlin - k+1).point2(1);
                    y = y + lines(lenlin - k+1).point2(2);
        elseif  abs(centerx - lines(lenlin - k+1).point2(1)) < centerarea && ...
                abs(centery - lines(lenlin - k+1).point2(2)) < centerarea
                    x = x + lines(lenlin - k+1).point1(1);
                    y = y + lines(lenlin - k+1).point1(2);
        else % if not near center, delete struct
                    lines(lenlin - k+1) = [];
                    % if all lines are not near center, no value is printed
                    i = i + 1;
                    if i == lenlin
                        outputangle = 400;
                        return
                    end
        end
    end
    lenlin = length(lines);
    y = y/lenlin;
    x = x/lenlin;
    
    xr = x - centerx;
    yr = centery - y;
    [anglez, ~] = cart2pol(xr,yr);
    outputangle = anglez/pi*180;
end

%plot lines
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
end

% highlight the longest line segment
plot([centerx x],[centery y],'LineWidth',2,'Color','red');
% caption = sprintf(['%.1f^o'], outputangle);
% text(10, 20, caption, 'Clipping',1,'BackgroundColor','black',...
%     'FontSize', 20, 'color', 'red');
% hold off;
end