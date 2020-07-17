
% PlotBehavioralResults
%   Reads an a mat file aggregating the mean behavioral measures and plots
%   1) behavioral measures over dev and over body length, (Figure 1B-D,E,H,J,K) and S1(A-L)
%   2) Paramecium detection handedness (data and theoretical bound),  (Figure S1I)
%   3) Polar distributions of  detection angle per age, (Figure 1G)
%   4) Pre- and post-bout angle relation and multiple regresion analysis, (Figure1I)
%   Code by Lilach Avitan (2020).

%% Plot behavioral measures collected over age and fish length (Figure 1B-D,E,H,J,K) and S1(A-L)
%%-----Loading data-------------------------
currentFolder = pwd;
dataFolder = fullfile(currentFolder, '..');
load(strcat(dataFolder,'\Data\feedingAssayCollatedData.mat'));
data=feedingAssayCollatedData;
%--------End of loading data------------------

%------Measures name and plotting label-----
measures={'fishName','fishNum','Age','Length','Duration','Angle','Distance'...
    ,'AngleAfterBout', 'nBouts','Score','RevisedScore','%Left','Handedness','nEvents','eventRate','AbortFrac','MissFrac','HitFrac'...
    'DurationNoAbort','nBoutsNoAbort', 'boutPerSecNoAborts', 'hitNoAbort','missRatioNoABort'};
measuresLabel={'fishName','fishNum','Age','Length (mm)','Duration (s)','Detection angle (deg)','Distance to prey (mm)'...
    ,'Post bout angle (deg)', 'Bouts','Score','Score','%Left','Handedness','Number of Events','Rate (event/min)','Abort ratio','Miss ratio','Hit ratio',...
    'Duration (s) ', 'Bouts', 'Bout/sec','Hit Ratio (no aborts)', 'Miss ratio (no aborts)' };
%------End of measures name and plotting label-----

