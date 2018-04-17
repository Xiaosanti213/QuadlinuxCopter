%% startVars.m - Initialize variables
% This script initializes variables and buses required for the model to
% work
% ��ģ�ͱ��������߳�ʼ���������ռ���

% Register variables in the workspace before the project is loaded
initVars = who;

% Variants Conditions ģ��ѡ�񣬵�ǰģ���Ѿ�ȷ��
Variants.Command = 0;       % 0: Signal Builder
Variants.Sensors = 1;       % 0: Feedthrough, 1: Dynamics
Variants.Environment = 0;   % 0: Constant, 1: Variable
Variants.Visualization = 3; % 0: Scopes, 1: Send values to workspace, 2: FlightGear, 3: Simulink 3D.
 
% Bus definitions ����������ִ�ж�Ӧͬ����m�ļ�����ʼ��ģ���е�����
asbBusDefinitionCommand; 
asbBusDefinitionSensors;
asbBusDefinitionEnvironment;
asbBusDefinitionStates;

% Enum definitions
asbEnumDefinition;

% Sampling rate ������
Ts = 0.02;

% Geometric properties ��������
thrustArm = 0.10795;

% Initial conditions ��ʼ���������ھ�ȷ���� ����γ�߶� NED����ϵλ�� �����ٶ� ŷ���� ������
init.date = [2018 4 16 0 0 0];
init.posLLA = [42.299886 -71.350447 71.3232];
init.posNED = [57 95 -0.046];
init.vb = [0 0 0];
init.euler = [0 0 0];
init.angRates = [0 0 0];

% Initialize States: ��ʼ״̬States�ṹ��
States = Simulink.Bus.createMATLABStruct('StatesBus');
States.V_body = init.vb';
States.Omega_body = init.angRates';
States.Euler = init.euler';
States.X_ned = init.posNED';
States.LLA = init.posLLA;
States.DCM_be = angle2dcm(init.euler(3),init.euler(2),init.euler(1));

% Environment ���� �����ܶ� �������ٶ�
rho = 1.184;
g = 9.81;

% Variables ִ�ж�Ӧ��m�ļ� ������Ӧ�ı���
vehicleVars; % ����Vehicle�ṹ��
sensorsVars; % ����sensorCalibration.mat���ݣ�����Sensors�ṹ��
controllerVars; % Controller�ṹ��
commandVars; % Command�ṹ��
estimatorVars; % Estimator�ṹ��
visualizationFlightGearVars;% 

% Simulation Settings �������� �����ʱ
takeOffDuration = 1;

%% Custom Variables �Զ������
% Add your variables here:
% myvariable = 0;

% Register variables after the project is loaded and store the variables in
% ģ�͹������к󣬽������ǼǴ洢��initVars���У��Ӷ����̹ر�֮�󽫱����
% initVars so they can be cleared later on the project shutdown.
% ���沿���������
endVars = who;
initVars = setdiff(endVars,initVars);
clear endVars;
