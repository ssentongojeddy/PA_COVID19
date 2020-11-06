function PIQ = read_placeiq_lexPA_data()
%Read LEX data from placeIQ
% County-level location exposure index (LEX): Among smartphones that pinged 
% in a given county today, what share of those devices pinged in each county
% at least once during the previous 14 days? The daily county-level LEX is 
% an approximately 2000-by-2000 matrix in which each cell reports, among 
% devices that pinged today in the column county, the share of devices that 
% pinged in the row county at least once during the previous 14 days.

%The format of this data is separate CSV files by date, of size fips x fips

%Look for most recent existing LEX file
%Probably want to remove this first piece, may need to run through all files each time. 


%%NEED TO CHANGE THIS SO THAT THE OUTPUT LEX IS OF SIZE OF TOTAL COUNTIES,
%%NOT JUST THOSE THAT HAVE DATA (61 counties have data for PA, but 67
%%counties exist).

tmp = dir;
svfil = 'PIQ_lexPA_data_';
% tmp = {tmp.name};
% files = tmp(~cellfun(@isempty,regexp(tmp,svfil)));
% if isempty(files)
    %No file exists, initiate web scrape from Jan 1
    newest_filedate = datenum('1-Mar-20');
    k = 1;
% else
%     %File exists.  Load this file, find most recent date, and scrape web
%     %starting after that
%     [a,b] = sort(cellfun(@(x) datenum(x(length(svfil)+1:end-4)),files));
%     newest_filedate = a(end);
%     load([svfil datestr(newest_filedate)])
%     k = length(PIQ)+1;
% end

datevector = newest_filedate:datenum(today);
PIQ = [];
for i = newest_filedate+1:datenum(today)
    disp(['running ' datestr(i)]);
    try
        tic
        tnm = gunzip(['https://github.com/COVIDExposureIndices/COVIDExposureIndices/raw/master/lex_data/county_lex_' datestr(i,'yyyy-mm-dd') '.csv.gz']);
        toc
        tdata = table2cell(readtable(tnm{1}));
        
        statefip = '42'; %PA
        
        idx = find(cellfun(@(x) strcmp(x(1:2),statefip),tdata(:,1)));
        
        toc
        cfips = cellfun(@num2str, tdata(1,idx),'UniformOutput',false);
        toc
        tdata2 = cell2mat(tdata(idx,idx));
        toc
        
    
    
  
    PIQ = [PIQ; [repmat({datestr(i)},length(cfips),1) cfips' num2cell(tdata2)]];
    delete(tnm{1})
    k=k+1;
    catch
        disp(['county_lex_' datestr(i,'yyyy-mm-dd') ' file not found']);
    end
    
end
save([svfil datestr(today)],'PIQ');
fid = fopen('LEX_pa.txt','w');
for i = 1:size(PIQ,1)
fprintf(fid,['%s %s ' repmat('%.4f ',1,size(PIQ,2)-2) '\n'],PIQ{i,:});
end
fclose(fid)




%Show travel to/from Centre county
%Centre = 27, Cumberland = 41, Erie = 51, Lehigh = 79, 
COUNTYFIP = {'42027','42041','42051','42079'};
COUNTYNAME = {'Centre','Cumberland','Erie','Lehigh'};
for i = 1:length(COUNTYFIP)
    CoInd(i) = find(strcmp(cfips,COUNTYFIP{i}));
end
m=figure;
subplot(121); hold on; title(['To ' COUNTYNAME{1}]);
for i = 1:3
plot(cellfun(@datenum,unique(PIQ(:,1),'stable')),[PIQ{find(strcmp(PIQ(:,2),COUNTYFIP{i+1})),CoInd(1)+2}])
end
legend(cellfun(@(x) ['From ' x],COUNTYNAME(2:end),'UniformOutput',false))
dateaxis
subplot(122); hold on; title(['From ' COUNTYNAME{1}])
for i = 1:3
plot(cellfun(@datenum,unique(PIQ(:,1),'stable')),[PIQ{find(strcmp(PIQ(:,2),COUNTYFIP{1})),CoInd(i+1)+2}])
end
legend(cellfun(@(x) ['To ' x],COUNTYNAME(2:end),'UniformOutput',false))
dateaxis
savepdffigure(m,'centre_LEX.pdf')






