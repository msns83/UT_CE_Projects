function [L, n] = mysegmentation(image)

    [rows, cols] = size(image);
    L = zeros(rows, cols); 
    current_label = 0;                
    
    directions = [-1,  0; 1, 0; 0, -1; 0, 1; -1, -1; -1, 1; 1, -1; 1, 1]; 
    
    for r = 1:rows
        for c = 1:cols
            if image(r, c) == 1 && L(r, c) == 0
                current_label = current_label + 1;
                stack = [r, c];
                
                while ~isempty(stack)
                    pixel = stack(end, :);
                    stack(end, :) = [];  
                    r_pixel = pixel(1);
                    c_pixel = pixel(2);
                    
                    if r_pixel < 1 || r_pixel > rows || c_pixel < 1 || c_pixel > cols || L(r_pixel, c_pixel) ~= 0 || image(r_pixel, c_pixel) == 0
                        continue;
                    end
                    
                    L(r_pixel, c_pixel) = current_label;
           
                    for i = 1:size(directions, 1)
                        new_r = r_pixel + directions(i, 1);
                        new_c = c_pixel + directions(i, 2);
                        stack = [stack; new_r, new_c];
                    end
                end
            end
        end
    end
    
    n = current_label;
end