%------Fish index by grouped by age----------------
fish5Ind=find(data(:,3)==5);
fish9Ind=[find(data(:,3)==9);find(data(:,3)==8)];
fish15Ind=intersect(find(data(:,3)>=13),find(data(:,3)<=15));
color5dpf=[65,105,225]./255;  % blue   5 dpf
color9dpf=[255,165,0]./255;     % orange 8/9 dpf
color15dpf=[0,128,0]./255;      % green  13-15 dpf
%-------------------------------------------------
measures2Plot=[15,19,20,21,6,18,16,7,4,22,13];
for ind=1:length(measures2Plot)   
    %for all measures extarcted
    measureInd=measures2Plot(ind);
    if ismember(measureInd,[15,19,20,21,6,18,16,7,4,22]) 
    figure;
     vec1=data(fish5Ind,measureInd);                                        %extract measure values per age
     vec2=data(fish9Ind,measureInd);                                        %extract measure values per age
     vec3=data(fish15Ind,measureInd);                                        %extract measure values per age
     bar(1,nanmean(vec1), 'EdgeColor',[0,0,0],'FaceColor',[1,1,1]);hold on; %plot mean bar
     bar(2,nanmean(vec2),'EdgeColor',[0,0,0],'FaceColor',[1,1,1]);hold on;  %plot mean bar
     bar(3,nanmean(vec3),'EdgeColor',[0,0,0],'FaceColor',[1,1,1]);hold on;  %plot mean bar

     %plot datapoints with a small normal(0,0.05) noise on the x-axis
     plot(1+random('Normal',0,0.05,1,length(vec1)),vec1,'.','Color',color5dpf,'MarkerSize',12); hold on
     plot(2+random('Normal',0,0.05,1,length(vec2)),vec2,'.','Color',color9dpf,'MarkerSize',12); hold on
     plot(3+random('Normal',0,0.05,1,length(vec3)),vec3,'.','Color',color15dpf,'MarkerSize',12); hold on

     %--------setting x and y axes----------------
     set(gca,'XTick',[1,2,3],'XTickLabel',{'5', '9','15'},'YLim',[0,1.1*max(get(gca,'YLim'))]);
     xlabel('Age (dpf)');
     ylabel(measuresLabel(measureInd));
     if measureInd==13
         set(gca,'YLim',[-1,1]);
     end
    
     if ~(sum(isnan(vec2))==length(vec2))
      minylim=min(get(gca,'YLim'));
      maxylim=max(get(gca,'YLim'));
      set(gca,'YLim',[minylim,1.2*maxylim])  ;
      %--------------------------------------------

      %-----perform statistical tests--------------
      [h,p,test]=compareMean(vec1,vec2);
     if p<0.05
        text(0.3, 0.85,renderPvalueString(p),'FontSize',12,'Units','Normalized');
        line([1,1.8],[0.80*max(get(gca,'YLim')),0.80*max(get(gca,'YLim'))],'Color',[0,0,0]);
      end
     
      [h,p,test]=compareMean(vec2, vec3);
     if p<0.05
        if measureInd==13
            text(0.6, 0.85,renderPvalueString(p),'FontSize',12,'Units','Normalized');
            line([2.2,3],[0.65*max(get(gca,'YLim')),0.65*max(get(gca,'YLim'))],'Color',[0,0,0]);
        elseif measureInd==9
            set(gca,'YLim',[0,11.5]);
            line([2.2,3],[0.65*max(get(gca,'YLim')),0.65*max(get(gca,'YLim'))],'Color',[0,0,0]);
            text(0.6, 0.7,renderPvalueString(p),'FontSize',12,'Units','Normalized');
        else
            text(0.6, 0.85,renderPvalueString(p),'FontSize',12,'Units','Normalized');
            line([2.2,3],[0.8*max(get(gca,'YLim')),0.8*max(get(gca,'YLim'))],'Color',[0,0,0]);
       end
     end
     
     [h,p,test]=compareMean(vec1, vec3);
     if p<0.05
        if measureInd==9
        text(0.5, 0.85,renderPvalueString(p),'FontSize',12,'Units','Normalized');
        line([1,3],[0.87*max(get(gca,'YLim')),0.85*max(get(gca,'YLim'))],'Color',[0,0,0]);

        else
         text(0.5, 0.95,renderPvalueString(p),'FontSize',12,'Units','Normalized');
        line([1,3],[0.9*max(get(gca,'YLim')),0.90*max(get(gca,'YLim'))],'Color',[0,0,0]);
        end
      end
     end
    end
     %------------End of statistical tests---------------
 
     %-----plot measure as a function of length----------
     if ismember(measureInd, [15,19,20,21,6,13,18,16])
     vec1=data(fish5Ind,measureInd);                                        %extract measure values per age
     vec2=data(fish9Ind,measureInd);                                        %extract measure values per age
     vec3=data(fish15Ind,measureInd);                                        %extract measure values per age
     %plot datapoints
     figure;plot(data(fish5Ind,4),vec1,'.','Color',color5dpf,'MarkerSize',12);hold on;
     plot(data(fish9Ind,4),vec2,'.','Color',color9dpf,'MarkerSize',12);hold on;
     plot(data(fish15Ind,4),vec3,'.','Color',color15dpf,'MarkerSize',12);hold on;

     % perform linear fitting
     lm = fitlm([data(fish5Ind,4);data(fish9Ind,4);data(fish15Ind,4)],[vec1;vec2;vec3],'linear');
     fishLlength=[data(fish5Ind,4);data(fish9Ind,4);data(fish15Ind,4)];
     
         fittedLinear=lm.Coefficients.Estimate(1)+lm.Coefficients.Estimate(2)*[min(fishLlength):0.01:6];
         plot(min(fishLlength):0.01:6,fittedLinear,'Color',[127,127,127]./255,'LineWidth',2);
    
     % place statistics to the right/left oft he plot
     if ismember(measureInd,[5,9,13,16,18,19,20,21])
        hold on;text(0.75,0.95,renderPvalueString(lm.coefTest),'FontSize',12,'Units','Normalized');
        hold on;text(0.75,0.88,strcat('r^2=',num2str(floor(lm.Rsquared.Ordinary*100)/100)),'FontSize',12,'Units','Normalized');
     elseif measureInd==6
        hold on;text(0.75,0.22,renderPvalueString(lm.coefTest),'FontSize',12,'Units','Normalized');
        hold on;text(0.75,0.1,strcat('r^2=',num2str(floor(lm.Rsquared.Ordinary*100)/100)),'FontSize',12,'Units','Normalized');
     else
     hold on;text(0.05,0.95,renderPvalueString(lm.coefTest),'FontSize',12,'Units','Normalized');
     hold on;text(0.05,0.85,strcat('r^2=',num2str(floor(lm.Rsquared.Ordinary*100)/100)),'FontSize',12,'Units','Normalized');
     end
     xlabel('Length (mm)');
     ylabel(measuresLabel(measureInd));
     end
     %-----End of plot measure as a function of length----------
end

