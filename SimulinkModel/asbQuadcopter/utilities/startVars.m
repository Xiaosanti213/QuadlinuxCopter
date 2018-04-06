%% startVars.m - Initialize variables
% This script initializes variables and buses required for the model to
% work.

% Copyright 2013-2017 The MathWorks, Inc.

% Register variables in the workspace before the project is loaded
initVars = who;

% Variants Conditions
Variants.Command = 0;       % 0: Signal builder, 1: Joystick, 2: Pre-saved data, 3: Pre-saved data in a Spreadsheet
Variants.Sensors = 1;       % 0: Feedthrough, 1: Dynamics
Variants.Environment = 0;   % 0: Constant, 1: Variable
Variants.Visualization = 3; % 0: Scopes, 1: Send values to workspace, 2: FlightGear, 3: Simulink 3D.
 
% Bus definitions
asbBusDefinitionCommand; 
asbBusDefinitionSensors;
asbBusDefinitionEnvironment;
asbBusDefinitionStates;

% Enum definitions
asbEnumDefinition;

% Sampling rate
Ts= 0.005;

% Geometric properties
thrustArm = 0.10795;

% Initial conditions
init.date = [2017 1 1 0 0 0];
init.posLLA = [42.299886 -71.350447 71.3232];
init.posNED = [57 95 -0.046];
init.vb = [0 0 0];
init.euler = [0 0 0];
init.angRates = [0 0 0];

% Initialize States:
States = Simulink.Bus.createMATLABStruct('StatesBus');
States.V_body = init.vb';
States.Omega_body = init.angRates';
States.Euler = init.euler';
States.X_ned = init.posNED';
States.LLA = init.posLLA;
States.DCM_be = angle2dcm(init.euler(3),init.euler(2),init.euler(1));

% Environment
rho = 1.184;
g = 9.81;

% Variables
vehicleVars;
sensorsVars;
controllerVars;
commandVars;
estimatorVars;
visualizationFlightGearVars;

% Simulation Settings
takeOffDuration = 1;

%% Custom Variables
% Add your variables here:
% myvariable = 0;

% Register variables after the project is loaded and store the variables in
% initVars so they can be cleared later on the project shutdown.
endVars = who;
initVars = setdiff(endVars,initVars);
clear endVars;
