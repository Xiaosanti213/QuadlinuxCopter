%这个原来是用来获取串口通信数据的  现在用来从变量区域读取数据


% It needs data importing
% edited by zhangxin 
% 20160322 
% Beihang University

%clear;clc;
close all
Point_X=[-1,1,1,-1,-1,1,1,-1]*5;
Point_Y=[-1,-1,-1,-1,1,1,1,1]*3;
Point_Z=[1,1,-1,-1,1,1,-1,-1]*1;

Face=[1,2,3,4;5,6,7,8;5,6,2,1;8,7,3,4;2,6,7,3;1,5,8,4];
Color=[1 1 0;0 1 0;1 0 0;0 0 1;0 1 1;1 0 1];

Point=[Point_X;Point_Y;Point_Z]';

hfig=figure('name','系留式风力发电飞行姿态测试','numbertitle','off');haxes=cla;
set(cla,'DataAspectRatio',[1,1,1],'Visible','off');
set(cla,'xdir','reverse','zdir','reverse');
axis([-10,10,-10,10,-10,10]);view([0 0]);
xlabel('x'),ylabel('y'),zlabel('z');
htxt=axes('Units','normalized','position',[0 0.9 0.5 0.1],'Visible','off');
hv=text('position',[0,0.8],'fontsize',12);
h=patch('parent',haxes,'vertices',Point*quad2dcm([1,0,0,0]),'faces',Face,...
    'FaceColor','flat','FaceVertexCdata',Color,'CDataMapping','scaled');
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

dcm = rotMat;
gyr_X=reshape(gyrX,[1,1,length(gyrX)]);
gyr_Y=reshape(gyrY,[1,1,length(gyrY)]);
gyr_Z=reshape(gyrZ,[1,1,length(gyrZ)]);
omega = [gyr_X gyr_Y gyr_Z];
for i = 1:size(dcm,3)
%while ishandle(hfig) 
%    str=fscanf(scom);
%    mat=regexp(str,'-?\d+.\d+','match');
%     if length(mat)==7
%         omega=[str2double(mat{1}),str2double(mat{2}),...
%             str2double(mat{3})];
%         quad=[str2double(mat{4}),str2double(mat{5}),...
%             str2double(mat{6}),str2double(mat{7})];
        set(h,'vertices',Point*dcm(:,:,i));
        set(hv,'string',num2str(omega(:,:,i)*pi/180));
        %pause(2)
        drawnow;
%     end
%end
end