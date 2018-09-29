function retVars = fourierLPfilter(im)
%% Modified from:
%% "How to use the MATLAB FFT2-routines" 
%% URL: http://read.pudn.com/downloads97/ebook/394767/HowToUseFFT2/HowToUseFFT2.pdf
%% Harald E. Krogstad, NTNU, 2004

CutFreq = 1E-1;
ff = fft2(im);
[H,W] = size(im); 
dx = 1;dy = 1;
hN = [0:(H-1)];
wN = [0:(W-1)];
xr = (mod(1/2 + (wN)/length(wN), 1) - 1/2);
xr = xr * (2*pi/dx);
yr = (mod(1/2 + (hN)/length(hN), 1) - 1/2);
yr = yr * (2*pi/dx);
[x,y] = meshgrid(xr,yr);
circleRegion = x.^2 + y.^2 ;
lowpassFilter=circleRegion< CutFreq^2;
retVars = ifft2(ff.*lowpassFilter);