%% -----Plot handedness data and theoretical confidence interval(Figure S1I)--------
% plot data points
figure;plot(data(fish5Ind,14),data(fish5Ind,13),'.','Color',color5dpf,'MarkerSize',12);hold on;
plot(data(fish9Ind,14),data(fish9Ind,13),'.','Color',color9dpf,'MarkerSize',12)
plot(data(fish15Ind,14),data(fish15Ind,13),'.','Color',color15dpf,'MarkerSize',12)
xlabel('Number of events');
ylabel('Handedness')

%plot Bernoulli theoretical 95% confidence interval
f = @(N,x,a) 1 - 2 * betainc(0.5,N*(1+x)/2,N*(1-x)/2+1) - a;
N = [1:0.1:100];
R = arrayfun( @(n) fminbnd(@(x) abs(f(n,x,0.99)),0,1) , N , 'UniformOutput' , true );
hold on;plot( N , R,'--','Color',[127,127,127]./255 )
hold on; plot( N , -R,'--','Color',[127,127,127]./255 )
set(gca,'YLim',[-1.1,1.1])

%% plot polar distribution of  detection angle - Figure 1G
% load data
[feedingAssayRawData] = xlsread(strcat(dataFolder, '\Data\highSpeedFeedingAssayMasterList.xlsx'),'Sheet1');
[feedingAssayNum,feedingAssaytext,~]=xlsread(strcat(dataFolder, '\Data\highSpeedFeedingAssayMasterList.xlsx'),'Sheet1');
feedingAssaytextNoTitles=feedingAssaytext(2:end,:);
fishNameBehav= cellstr([num2str(feedingAssayNum(:,1)),repmat('-f',size(feedingAssayNum,1),1),num2str(feedingAssayNum(:,2))]);
[fishDatefishNumb,fishFirstRow]=unique(feedingAssayRawData(:,1:3),'rows');
fishDate=fishDatefishNumb(:,1);
fishNumb=fishDatefishNumb(:,2);
fishAge=fishDatefishNumb(:,3);
numAssayedFish=size(fishDatefishNumb,1);
feedingAssayCollatedData=zeros(numAssayedFish,3);
yInd=0; oInd=0;voInd=0;
datay=[];datao=[];datavo=[]; % detection angle
postboutangley=[];postboutangleo=[];postboutanglevo=[];
%aggragating data per age, running on all event in the excel master file
for fishInd=1:numAssayedFish 
    fishIndRows=intersect(find(feedingAssayRawData(:,1)==fishDate(fishInd)),find(feedingAssayRawData(:,2)==fishNumb(fishInd)));
    if fishAge(fishInd)==5 % age
    yInd=yInd+1;
    datay=[datay;feedingAssayRawData(fishIndRows,13)];
    postboutangley=[postboutangley;feedingAssayRawData(fishIndRows,16)];

   elseif or(fishAge(fishInd)==9,fishAge(fishInd)==8)
   oInd=oInd+1;
    datao=[datao;feedingAssayRawData(fishIndRows,13)];
    postboutangleo=[postboutangleo;feedingAssayRawData(fishIndRows,16)];

    elseif and(fishAge(fishInd)>=13,fishAge(fishInd)<=15)
    voInd=voInd+1;
    datavo=[datavo;feedingAssayRawData(fishIndRows,13)];
    postboutanglevo=[postboutanglevo;feedingAssayRawData(fishIndRows,16)];
    end
end
detectionAngley=datay;detectionAngleo=datao;detectionAnglevo=datavo;

%plot
figure; polarhistogram(deg2rad(detectionAngley),'BinEdges',deg2rad([0:10:120]),'Normalization','probability','FaceColor',color5dpf)
pax=gca;
pax.ThetaLim=[0,120] ;  
pax.ThetaDir = 'clockwise';
pax.ThetaZeroLocation = 'top'; 
pax.RAxis.Label.String ='prob';
pax.ThetaTickLabel={'0^o';'30^o';'60^o';'90^o';'120^o'};
title('5 dpf','FontWeight','Normal')


figure; polarhistogram(deg2rad(detectionAngleo),'BinEdges',deg2rad([0:10:120]),'Normalization','probability','FaceColor',color9dpf)
pax=gca;
pax.ThetaLim=[0,120] ;  
pax.ThetaDir = 'clockwise';
pax.ThetaZeroLocation = 'top'; 
pax.RAxis.Label.String ='prob';
pax.ThetaTickLabel={'0^o';'30^o';'60^o';'90^o';'120^o'};
title('9 dpf','FontWeight','Normal');


