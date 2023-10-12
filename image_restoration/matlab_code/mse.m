sourceFolder_blur = 'blurrednoised_images\'; %include "\" at end
sourceFolder_orig = 'source_images\'; %include "\" at end
fileName_blur = 'lena_color_256BN'; %file name of image processed images have "_onlyBlur" & "_BLUR_AWGN" at end
fileName_orig = 'lena_color_256'; %file name of image processed images have "_onlyBlur" & "_BLUR_AWGN" at end
fileExt = '.tif';

outputFolder = 'mse\'; %include "\" at end

file_blur=strcat(sourceFolder_blur, fileName_blur, fileExt);
file_orig=strcat(sourceFolder_orig, fileName_orig, fileExt);

f1 = im2double(imread(file_blur)); %reads image converts values to doubles
f2 = im2double(imread(file_orig)); %reads image converts values to doubles
figure(1), imshow(f1), title("Blurred Image"); %displays img in figure and saved in output folder
figure(2), imshow(f2), title("Original Image"); %displays img in figure and saved in output folder
imwrite(f1,strcat(outputFolder,fileName_blur,fileExt));
imwrite(f2,strcat(outputFolder,fileName_orig,fileExt));

disp(f1);

mse_var = immse(f1, f2);
snr = psnr(f1,f2);
psf = fspecial('gaussian',21,11);

img_restore = deconvwnr(f1, psf, snr);
imshow(img_restore);
