%% ������Ԥ�⣬����ͬ��ɢ��С����
% ����˼�룺����ǰ��Ԥ��ֱ�ӵ���Ԥ��
% ����ǰ�ι۲�У������Ԥ��
clear 
close all
clc


%% step1�������ṹ�������ʼֵ
sim_finish = 500;                       % ���泤��
dim = 2;                                % x��ά�� 
R = zeros(1,1,sim_finish+1);            % ��������Э����
H = zeros(1,dim,sim_finish+1);          % ��������״̬����ϵ����ֻ��һ����������

P = zeros(dim,dim,sim_finish+1);        % ��ʼ���Ƶ�Э������
P(:,:,1) = eye(2);

y = zeros(1,1,sim_finish+1);            % ��ʵֵ

x_hat = zeros(dim,1,sim_finish+1);      % ��ʼ�����Ʊ���
x_hat(:,:,1) = [8 7]';                  % ���Ʊ�������ֵ�����ȡ�������ȶ�����
fai = zeros(dim,dim,sim_finish+1);      % ״̬ת�ƾ���λ��

for i = 1:1:sim_finish+1
    H(:,:,i) = [1, 0.99^(i-1)];
    R(:,:,i) = 1;
    y(:,:,i) = H(:,:,i)*[10,5]';        % �����ڴ˻��������Ӳ�������
    fai(:,:,i) = eye(dim);              % ״̬ת�ƾ�����ʱ��仯
end

K = zeros(2,1,sim_finish+1);
gamma = K;                              % ״̬ת������󣬺������Ӧ��
Q = K;
%% step2:�������
% ʵ�ʱ�̹����в���Ҫ���洢������

for i = 2:1:sim_finish+1
    K(:,:,i) = fai(:,:,i)*P(:,:,i-1)*H(:,:,i)'/(H(:,:,i)*P(:,:,i-1)*H(:,:,i)'+R(:,:,i));
    x_hat(:,:,i) = fai(:,:,i)*x_hat(:,:,i-1)+K(:,:,i)*(y(:,:,i) - H(:,:,i)*x_hat(:,:,i-1));
    P(:,:,i) = fai(:,:,i)*P(:,:,i-1)*fai(:,:,i)'-K(:,:,i)*H(:,:,i)*P(:,:,i-1)*fai(:,:,i);
end

%% ����˵��
% K(:,:,i) ��iʱ��Ԥ��i+1ʱ�̵Ĳ�������ϵ��
% fai(:,:,i) i-1->iʱ��״̬ת�ƾ��� 



%% step3:plot
temp_x1 = vector_to_mat(x_hat);
temp_p1 = vector_to_mat1(P);

figure(1)

subplot(211)
plot(1:1:sim_finish+1,temp_x1(1,:),'r-');
hold on
plot(1:1:sim_finish+1,temp_x1(2,:),'b.');
xlabel('simu_times')
ylabel('����ֵ')
legend('Estimated x1','Estimated x2')


subplot(212)
plot(1:1:sim_finish+1,temp_p1(1,:),'r-');
hold on 
plot(1:1:sim_finish+1,temp_p1(2,:),'b.');
xlabel('simu_times')
ylabel('����Э����')

hold on





%% ��ά����ת���ɶ�ά���������
function mat = vector_to_mat(vec)
    for i = 1:1:501
        mat(1,i) = vec(1,1,i);
        mat(2,i) = vec(2,1,i);
    end
end

function mat1 = vector_to_mat1(mat)
    for i = 1:1:501
        mat1(1,i) = mat(1,1,i);
        mat1(2,i) = mat(2,2,i);
    end
end


