% PlotBehavioralMDResults
%   Reads a mat file aggregating the mean behavioral measures recorded on
%   multiple days per fish (feedingAssayCollatedDataMD.mat) and plots
%   behavioral measures over two points of dev (5 and 13-15),
%   Code by Lilach Avitan (2020).



%% Plot behavioral measures collected for fish imaged on multiple days (Figure1L,M FigureS1 M-P)
%%-----Loading data-------------------------
currentFolder = pwd;
dataFolder = fullfile(currentFolder, '..');
load(strcat(dataFolder,'\Data\feedingAssayCollatedDataMD.mat'));
load(strcat(dataFolder,'\Data\MDlookupTable.mat'));
data=feedingAssayCollatedData;
fishNameBehav= cellstr([num2str(data(:,1)),repmat('-f',size(data,1),1),num2str(data(:,2))]);
%--------End of loading data------------------


%------Measures name and plotting label-----
measures={'fishName','fishNum','Age','Length','Duration','Angle','Distance'...
    ,'AngleAfterBout', 'nBouts','Score','RevisedScore','%Left','Handedness','nEvents','eventRate','AbortFrac','MissFrac','HitFrac'...
    'DurationNoAbort','nBoutsNoAbort','boutPerSecNoAborts'};
measuresLabel={'fishName','fishNum','Age','Length (mm)','Duration (s)','Detection angle (deg)','Distance to prey (mm)'...
    ,'Post bout angle (deg)', 'Bouts','Score','Score','%Left','Handedness','Number of Events','Rate (event/min)','Abort ratio','Miss event fraction (%)','Hit ratio',...
    'Duration (s) ', 'Bouts','Bout/sec' };
%------End of measures name and plotting label-----


%------age group color----------------
color5dpf=[65,105,225]./255;  % blue   5 dpf
color9dpf=[255,165,0]./255;     % orange 8/9 dpf
color15dpf=[0,128,0]./255;      % green  13-15 dpf
%------end of age group color---------

measures2Plot=[18,16,15,19,21,6];
for ind=1:length(measures2Plot)
    measureInd=measures2Plot(ind);
    vec1=[];vec2=[];
      for fishInd=1:size(lookuptable,1)
       lookuptable(fishInd,1);
       fishIndex1=find(strcmp(lookuptable(fishInd,1),fishNameBehav));
       fishIndex2=find(strcmp(lookuptable(fishInd,2),fishNameBehav));
    
     vec1=[vec1,data(fishIndex1,measureInd)];
     vec2=[vec2, data(fishIndex2,measureInd)];
     vec1=vec1(setdiff(1:length(vec1),find(isnan(vec1))));
     vec2=vec2(setdiff(1:length(vec1),find(isnan(vec1))));
     
    end
    figure;
    errorbar(1,mean(vec1),std(vec1)/sqrt(length(vec1)),'-s','MarkerSize',10,'MarkerEdgeColor','black','MarkerFaceColor','black','Color','k');hold on;
    errorbar(2,mean(vec2),std(vec2)/sqrt(length(vec2)),'-s','MarkerSize',10,'MarkerEdgeColor','black','MarkerFaceColor','black','Color','k');
    hold on;
    plot(1,vec1,'.','Color',color5dpf,'MarkerSize',14);hold on;
    plot(2,vec2,'.','Color',color15dpf,'MarkerSize',14);hold on;
    plot([1,2],[vec1' vec2'],'Color','k')
    
    set(gca,'XLim',[0.5,2.8],'XTick',[1,2],'XTickLabel',{'5', '13'},'YLim',[0,1.1*max(get(gca,'YLim'))])
    xlabel('Age (dpf)');
    ylabel(measuresLabel(measureInd))
    [h,p]=ttest(vec1,vec2);
        text(0.35, 0.9,renderPvalueString(p),'FontSize',12,'Units','Normalized')

    
end
  

