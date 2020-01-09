%% 
%DCTCompression/Reconstruction For Set
%Author Yifan_Lu
myFolder = 'C:\Users\luyif\Desktop\ECE278C\HW3\hw3_imgs\set_2';
if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end
filePattern = fullfile(myFolder, '*.png');
jpegFiles = dir(filePattern);
k=0;
for k = 1:length(jpegFiles)
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  imageArray = imread(fullFileName);
  x(:,k) = imageArray(:);
  k = k+1;
end
nImages = k-1;                     %total number of images
imsize = size(imageArray);       %size of image (they all should have the same size) 
x = double(x)/255;               %convert to double and normalize
%Calculate the average
avrgx = mean(x')';
for i=1:1:nImages
    x(:,i) = x(:,i) - avrgx; % substruct the average
end;

dummy_sorted = zeros(size(x));
keep = 100;
Reconst_D = double(zeros(size(x)));
for j = 1:1:nImages
    dummy = dct2(reshape(x(:,j),imsize));
    A = dummy(:);
    A = A.*0;
    [value,index] = maxk(dummy(:),keep);    
    for kk = 1:length(index)
        A(index(kk)) = value(kk);
    end
    A = reshape(A,imsize);
    y = idct2(A);
    Reconst_D(:,j) = y(:);
end
RMSE_Set = (sqrt(mean2((x - Reconst_D).^2)))

for kkk = 1:20 
    subplot(5,4,kkk);imshow((reshape(avrgx+Reconst_D(:,kkk), imsize)));
end 
