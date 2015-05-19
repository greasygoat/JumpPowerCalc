function [ peakResultantBroadJumpPower, avgResultantBroadJumpPower ] = calcBroadJumpPower( horData, vertData, weightInNewtons )
%calcBroadJumpPower calculates the power of a vertical jump using vertical
%and hortizontal GRF force data
%   This function takes scaled vertical/hortizonatal GRF data and a 
%   person's weight in Newtons and returns the power produced during the 
%   jump using the impulse momentum method described by Linthorne, N. 2001, 
%   Analysis of standing vertical jumps using a force platform.

% Author: Patrick Rider

figure('units','normalized','outerposition',[0 0 1 1]);

plot(vertData);

jumpEndPoints = int64(ginput(2));

close all;

jumpTime = (jumpEndPoints(2,1)-jumpEndPoints(1,1)) * .001;

vertJumpData = vertData(jumpEndPoints(1,1):jumpEndPoints(2,1),1);
horJumpData = horData(jumpEndPoints(1,1):jumpEndPoints(2,1),1);

vertJumpImpulse = .001*trapz(vertJumpData) - (jumpTime* weightInNewtons);
horJumpImpulse = .001*trapz(horJumpData);

vertVelocity = vertJumpImpulse/(weightInNewtons*0.10197162099998805);
horVelocity = horJumpImpulse/(weightInNewtons*0.10197162099998805);

avgVertPower = (mean(vertJumpData)-weightInNewtons) * vertVelocity;

peakVertPower = (max(vertJumpData)-weightInNewtons) * vertVelocity;

avgHorPower = mean(horJumpData) * horVelocity;

peakHorPower = max(horJumpData) * horVelocity;

peakResultantBroadJumpPower = int64(sqrt(double(peakVertPower^2 + peakHorPower^2)));

avgResultantBroadJumpPower = int64(sqrt(double(avgVertPower^2 + avgHorPower^2)));
end

