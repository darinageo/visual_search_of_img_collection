function [precision, recall, average_precision] = pr_curve(searchquery, TOTALIMAGES)

% Function to calculate the precision and recall curve and 
% the average precision for the visual search query
%% Input params:
% searchquery:        Query image 
% TOTALIMAGES:        Total number if images
%% Output:
% F:        [precion of the query; recall of the query]

precision = [];
recall = [];

queryclass = searchquery(1,3);
relevant = sum(searchquery(:,3)==queryclass);

for retrived = 1:TOTALIMAGES
    retrived_relevant = sum(searchquery(1:retrived,3)==queryclass);
    
    curr_precision = retrived_relevant/retrived;
    curr_recall = retrived_relevant/relevant;

    precision = [precision; curr_precision];
    recall = [recall; curr_recall];
end

average_precision = sum(precision.*(searchquery(1:TOTALIMAGES,3)==queryclass))/relevant;

%% Plot the PR Curve!
p = plot(recall, precision);
title(['Average Precision: ', num2str(average_precision)])
xlabel('Recall')
ylabel('Precision')
p.LineWidth = 1;
p.Marker = 'o';
figure;


return;
