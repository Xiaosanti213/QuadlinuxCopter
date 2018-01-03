%% 第一部分创建图形

%clear;clc;
close all

% 画图填充面上色
Point_X=[ 0,2, 2, 0,1,0, 0, 1]*5;
Point_Y=[-1,0, 0,-1,0,1, 1, 0]*5;
Point_Z=[ 1,1,-1,-1,1,1,-1,-1]/2;
Point=[Point_X;Point_Y;Point_Z]';
Face=[1,2,3,4;5,6,7,8;5,6,2,1;8,7,3,4;2,6,7,3;1,5,8,4];
Color=[1 1 0;0 1 0;1 0 0;0 0 1;0 1 1;1 0 1];

% 设置轴系
hfig=figure('name','陀螺仪传感器测试','numbertitle','off');haxes=cla;
set(cla,'DataAspectRatio',[1,1,1],'Visible','on');
set(cla,'xdir','reverse','ydir','reverse','zdir','reverse');
set(gca,'yticklabel','');
axis([-10,10,-10,10,-10,10]);
view([1 1 1]);%指定视角
xlabel('x'),ylabel('y'),zlabel('z');
grid on;


%设置文字位置，画出第一幅图
htxt=axes('Units','normalized','position',[-0.2 0.9 0.5 0.1],'Visible','off');
hv=text('position',[0,0.8],'fontsize',12);
h=patch('parent',haxes,'vertices',Point*Quad2dcm([1,0,0,0]),'faces',Face,...
    'FaceColor','flat','FaceVertexCdata',Color,'CDataMapping','scaled');
axis square;% 产生正方形坐标系

%% 串口读出数据在线显示
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

%% 记录数据离线显示
Point_temp = repmat(Point,1,1,size(dcm,3));
%set the position and the velocity values
for i = 2:size(dcm,3)
%while ishandle(hfig) 
%    str=fscanf(scom);
%    mat=regexp(str,'-?\d+.\d+','match');
%     if length(mat)==7
%         omega=[str2double(mat{1}),str2double(mat{2}),...
%             str2double(mat{3})];
%         quad=[str2double(mat{4}),str2double(mat{5}),...
%             str2double(mat{6}),str2double(mat{7})];
        Point_temp(:,:,i) = Point_temp(:,:,i-1)*dcm(:,:,i)';
        set(h,'vertices',Point_temp(:,:,i));%图形顶点位置
        set(hv,'string',['roll: ',num2str(roll(i)),...
            '  pitch: ',num2str(pitch(i)),...
            '  yaw: ',num2str(yaw(i))]);%文字显示
        drawnow;
        pause(0.1);
%     end
%end
end