function [h,p,test]=compareMean(vec1, vec2)
    warning('off')
    [h1,p1] = adtest(vec1,'Distribution','normal');
    [h2,p2] = adtest(vec2,'Distribution','normal');
    if or(h1==1, h2==1)
        [p,h] = ranksum(vec1,vec2);
        test='Wilcoxon';
    else
         [h,p]=ttest2(vec1,vec2);
         test='ttest2';
    end
end