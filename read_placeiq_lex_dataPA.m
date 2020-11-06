function PIQ = read_placeiq_lex_data()
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
svfil = 'PIQ_lex_data_';
% tmp = {tmp.name};
% files = tmp(~cellfun(@isempty,regexp(tmp,svfil)));
% if isempty(files)
    %No file exists, initiate web scrape from Jan 1
    newest_filedate = datenum('1-Jan-20');
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
for i = newest_filedate+1:datenum(today)
    disp(['running ' datestr(i)]);
    try
    tnm = gunzip(['https://github.com/COVIDExposureIndices/COVIDExposureIndices/raw/master/lex_data/county_lex_' datestr(i,'yyyy-mm-dd') '.csv.gz']);
    tdata = table2cell(readtable(tnm{1}));
    cfips = cellfun(@num2str, tdata(1,2:end),'UniformOutput',false);
    tdata2 = cell2mat(tdata(2:end,2:end));
    tdata3 = tdata2;
    %To reduce the size of the lex matrix, set values below a certain
    %threshold to 0 and turn into a sparse matrix.
    tdata3(tdata3<.01) = 0; 
    PIQ{k}.date = datestr(i);
    PIQ{k}.lex = sparse(tdata3);
    
    tmp = cellfun(@(x) length(x),cfips)==4;
    cfips(tmp) = cellfun(@(x) ['0' x], cfips(tmp),'UniformOutput',false);
    PIQ{k}.fips = cfips;
    delete(tnm{1})
    k=k+1;
    catch
        disp(['county_lex_' datestr(i,'yyyy-mm-dd') ' file not found']);
    end
    
end
save([svfil datestr(today)],'PIQ');


figure
% statefip = '42'; %PA
statefip = '34'; %NJ
idx = find(cellfun(@(x) strcmp(x(1:2),statefip),PIQ{end}.fips));
for i = 1:length(PIQ)
imagesc(PIQ{i}.lex(idx,idx)); colorbar; %PA    (1095:1188,1095:1188)); colorbar; %NJ, NM, NY
% xlim([1095 1188]); 
% ylim([1095 1188]);
text(length(idx)/1.5,length(idx)/2.5,PIQ{i}.date,'Color',[1 1 1])
pause(.1)
end




end