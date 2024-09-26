function [dataToWrite] = preprocess(data)

tMin = seconds(0.8);

flow = data.qOut_meas{1};
flow = flow(flow.Time >= tMin,:);
flow.Time = flow.Time - flow.Time(1);
pressure = data.pOut_meas{1};
pressure = pressure(pressure.Time >= tMin,:);
pressure.Time = pressure.Time - pressure.Time(1);

% Ensure the flow and pressure is sampled at a uniform sample rate
flow = retime(flow,'regular','linear','TimeStep',seconds(1e-3));
pressure = retime(pressure,'regular','linear','TimeStep',seconds(1e-3));


% Find the values of the fault variables from the SimulationInput
simin = data.SimulationInput{1};
vars = {simin.Variables.Name};
idx = strcmp(vars,'leak_cyl_area_WKSP');
LeakFault = simin.Variables(idx).Value;
idx = strcmp(vars,'block_in_factor_WKSP');
BlockingFault = simin.Variables(idx).Value;
idx = strcmp(vars,'bearing_fault_frict_WKSP');
BearingFault = simin.Variables(idx).Value;

LeakFlag = LeakFault > 1e-6;
BlockingFlag = BlockingFault < 0.8;
BearingFlag = BearingFault > 0; 
CombinedFlag = LeakFlag+10*BlockingFlag+100*BearingFlag;

% dataToWrite = {...
%     'flow', flow, ...
%     'pressure', pressure, ...
%     'faultCode', CombinedFlag};

dataToWrite.flow =  flow;
dataToWrite.pressure = pressure;
dataToWrite.faultCode = CombinedFlag;

dataToWrite = struct2table(dataToWrite,'AsArray',1);
end
