/**********************************************************************************
usage: ImageProc file/path/to/image.jpg
image can be in color, but will be output in grayscale
 **********************************************************************************/


#include <iostream>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "opencv2/imgproc/imgproc.hpp"
#include <opencv2/opencv.hpp>

using namespace std;
using namespace cv;

int main(int argc, char* argv[])
{
	FILE* in, * out;
	int   j, k, width, height;
	int** image_in, ** image_out;
	float sum1, sum2;
	float new_T, old_T, delta_T;
	long count1, count2;
	errno_t err;

	

	Mat image;
	Mat newImage;
	
	image = imread(argv[1], IMREAD_GRAYSCALE);
	if (!image.data) {
		cout << "Could not open the image file" << endl;
		return -1;
	}
	else {
		int height = image.rows;
		int width = image.cols;

		newImage = image.clone();
		//negative 

		/*for (j = 0; j < height; j++)
			for (k = 0; k < width; k++)
			{
				newImage.at<uchar>(j, k) = 255 - image.at<uchar>(j, k);
			}
			*/

		//histogram equalization

		double hist[256];
		double map[256];
		double pixel_val = 1.0 / (height * width);
		for (j = 0; j < 256; j++) {
			hist[j] = 0;
			map[j] = 0;
		}
		for (j = 0; j < height; j++) {
			for (k = 0; k < width; k++) {
				hist[image.at<uchar>(j, k)] += pixel_val;
			}
		}
		for (j = 0; j < 256; j++) {
			for (k = 0; k < j+1; k++) {
				map[j] += hist[k];
			}
			map[j] = floor(map[j] * 255);
		}
		for (j = 0; j < height; j++) {
			for (k = 0; k < width; k++) {
				newImage.at<uchar>(j, k) = (int) map[image.at<uchar>(j,k)];
			}
		}
		

		//3x3 mask									0 -1 0
		//using the following laplacian operator	-1 4 -1
		//											0 -1 0

		/*int32_t maskSum;
		
		for (j = 0; j < height; j++) {
			for (k = 0; k < width; k++) {
				if (!(j == 0 || k == 0 || (j == height - 1) || (k == width - 1))) {
					maskSum = 0;
					maskSum -= image.at<uchar>(j - 1, k);
					maskSum -= image.at<uchar>(j + 1, k);
					maskSum -= image.at<uchar>(j, k - 1);
					maskSum -= image.at<uchar>(j, k + 1);
					maskSum += 4 * image.at<uchar>(j, k);
					if (maskSum > 0)
						newImage.at<uchar>(j, k) = maskSum;
					else
						newImage.at<uchar>(j, k) = 0;
				}
				else
					newImage.at<uchar>(j, k) = 0;
			}
		}
		
		*/

		//improved contrast by thresholding
		//Displays image each time contrast/threshold is iterated

		/*
		int thresh = 127; //arbitrary starting value
		int oldThresh = 127;
		double underAvg;
		double overAvg;
		uint32_t underSum = 0;
		uint32_t overSum = 0;
		uint32_t underCount = 0;
		uint32_t overCount = 0;
		while (true)
		{
			underSum = 0;
			overSum = 0;
			underCount = 0;
			overCount = 0;
			for (j = 0; j < height; j++)
				for (k = 0; k < width; k++)
				{
					if (image.at<uchar>(j, k) > thresh) {
						overSum += image.at<uchar>(j, k);
						overCount++;
						newImage.at<uchar>(j, k) = 255;
					}
					else {
						underSum += image.at<uchar>(j, k);
						underCount++;
						newImage.at<uchar>(j, k) = 0;
					}
				}
			overAvg = (double)overSum / overCount;
			underAvg = (double)underSum / underCount;
			oldThresh = thresh;
			thresh = 0.5 * (overAvg + underAvg);
			cout << thresh << endl;
			if (abs(oldThresh - thresh) <= 5)
				break;
			namedWindow("New Image", WINDOW_AUTOSIZE);
			imshow("New Image", newImage);
			waitKey(0);
		}

		*/

		bool worked = imwrite("mynewimg.jpg", newImage);
		if (!worked)
			cout << "failure\n";
		else
			cout << "success\n";
		namedWindow("Original Image", WINDOW_AUTOSIZE);
		imshow("Original Image", image);
		namedWindow("New Image", WINDOW_AUTOSIZE);
		imshow("New Image", newImage);
		waitKey(0);
		image.release();
		newImage.release();
	}

	return(0);
}



