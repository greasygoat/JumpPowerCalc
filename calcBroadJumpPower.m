function [ peakResultantBroadJumpPower, avgResultantBroadJumpPower ] = calcBroadJumpPower( processedData, weightInNewtons )
%calcBroadJumpPower calculates the power of a vertical jump using vertical
%and hortizontal GRF force data
%   This function takes scaled vertical/hortizonatal GRF data and a 
%   person's weight in Newtons and returns the power produced during the 
%   jump using the impulse momentum method described by Linthorne, N. 2001, 
%   Analysis of standing vertical jumps using a force platform.

% Author: Patrick Rider

plot(processedData);

jumpEndPoints = int64(ginput(2));

jumpTime = (jumpEndPoints(2,1)-jumpEndPoints(1,1)) * .001;

jumpData = processedData(jumpEndPoints(1,1):jumpEndPoints(2,1),1);

vertJumpImpulse = .001*trapz(jumpData) - (jumpTime* weightInNewtons);

velocity = vertJumpImpulse/(weightInNewtons*0.10197162099998805);

avgVertPower = (mean(jumpData)-weightInNewtons) * velocity;

peakVertPower = (max(jumpData)-weightInNewtons) * velocity;

avgHorPower = 1;

peakHorPower = 1;

peakResultantBroadJumpPower = sqrt((peakVertPower^2 + peakHorPower^2));

avgResultantBroadJumpPower = sqrt((avgVertPower^2 + avgHorPower^2));
end

