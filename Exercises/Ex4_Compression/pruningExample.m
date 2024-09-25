mbq = minibatchqueue(adsTrain, ...
    MiniBatchSize=16, ...
    MiniBatchFcn=@preprocessMiniBatchPredictors, ...
    MiniBatchFormat="CTB");

% Projection pruning setup
%[netProjected,info] = compressNetworkUsingProjection(airCompNet,mbq);

function X = preprocessMiniBatchPredictors(dataX)

X = padsequences(dataX,2,Length="shortest");

end