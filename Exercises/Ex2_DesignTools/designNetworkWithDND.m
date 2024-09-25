load('netInPredict.mat'); 
deepNetworkDesigner(TrainedNetwork); 
analyzenetwork(TrainedNetwork); 
% Get a report on how much compression pruning or projection of the network can achieve by clicking the Analyze for compression button in the toolstrip.
