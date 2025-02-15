function [a,B] = p2_4(x,y)
    N = length(x);
    S_xx = sum(x.*x,"all");
    S_y = sum(y,"all");
    S_xy = sum(x.*y,"all"); 
    S_x = sum(x,"all");

    a = (N*S_xy - S_x*S_y) / (N*S_xx - S_x*S_x);
    B = (S_y*S_xx - S_x*S_xy) / (N*S_xx - S_x*S_x);
end

