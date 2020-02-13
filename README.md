# Computer Vision and Pattern Recognition Assignment - Visual Search of an Image Collection

The visual search application accepts an image as a search query and returns a list of images in the collection ranked according to their similarity.

Experiments with different image discriptors such as Global colour histogram, Spatial Grid, Spatial grid with texture and colour, PCA are conducted.

The dataset that is used for the project is the Microsoft Research (MSVC-v2) dataset of 591 images (20 classes).


In order to run the descriptors, you should open the selected descriptor folder. Then, run the file cvpr_computedescriptor.m to compute the descriptor and then run the cvpr_visualsearch.m file to check the query results and see the PR curve. The dataset path and descriptor need to be changed accordingly to the path on the machine they are run on. 