% 第一部分创建六面体创建句柄
% 第二部分从串口读入陀螺仪角速度omega
% gyrX等格式为一维向量
% dcm描述之前点到变换后的点的变换矩阵
%data：serial port or from workspace

%clear;clc;
close all
Point_X=[-1,1,1,-1,-1,1,1,-1]*5;
Point_Y=[-1,-1,-1,-1,1,1,1,1]*3;
Point_Z=[1,1,-1,-1,1,1,-1,-1]*1;

%determine the faces with the numbers of the points
Face=[1,2,3,4;5,6,7,8;5,6,2,1;8,7,3,4;2,6,7,3;1,5,8,4];
Color=[1 1 0;0 1 0;1 0 0;0 0 1;0 1 1;1 0 1];

Point=[Point_X;Point_Y;Point_Z]';

hfig=figure('name','陀螺仪传感器测试','numbertitle','off');haxes=cla;
set(cla,'DataAspectRatio',[1,1,1],'Visible','off');
set(cla,'xdir','reverse','zdir','reverse');
axis([-10,10,-10,10,-10,10]);
view([-1 1 1]);
%from a certain point of view
xlabel('x'),ylabel('y'),zlabel('z');


htxt=axes('Units','normalized','position',[0 0.9 0.5 0.1],'Visible','off');
hv=text('position',[0,0.8],'fontsize',12);
h=patch('parent',haxes,'vertices',Point*quad2dcm([1,0,0,0]),'faces',Face,...
    'FaceColor','flat','FaceVertexCdata',Color,'CDataMapping','scaled');
%fill the faces with different colors


%scom=instrfind();
%if(~isempty(scom)) 
%    fclose(scom);
%end;
%scom=serial('com3','BaudRate',115200);
%fopen(scom);
% while ishandle(hfig) 
%     str=fscanf(scom);
%     mat=regexp(str,'-?\d+.\d+','match');
%     if length(mat)==7
%         omega=[str2double(mat{1}),str2double(mat{2}),...
%             str2double(mat{3})];
%         quad=[str2double(mat{4}),str2double(mat{5}),...
%             str2double(mat{6}),str2double(mat{7})];
%         set(h,'vertices',Point*quad2dcm(quad));
%         set(hv,'string',num2str(omega/pi*180));
%         drawnow;
%     end
% end

%fclose(scom);
%delete(scom);

gyr_X=reshape(gyrX,[1,1,length(gyrX)]);
gyr_Y=reshape(gyrY,[1,1,length(gyrY)]);
gyr_Z=reshape(gyrZ,[1,1,length(gyrZ)]);
omega = [gyr_X gyr_Y gyr_Z];
%set the position and the velocity values
%plot
for i = 1:size(dcm,3)
%while ishandle(hfig) 
%    str=fscanf(scom);
%    mat=regexp(str,'-?\d+.\d+','match');
%     if length(mat)==7
%         omega=[str2double(mat{1}),str2double(mat{2}),...
%             str2double(mat{3})];
%         quad=[str2double(mat{4}),str2double(mat{5}),...
%             str2double(mat{6}),str2double(mat{7})];
        set(h,'vertices',Point*dcm(i));
        set(hv,'string',num2str(omega(i)));
        drawnow;
%     end
%end
end