%% Flight Controller Vars

% This file is derived from the work by Fabian Riether.

% Control Mixer
% Ts2Q transforms thrust [Nm] for motors 1 through 4 to u_mechanical =[totalThrust;Torqueyaw;pitch;roll]
% 转换矩阵：将1~4号电机推力转换到整个拉力，偏航扭矩，俯仰，滚转
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
% 从Q矩阵转换到各个电机的拉力
Controller.Q2Ts = inv(Controller.Ts2Q); 

% Controllers (generic helpers)
Controller.takeoffGain = 0.2;   
% drone takes off with constant thrust x% above hover thrust 
% 起飞推力稍高于悬停推力
Controller.totalThrustMaxRelative = 0.92;   
% relative maximum total thrust that can be used for gaining altitude; rest is buffer for orientation control
% 可用于获取相对最大完全推力的比率，余下部分可以用来姿态控制

Controller.motorsThrustPerMotorMax = Vehicle.Motor.maxLimit*Vehicle.Motor.commandToW2Gain*...
    Vehicle.Rotor.Ct*rho*Vehicle.Rotor.area*Vehicle.Rotor.radius^2;



