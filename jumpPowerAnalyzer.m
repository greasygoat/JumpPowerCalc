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

subID = filename(1:3);

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
if jumpFlag == 1
    frames = reshape(data, [], fileLength * 2);
else
    frames = reshape(data, [], fileLength * 3);
end

%Scale forces
prompt = ('Enter weight in pounds');

title='Get Weight';

getWeight = inputdlg(prompt, title);

weightInPounds = str2num(getWeight{1}); %#ok<*ST2NM> I know what i'm doing matlab so shutup

weightInNewtons = weightInPounds*4.44822162 ;

figure('units','normalized','outerposition',[0 0 1 1]);

if jumpFlag == 1
    plot(frames(:, (size(frames,2)-1))); %graph a vert force curve in VJ
else
    plot(frames(:, (size(frames,2)-1))); %graph a vert force curve in SJ
end

baselineEndPoints = int64(ginput(2));

baselineAverage = mean(frames((baselineEndPoints(1,1): baselineEndPoints(2,1)), (size(frames,2)-1)));

conversionFactor = weightInNewtons/baselineAverage;

horizontalConversionFactor = conversionFactor/2;

if jumpFlag == 1;
    processedData = frames(:, ((size(frames,2)/2)+1): end);
    processedData = conversionFactor*processedData;
else
    horProcessedData = frames(:, ((size(frames,2)/3)+1): ((size(frames,2)/3)*2));
    horProcessedData = horizontalConversionFactor*horProcessedData;
    
    processedData = frames(:, (((size(frames,2)/3)*2)+1): end);
    processedData = conversionFactor*processedData;
end

%Get analysis frames from user
x = inputdlg('Enter space-separated frame #s (eg. 2 3 4):', 'Frames to analyze', [1, 53]);

framesToAnalyze = str2num(x{:}); 

%Calc jump power
peakResult = zeros(3,1);
avgResult = zeros(3,1);

if jumpFlag == 1
   for i = 1:length(framesToAnalyze)
       [peakResult(i), avgResult(i)]  = calcVertJumpPower(processedData(:,framesToAnalyze(i)), weightInNewtons);
   end
else
   for i = 1:length(framesToAnalyze)
       [peakResult(i), avgResult(i)]  = calcBroadJumpPower(horProcessedData(:,framesToAnalyze(i)), processedData(:,framesToAnalyze(i)), weightInNewtons);
   end
end

%setup xlswrite
[resultFilename, resultPathname] = uigetfile('*.xlsx', 'Pick results file');

if isequal(filename,0) || isequal(pathname,0)
    disp('User pressed cancel')
else
    disp(['User selected ', fullfile(resultPathname, resultFilename)])
end
resultFilename = strcat(resultPathname, resultFilename);

a = xlsread(resultFilename);

numRows = (size(a,1));

% plus 1 to write in the next line (if you have an header it should be + 2)
numRows = numRows +2;

% convert number to string
b = num2str(numRows);

% setup columns to start write
c = strcat('A', b);
d = strcat('B', b);
e = strcat('E', b);

%store results
if jumpFlag==1
    xlswrite(resultFilename, {subID}, 'VerticalJump', c );
    xlswrite(resultFilename, transpose(peakResult), 'VerticalJump', d );
    xlswrite(resultFilename, transpose(avgResult), 'VerticalJump', e);
else
    xlswrite(resultFilename, {subID}, 'BroadJump', c);
    xlswrite(resultFilename, transpose(peakResult), 'BroadJump', d);
    xlswrite(resultFilename, transpose(avgResult), 'BroadJump', e);
end
