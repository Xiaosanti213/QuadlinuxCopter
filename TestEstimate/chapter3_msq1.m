 %% Dan Simon����״̬���� ����3.3������С���˹���
% clear 
% close all
% clc


%% step1:�����ṹ�������ʼֵ
sim_finish = 500;                       % ���泤��
dim = 2;                                % x��ά�� 
R = zeros(1,1,sim_finish+1);            % ��������Э����
H = zeros(1,dim,sim_finish+1);          % ��������״̬����ϵ����ֻ��һ����������

P = zeros(dim,dim,sim_finish+1);        % ��ʼ���Ƶ�Э������
P(:,:,1) = eye(2);

y = zeros(1,1,sim_finish+1);            % ��ʵֵ

x_hat = zeros(dim,1,sim_finish+1);      % ��ʼ�����Ʊ���
x_hat(:,:,1) = [8 7]';                  % ���Ʊ�������ֵ
for i = 1:1:sim_finish+1
    H(:,:,i) = [1, 0.99^(i-1)];
    R(:,:,i) = 1;
    y(:,:,i) = H(:,:,i)*[10,5]';        % ����ֵ�������ڴ˻��������Ӳ�������
end

K = zeros(2,1,sim_finish+1);
%% step2:�������
for k = 2:1:sim_finish+1
    K(:,:,k) = P(:,:,k-1)*H(:,:,k)'/((H(:,:,k)*P(:,:,k-1)*H(:,:,k)'+R(:,:,k)));%������������K����
    x_hat(:,:,k) = x_hat(:,:,k-1)+K(:,:,k)*(y(:,:,k)-H(:,:,k)*x_hat(:,:,k-1));
    P(:,:,k) = (eye(dim)-K(:,:,k)*H(:,:,k))*P(:,:,k-1)*(eye(dim)-K(:,:,k)*H(:,:,k))'+K(:,:,k)*R(:,:,k)*K(:,:,k)';
end


%% step3:plot
temp_x = vector_to_mat(x_hat);
temp_p = vector_to_mat1(P);

figure(2)

subplot(211)
plot(1:1:sim_finish+1,temp_x(1,:),'c-');
hold on
plot(1:1:sim_finish+1,temp_x(2,:),'g.');
xlabel('simu_times')
ylabel('����ֵ')
legend('Estimated x1','Estimated x2')


subplot(212)
plot(1:1:sim_finish+1,temp_p(1,:),'c-');
hold on 
plot(1:1:sim_finish+1,temp_p(2,:),'g.');
xlabel('simu_times')
ylabel('����Э����')







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
