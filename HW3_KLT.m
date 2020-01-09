%% 
%KLT Compression/Reconstruction For Set1
%Author Yifan_Lu
myFolder = 'C:\Users\luyif\Desktop\ECE278C\HW3\hw3_imgs\set_1';
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
%   imshow(imageArray);  % Display image.
%   drawnow; % Force display to update immediately.
end

nImages = k-1;                     %total number of images
imsize = size(imageArray);       %size of image (they all should have the same size) 
x = double(x)/255;               %convert to double and normalize
%Calculate the average
avrgx = mean(x')';
for i=1:1:nImages
    x(:,i) = x(:,i) - avrgx; % substruct the average
end;

%compute covariance matrix
for keep = 1:20
    cov_mat = x'*x;
    [V,D] = eig(cov_mat);
    if keep < 20
        V(:,1:20-keep) = 0;
        V = x*V*(abs(D))^-0.5;
        KLCoef = x'*V;
        reconstruct_set1 = V*KLCoef';
        RMSE(keep) = (sqrt(mean((x(:) - reconstruct_set1(:)).^2)));
    else
        V = x*V*(abs(D))^-0.5;
        KLCoef = x'*V;
        reconstruct_set1 = V*KLCoef';
        RMSE(keep) = (sqrt(mean((x(:) - reconstruct_set1(:)).^2)));
    end    
end
reconstruct_set1 = V*KLCoef';
RMSE_Set1 = (sqrt(mean2((x - reconstruct_set1).^2)))
% figure(1)
% f1 = plot(RMSE)
% title('RMSE');
% xlabel('Number of Coef kept');
% ylabel('MSRE')
% saveas(f1,'C:\Users\luyif\Desktop\ECE278C\HW3\RMSE_Plot.png')
% % subplot(1,2,2); imshow((reshape(avrgx+x(:,1), imsize)));title('original');
% figure(2)
for k = 1:20 
    f2 = subplot(5,4,k);imshow((reshape(avrgx+reconstruct_set1(:,k), imsize)));
end 
% saveas(f2,'C:\Users\luyif\Desktop\ECE278C\HW3\Reconst_Images.png')

KLCoef1 = KLCoef;
%-----------------------------------------------DCT---------------------------------------------------------------
%% KLT compression/Reconst for Set2 using Set1 coefs
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
  x2(:,k) = imageArray(:);
  k = k+1;
%   imshow(imageArray);  % Display image.
%   drawnow; % Force display to update immediately.
end

nImages = k-1;                     %total number of images
imsize = size(imageArray);       %size of image (they all should have the same size) 
x2 = double(x2)/255;               %convert to double and normalize
%Calculate the average
avrgx = mean(x2')';
for i=1:1:nImages
    x2(:,i) = x2(:,i) - avrgx; % substruct the average
end;

%compute covariance matrix
%for keep = 1:5
    cov_mat = x2'*x2;
    [V2,D] = eig(cov_mat);
     V2 = x2*V2*(abs(D))^-0.5;
%     if keep < 20
%         V2(:,1:20-keep) = 0;
%         V2 = x*V2*(abs(D))^-0.5;
%         KLCoef = x'*V2;
%         reconstruct_set1 = V2*KLCoef';
%         RMSE(keep) = mean(sqrt(mean((x - reconstruct_set1).^2)));
%     else
%         V2 = x*V2*(abs(D))^-0.5;
%         KLCoef = x'*V2;
%         reconstruct_set1 = V2*KLCoef';
%         RMSE(keep) = mean(sqrt(mean((x - reconstruct_set1).^2)));
%     end
    
%end
reconstruct_set2 = V2*KLCoef1';
RMSE_Set2 = sqrt(mean2((x - reconstruct_set2).^2))
for k = 1:20 
    subplot(5,4,k);imshow((reshape(avrgx+reconstruct_set2(:,k), imsize)));
end 


