close all;
clear all;

%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = '/Users/darinageorgieva/Documents/dev/uni/cvprlab/labs/cw/MSRC_ObjCategImageDatabase_v2';

%% Folder that holds the results...
DESCRIPTOR_FOLDER = '/Users/darinageorgieva/Documents/dev/uni/cvprlab/labs/cw/cwork_basecode_2012/descriptors';
%% and within that folder, another folder to hold the descriptors
%% we are interested in working with
% combined edgeorientHist globalRGBhisto spatialGrid 
DESCRIPTOR_SUBFOLDER='globalRGBhisto';


%% 1) Load all the descriptors into "ALLFEAT"
%% each row of ALLFEAT is a descriptor (is an image)

ALLFEAT=[];
ALLFILES=cell(1,0);
ctr=1;
allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full))./255;
    thesefeat=[];
    featfile=[DESCRIPTOR_FOLDER,'/',DESCRIPTOR_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    load(featfile,'F');
    ALLFILES{ctr}=imgfname_full;
    ALLFEAT=[ALLFEAT ; F];
    ctr=ctr+1;
end

% ALLFEAT = ALLFEAT';
%% 2) Pick an image at random to be the query
NIMG=size(ALLFEAT,1);           % number of images in collection
%queryimg=floor(rand()*NIMG);    % index of a random image

% 13 5 11 10
queryimg=10;

%% 3) Compute the distance of image to the query
dst=[];
for i=1:NIMG
    candidate=ALLFEAT(i,:);
    candidateclass = get_class(allfiles(i).name);
    query=ALLFEAT(queryimg,:);
    %% Distance measure:
    thedst=cvpr_compare(query,candidate, 2);
    dst=[dst ; [thedst i candidateclass]];
end
dst=sortrows(dst,1);  % sort the results

%% 4) Visualise the results
%% These may be a little hard to see using imgshow
%% If you have access, try using imshow(outdisplay) or imagesc(outdisplay)

SHOW=15; % Show top 15 results
[precision, recall, average_precision] = pr_curve(dst, SHOW);
dst=dst(1:SHOW,:);
outdisplay=[];
for i=1:size(dst,1)
   img=imread(ALLFILES{dst(i,2)});
   img=img(1:2:end,1:2:end,:); % make image a quarter size
   img=img(1:81,:,:); % crop image to uniform size vertically (some MSVC images are different heights)
   outdisplay=[outdisplay img];
end
imgshow(outdisplay);
axis off;