figure; polarhistogram(deg2rad(detectionAnglevo),'BinEdges',deg2rad([0:10:120]),'Normalization','probability','FaceColor',color15dpf)
pax=gca;
pax.ThetaLim=[0,120] ;  
pax.ThetaTickLabel={'0^o';'30^o';'60^o';'90^o';'120^o'};
pax.ThetaDir = 'clockwise';
pax.ThetaZeroLocation = 'top'; 
pax.RAxis.Label.String ='prob';
title('15 dpf','FontWeight','Normal')

%% ------ Plot pre- and post-bout angle relation and multiple regresion analysis - Figure1I
clear PrePostAgeData
eventInd=find(~isnan(postboutangley));
PrePostAgeData=[detectionAngley(eventInd),repmat(5,length(detectionAngley(eventInd)),1),postboutangley(eventInd)]; % adding 5 dpf data points
eventInd=find(~isnan(postboutangleo));
PrePostAgeData=[PrePostAgeData; detectionAngleo(eventInd),repmat(9,length(detectionAngleo(eventInd)),1),postboutangleo(eventInd)]; % adding 9  dpf data points
eventInd=find(~isnan(postboutanglevo));
PrePostAgeData=[PrePostAgeData; detectionAnglevo(eventInd),repmat(15,length(detectionAnglevo(eventInd)),1),postboutanglevo(eventInd)]; % adding 15  dpf data points


% Model with interaction
mdl = fitlm(PrePostAgeData(:,[1,2]),PrePostAgeData(:,3),'interactions','PredictorVars',{'DetectionAngle','Age'});
[ypred5dpf,y5dpfCI] = predict(mdl,[[0:1:120]',repmat(5,121,1)]);
[ypred9dpf,y9dpfCI] = predict(mdl,[[0:1:120]',repmat(9,121,1)]);
[ypred15dpf,y15dpfCI] = predict(mdl,[[0:1:120]',repmat(15,121,1)]);

figure;
eventInd=find(~isnan(postboutangley));
scatter1 = scatter(detectionAngley(eventInd),postboutangley(eventInd),2,'MarkerFaceColor',color5dpf,'MarkerEdgeColor',color5dpf,'HandleVisibility','off'); 
scatter1.MarkerFaceAlpha = .2;
scatter1.MarkerEdgeAlpha = .1;
set(gca,'YLim',[-80,80],'XLim',[0,120]);
hold on;plot(0:1:120,ypred5dpf,'Color',color5dpf);
plot(0:120,y5dpfCI,'--','Color', color5dpf);
X = [ 0:120 fliplr(0:120) ];
Y = [ y5dpfCI(:,1)' fliplr(y5dpfCI(:,2)') ];
patch (X,Y,color5dpf,'Facealpha',0.3,'Edgecolor',color5dpf); hold on;

eventInd=find(~isnan(postboutangleo));
hold on;scatter2=scatter(detectionAngleo(eventInd),postboutangleo(eventInd),2,'MarkerFaceColor',color9dpf,'MarkerEdgeColor',color9dpf,'HandleVisibility','off');
scatter2.MarkerFaceAlpha = .2;
scatter2.MarkerEdgeAlpha = .1;
hold on;plot(0:1:120,ypred9dpf,'Color',color9dpf);
plot(0:120,y9dpfCI,'--','Color', color9dpf);
X = [ 0:120 fliplr(0:120) ];
Y = [ y9dpfCI(:,1)' fliplr(y9dpfCI(:,2)') ];
patch (X,Y,color9dpf,'Facealpha',0.3,'Edgecolor',color9dpf); hold on;

eventInd=find(~isnan(postboutanglevo));
hold on;scatter3=scatter(detectionAnglevo(eventInd),postboutanglevo(eventInd),2,'MarkerFaceColor',color15dpf,'MarkerEdgeColor',color15dpf,'HandleVisibility','off');
scatter3.MarkerFaceAlpha = .2;
scatter3.MarkerEdgeAlpha = .1;
hold on;plot(0:1:120,ypred15dpf,'Color',color15dpf);
plot(0:120,y15dpfCI,'--','Color', color15dpf);
X = [ 0:120 fliplr(0:120) ];
Y = [ y15dpfCI(:,1)' fliplr(y15dpfCI(:,2)') ];
patch (X,Y,color15dpf,'Facealpha',0.3,'Edgecolor',color15dpf); hold on;
text(10,45,strcat('r^2=', sprintf('%.3f', mdl.Rsquared.Adjusted)));
text(10,35,renderPvalueString(coefTest(mdl)));
xlabel('Detection angle (deg)');
ylabel('Post bout angle (deg)');
axis equal;axis tight; set(gca,'YLim',[-50, 50]);
