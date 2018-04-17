%% Flight Controller Vars

% This file is derived from the work by Fabian Riether.

% Control Mixer
% Ts2Q transforms thrust [Nm] for motors 1 through 4 to u_mechanical =[totalThrust;Torqueyaw;pitch;roll]
% ת�����󣺽�1~4�ŵ������ת��������������ƫ��Ť�أ���������ת
Controller.Ts2Q = ...
        [1 1 1 1;    
        Vehicle.Rotor.Cq/Vehicle.Rotor.Ct*Vehicle.Rotor.radius ....
        -Vehicle.Rotor.Cq/Vehicle.Rotor.Ct*Vehicle.Rotor.radius ...
        Vehicle.Rotor.Cq/Vehicle.Rotor.Ct*Vehicle.Rotor.radius ...
        -Vehicle.Rotor.Cq/Vehicle.Rotor.Ct*Vehicle.Rotor.radius;
        -Vehicle.Airframe.d*sqrt(2)/2 ...
        -Vehicle.Airframe.d*sqrt(2)/2  ...
        Vehicle.Airframe.d*sqrt(2)/2 Vehicle.Airframe.d*sqrt(2)/2; 
        -Vehicle.Airframe.d*sqrt(2)/2  ...
        Vehicle.Airframe.d*sqrt(2)/2 ...
        Vehicle.Airframe.d*sqrt(2)/2 -Vehicle.Airframe.d*sqrt(2)/2];

% Q2Ts transform requested Q to thrust per motor
% ��Q����ת�����������������
Controller.Q2Ts = inv(Controller.Ts2Q); 

% Controllers (generic helpers)
Controller.takeoffGain = 0.2;   
% drone takes off with constant thrust x% above hover thrust 
% ��������Ը�����ͣ����
Controller.totalThrustMaxRelative = 0.92;   
% relative maximum total thrust that can be used for gaining altitude; rest is buffer for orientation control
% �����ڻ�ȡ��������ȫ�����ı��ʣ����²��ֿ���������̬����

Controller.motorsThrustPerMotorMax = Vehicle.Motor.maxLimit*Vehicle.Motor.commandToW2Gain*...
    Vehicle.Rotor.Ct*rho*Vehicle.Rotor.area*Vehicle.Rotor.radius^2;



