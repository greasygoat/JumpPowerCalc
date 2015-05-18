%Jump power calculator for adolescent jumping
%Author: Patrick Rider/East Carolina University
%Collaboration with Matt Mahar/East Carolina University
clear all

%Launch file selection window
[filename, pathname] = uigetfile('*.txt', 'Pick a Text file');

jumpFlag = 0;

%Check to make sure user doesn't press cancel button
if isequal(filename,0) || isequal(pathname,0)
    disp('User pressed cancel')
else
    disp(['User selected ', fullfile(pathname, filename)])
end

%load data for specific type of jump
if strfind(filename, 'VJ')
    jumpFlag = 1;
    filename = strcat(pathname, filename);   
    data = importVertJump(filename);
else
    filename = strcat(pathname, filename);   
    data = importLongJump(filename);
end

fileLength = length(data)/12001;


%Break up into frames
frames = reshape(data, [], fileLength * 2);

%Scale forces
prompt = ('Enter weight in pounds');

title='Get Weight';

getWeight = inputdlg(prompt, title);

weightInPounds = str2num(getWeight{1}); %#ok<*ST2NM> I know what i'm doing matlab so shutup

weightInNewtons = weightInPounds*4.44822162 ;

plot(frames(:, (size(frames,2)/2)+2)); %graph a force curve

baselineEndPoints = int64(ginput(2));

baselineAverage = mean(frames((baselineEndPoints(1,1): baselineEndPoints(2,1)), (size(frames,2)/2)+2));

conversionFactor = weightInNewtons/baselineAverage;

processedData = frames(:, ((size(frames,2)/2)+1): end);
processedData = conversionFactor*processedData;

%Get analysis frames from user
x = inputdlg('Enter space-separated frame #s (eg. 2 3 4):', 'Frames to analyze', [1 10]);

framesToAnalyze = str2num(x{:}); 

%Calc jump power
if jumpFlag == 1
   for i = 1:length(framesToAnalyze)
       [peakResult(i), avgResult(i)]  = calcVertJumpPower(processedData(:,framesToAnalyze(i)), weightInNewtons);
   end
else
   for i = 1:length(framesToAnalyze)
       [peakResult(i), avgResult(i)]  = calcBroadJumpPower(processedData(:,framesToAnalyze(i)), weightInNewtons);
   end
end

%store results
%xlswrite(resultFilename, result);
