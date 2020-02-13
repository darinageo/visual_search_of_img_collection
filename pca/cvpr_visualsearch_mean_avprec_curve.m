%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
%%
%% cvpr_visualsearch.m
%% Skeleton code provided as part of the coursework assessment
%%
%% This code will load in all descriptors pre-computed (by the
%% function cvpr_computedescriptors) from the images in the MSRCv2 dataset.
%%
%% It will pick a descriptor at random and compare all other descriptors to
%% it - by calling cvpr_compare.  In doing so it will rank the images by
%% similarity to the randomly picked descriptor.  Note that initially the
%% function cvpr_compare returns a random number - you need to code it
%% so that it returns the Euclidean distance or some other distance metric
%% between the two descriptors it is passed.
%%
%% (c) John Collomosse 2010  (J.Collomosse@surrey.ac.uk)
%% Centre for Vision Speech and Signal Processing (CVSSP)
%% University of Surrey, United Kingdom

close all;
clear all;

% %% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = '/Users/darinageorgieva/Documents/dev/uni/cvprlab/labs/cw/MSRC_ObjCategImageDatabase_v2';
% 
% %% Folder that holds the results...
DESCRIPTOR_FOLDER = '/Users/darinageorgieva/Documents/dev/uni/cvprlab/labs/cw/cwork_basecode_2012/descriptors';
% %% and within that folder, another folder to hold the descriptors
% %% we are interested in working with

% combined edgeOrientHist globalRGBhisto spatialGrid
DESCRIPTOR_SUBFOLDER='combined';


%% 1) Load all the descriptors into "ALLFEAT"
%% each row of ALLFEAT is a descriptor (is an image)
ALLFEAT=[];
ALLFILES=cell(1,0);
ctr=1;
allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
allfiles(strncmp({allfiles.name},'.',1))=[];
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full))./255;
    featfile=[DESCRIPTOR_FOLDER,'/',DESCRIPTOR_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    load(featfile,'F');
    ALLFILES{ctr}=imgfname_full;
    ALLFEAT=[ALLFEAT ; F];
    ctr=ctr+1;
end

%% 2) Pick an image at random to be the query
NIMG=size(ALLFEAT,1);           % number of images in collection
%queryimg=floor(rand()*NIMG);    % index of a random image

% 13 5 11 10
queryimg=10;


%% 3) Compute the distance of image to the query
[FPCA, U, V] = cvpr_pca(ALLFEAT');
ALLFEAT = FPCA'; 

total_mean_av_prec = [];
number_of_img = [];
for img_idx=1:23

    queryimg = img_idx;
    dst=[];
    for i=1:NIMG
        candidate=ALLFEAT(i,:);
        candidateclass = get_class(allfiles(i).name);
        query=ALLFEAT(queryimg,:);
        %% Distance measure:
        thedst = cvpr_compare_Mahalanobis(query, candidate, V'); 
        dst=[dst ; [thedst i candidateclass]];
    end
    dst=sortrows(dst,1);  % sort the results

    %% 4) Visualise the results
    %% These may be a little hard to see using imgshow
    %% If you have access, try using imshow(outdisplay) or imagesc(outdisplay)

    SHOW=15; % Show top 15 results
    [precision, recall, average_precision] = pr_curve(dst, SHOW);
    total_mean_av_prec = [total_mean_av_prec; average_precision]
    number_of_img = [number_of_img; img_idx]
    
    dst=dst(1:SHOW,:);
    outdisplay=[];
    for i=1:size(dst,1)
       img=imread(ALLFILES{dst(i,2)});
       img=img(1:2:end,1:2:end,:); % make image a quarter size
       img=img(1:81,:,:); % crop image to uniform size vertically (some MSVC images are different heights)
       outdisplay=[outdisplay img];
    end
end
imgshow(outdisplay);
axis off; 

%% Plot the PR Curve!
p = plot(number_of_img, total_mean_av_prec);
[n, ~] = size(total_mean_av_prec)
title(['Mean Average Precision ', num2str(sum(total_mean_av_prec)./n)])
ylabel('average precision per class')
xlabel('class of image')
ylim([0 0.25])
p.LineWidth = 1;
p.Marker = 'o';
