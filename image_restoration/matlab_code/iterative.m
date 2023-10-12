clear;
fileName = 'lena_color_512_BLUR_AWGN'; %file name of image processed images have "_onlyBlur" & "_BLUR_AWGN" at end
fileExt = '.tif';
sourceFolder = 'blurrednoised_images\'; %include "\" at end

outputFolder = 'iterative\'; %include "\" at end
file=strcat(sourceFolder, fileName, fileExt);
f = im2double(imread(file)); %reads image converts values to doubles
figure(1), imshow(f), title("Original Image"); %displays img in figure and saved in output folder
imwrite(f,strcat(outputFolder,fileName,fileExt));
[m, n, p] = size(f);
%not sure if we're allowed to denoise first or not but I think it looks a
%bit better

for v = 1: p
    f(1:m,1:n,v)=medfilt2(f(1:m,1:n,v),[3 3]); %run denoise algorithm on input image before iterative processing
end

figure(2), imshow(f),title("Denoise"); %display denoised image before iterative processing (for comparison)


i = 0.05; % I like this value but you can also try a higher i value and lower factor (in the loop below)

bFunct =fspecial('motion',8,0); %purposefully different than one applied
F = fft2(f);
B = fft2(bFunct, m, n);
Y = i*F;

for k = 1: 1000
    if mod(k, 25)==0
        i=i*0.5;
    end
    A=F-Y.*B;
    Y=Y+i.*A;
end
out = abs(ifft2(Y));

% optional: median filter denoise on output instead of input
%out=medfilt2(out,[3 3]);

figure(3), imshow(out),title("out");
imwrite(out,strcat(outputFolder,fileName,'_RESTORED_Iterative',fileExt)); %saves restored image to output folder with t that was used
