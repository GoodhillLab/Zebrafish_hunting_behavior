function collectFeedingAssayMDResults()
% collectFeedingAssayMDResults()
%   collect raw extracted data points from the master file (located in the
%   Data folder), and lookuptable
%   average measures per fish over all events
%   save a data .mat file and loouptable .mat file under the Data folder

currentFolder = pwd;
dataFolder = fullfile(currentFolder, '..');
[feedingAssayRawData] = xlsread(strcat(dataFolder, '\Data\highSpeedFeedingAssayMDMasterList.xlsx'),'Sheet1');
[feedingAssayNum,feedingAssaytext,~]=xlsread(strcat(dataFolder, '\Data\highSpeedFeedingAssayMDMasterList.xlsx'),'Sheet1');
feedingAssaytextNoTitles=feedingAssaytext(2:end,:);
[lookuptableNum,lookuptable,~]=xlsread(strcat(dataFolder, '\Data\MDLookupTable.xlsx'));


measures=feedingAssaytext(1,:);
% identify fish to to iterate and collect results
[fishDatefishNumb,fishFirstRow]=unique(feedingAssayRawData(:,1:3),'rows');
fishDate=fishDatefishNumb(:,1);
fishNumb=fishDatefishNumb(:,2);
fishAge=fishDatefishNumb(:,3);
numAssayedFish=size(fishDatefishNumb,1);
% setting up the collated dataset
feedingAssayCollatedData=zeros(numAssayedFish,3);
for fishInd=1:numAssayedFish
    fishIndRows=intersect(find(feedingAssayRawData(:,1)==fishDate(fishInd)),find(feedingAssayRawData(:,2)==fishNumb(fishInd)));
    feedingAssayCollatedData(fishInd,1)=fishDate(fishInd);
    feedingAssayCollatedData(fishInd,2)=fishNumb(fishInd);
    feedingAssayCollatedData(fishInd,3:10)=nanmean(feedingAssayRawData(fishIndRows,[3,9,11,13,14,16,17,18])); % age,length,duration,angle,distance,angleAfterBout, nBouts,score
    
    fishOrgScore=feedingAssayRawData(fishIndRows,18);
    revisedScore=fishOrgScore;
    revisedScore(find(fishOrgScore==3))=2;
    feedingAssayCollatedData(fishInd,11)=nanmean(revisedScore);%revised score
    nLeft=length(find(strcmp(feedingAssaytext(fishIndRows,12),'L')));
    nRight=length(find(strcmp(feedingAssaytext(fishIndRows,12),'R')));
    feedingAssayCollatedData(fishInd,12)=nLeft/(nLeft+nRight); % proportion of lefts
    feedingAssayCollatedData(fishInd,13)=(nRight-nLeft)/(nLeft+nRight); % handedness
    nEvents=length(fishIndRows); % numberOfEvents
    feedingAssayCollatedData(fishInd,14)=nEvents;
    movieDuration=unique(feedingAssayRawData(fishIndRows,8))/60; % movie duration in mins
    feedingAssayCollatedData(fishInd,15)=nEvents/movieDuration; %rate
    abortFrac=length(find(fishOrgScore==0))/length(fishOrgScore);
    missFrac=length(find(fishOrgScore==1))/length(fishOrgScore);
    hitFrac=(length(find(fishOrgScore==2))+length(find(fishOrgScore==3)))/length(fishOrgScore);
    feedingAssayCollatedData(fishInd,16:18)=[abortFrac,missFrac,hitFrac]; % fraction of abort,miss, hit
    feedingAssayCollatedData(fishInd,19)=nanmean(feedingAssayRawData(fishIndRows(find(feedingAssayRawData(fishIndRows,18)~=0)),11)); % duration of non abort events
    feedingAssayCollatedData(fishInd,20)=nanmean(feedingAssayRawData(fishIndRows(find(feedingAssayRawData(fishIndRows,18)~=0)),17)); % bouts of non abort events
    feedingAssayCollatedData(fishInd,21)=feedingAssayCollatedData(fishInd,20)/feedingAssayCollatedData(fishInd,19);
    feedingAssayCollatedData(fishInd,22)=nanmean(feedingAssayRawData(fishIndRows,19)); % imaging speed
end
save (strcat(dataFolder, '\Data\','feedingAssayCollatedDataMD'),'feedingAssayCollatedData');
save (strcat(dataFolder, '\Data\','MDLookupTable'),'lookuptable');