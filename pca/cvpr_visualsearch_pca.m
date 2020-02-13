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
DESCRIPTOR_SUBFOLDER='globalRGBhisto';


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
%     fprintf('%s\n', fname);
    img=double(imread(imgfname_full))./255;
%     thesefeat=[];
    featfile=[DESCRIPTOR_FOLDER,'/',DESCRIPTOR_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    load(featfile,'F');
    ALLFILES{ctr}=imgfname_full;
    ALLFEAT=[ALLFEAT ; F];
    ctr=ctr+1;
end

%% 2) Pick an image at random to be the query
NIMG=size(ALLFEAT,1);           % number of images in collection
queryimg=floor(rand()*NIMG);    % index of a random image


%% 3) Compute the distance of image to the query
[FPCA, vct, val] = cvpr_pca(ALLFEAT'); 
ALLFEAT = FPCA'; 

dst=[];
for i=1:NIMG
    candidate=ALLFEAT(i,:);
    query=ALLFEAT(queryimg,:);
    candidate_class = get_class(allfiles(i).name);
    thedst = cvpr_compare_Mahalanobis(query, candidate, val'); % Uncomment to use Mahalanobis distance
    dst=[dst ; [thedst i candidate_class]];
end
dst=sortrows(dst,1);  % sort the results
% cvpr_prcurve(dst, NIMG);


%% 4) Visualise the results
%% These may be a little hard to see using imgshow
%% If you have access, try using imshow(outdisplay) or imagesc(outdisplay)

SHOW=15; % Show top 15 results, modify for more image visualisations
[precision, recall] = pr_curve(dst, SHOW); % Change SHOW to NIMG for complete PR Curve
truncdst=dst(1:SHOW,:);
outdisplay=[];
for i=1:size(truncdst,1)
    img=imread(ALLFILES{truncdst(i,2)});
    img=img(1:2:end,1:2:end,:); % make image a quarter size
    img=img(1:81,:,:); % crop image to uniform size vertically (some MSVC images are different heights)
    outdisplay=[outdisplay img];
end
    imshow(outdisplay);
axis off;
