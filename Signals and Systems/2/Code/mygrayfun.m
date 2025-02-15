function gray_image = mygrayfun(image)
    gray_image = 0.299 * image(:,:,1) + 0.578 * image(:,:,2) + 0.114 * image(:,:,3);
end