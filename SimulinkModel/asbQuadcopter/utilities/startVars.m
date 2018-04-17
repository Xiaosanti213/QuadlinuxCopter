%% startVars.m - Initialize variables
% This script initializes variables and buses required for the model to
% work
% 将模型变量和总线初始化到工作空间中

% Register variables in the workspace before the project is loaded
initVars = who;

% Variants Conditions 模块选择，当前模型已经确定
Variants.Command = 0;       % 0: Signal Builder
Variants.Sensors = 1;       % 0: Feedthrough, 1: Dynamics
Variants.Environment = 0;   % 0: Constant, 1: Variable
Variants.Visualization = 3; % 0: Scopes, 1: Send values to workspace, 2: FlightGear, 3: Simulink 3D.
 
% Bus definitions 总线条件，执行对应同名的m文件，初始化模块中的总线
asbBusDefinitionCommand; 
asbBusDefinitionSensors;
asbBusDefinitionEnvironment;
asbBusDefinitionStates;

% Enum definitions
asbEnumDefinition;

% Sampling rate 采样率
Ts = 0.02;

% Geometric properties 几何属性
thrustArm = 0.10795;

% Initial conditions 初始条件：日期精确到秒 地球经纬高度 NED坐标系位置 机体速度 欧拉角 角速率
init.date = [2018 4 16 0 0 0];
init.posLLA = [42.299886 -71.350447 71.3232];
init.posNED = [57 95 -0.046];
init.vb = [0 0 0];
init.euler = [0 0 0];
init.angRates = [0 0 0];

% Initialize States: 初始状态States结构体
States = Simulink.Bus.createMATLABStruct('StatesBus');
States.V_body = init.vb';
States.Omega_body = init.angRates';
States.Euler = init.euler';
States.X_ned = init.posNED';
States.LLA = init.posLLA;
States.DCM_be = angle2dcm(init.euler(3),init.euler(2),init.euler(1));

% Environment 环境 空气密度 重力加速度
rho = 1.184;
g = 9.81;

% Variables 执行对应的m文件 设置相应的变量
vehicleVars; % 设置Vehicle结构体
sensorsVars; % 载入sensorCalibration.mat数据，设置Sensors结构体
controllerVars; % Controller结构体
commandVars; % Command结构体
estimatorVars; % Estimator结构体
visualizationFlightGearVars;% 

% Simulation Settings 仿真设置 起飞延时
takeOffDuration = 1;

%% Custom Variables 自定义变量
% Add your variables here:
% myvariable = 0;

% Register variables after the project is loaded and store the variables in
% 模型工程运行后，将变量登记存储到initVars当中，从而工程关闭之后将被清空
% initVars so they can be cleared later on the project shutdown.
% 下面部分用于清空
endVars = who;
initVars = setdiff(endVars,initVars);
clear endVars;
