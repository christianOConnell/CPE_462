sourceFolder = 'blurrednoised_images\'; %include "\" at end
fileName = 'lena_color_256_BLUR_AWGN'; %file name of image processed images have "_onlyBlur" & "_BLUR_AWGN" at end
fileExt = '.tif';

outputFolder = 'inverse\'; %include "\" at end

file=strcat(sourceFolder, fileName, fileExt);
f = im2double(imread(file)); %reads image converts values to doubles
figure(1), imshow(f), title("Distorted Image (Blur Only)"); %displays img in figure and saved in output folder
imwrite(f,strcat(outputFolder,fileName,fileExt));

[m, n, p] = size(f);
bFunct = fspecial('motion',10, 0);
D = fft2(bFunct,m,n);

%smoothing to try and remove some noise.

for v = 1: p
    f(1:m,1:n,v)=medfilt2(f(1:m,1:n,v),[5 5]); %run denoise algorithm on input image before iterative processing
end
 figure(2), imshow(f), title("Blur & AWGN Image With Only Median Filter Applied");

F=fft2(f);

%nFunct=ones(5,5)/(25);
%N=fft2(nFunct,m,n);
% S=F-N;
% s=abs(ifft2(S));
% figure(2),imshow(s);

t=0.2; %limit for values in H to prevent output values from being too large.
i=find(abs(D)<t);
D(i)=t; %all values of |H|<t are found and set to t
B1=ones(m,n,p)./D; %inverse of H

Y=F.*B1; %F/H

y=abs(ifft2(Y));
figure(3), imshow(y), title("Inverse Restoration of Blur & AWGN"); %displays restored image
imwrite(y,strcat(outputFolder,fileName,'_RESTORED_t',string(t),fileExt)); %saves restored image to output folder with t that was used

