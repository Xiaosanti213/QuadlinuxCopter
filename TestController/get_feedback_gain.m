function K=get_feedback_gain(A,B,pole)
% A,B ϵͳ����
% P ��������ʽ����λ�� ������

U = ctrb(A,B);                                              % ����ɿ��Ծ���
r = rank(U);                                                % �ɿ��Ծ������
r0 = size(A,1);                                             % A����
%% ������ ��A,B�����ɿ�
if (r<r0 && size(B,2)==1)
    %���㲻�ɿص�����ֵ
    %��p������в��ɿ�����ֵ������ã����򲻿�����
    find_element_in_matrix(B,1); 
elseif (r==r0 && size(B,2)==1)
%% ������ ��A,B���ɿ�
    [V1,D1,U1]=svd(U);                                      % Singular Value Decomposition����ֵ�ֽ�
    InvU=U1/(D1)*V1';                                       % Jordan�� U�Ƿ��� D1������ֵ�Խ���sigma = sqrt(lambda)
    h=InvU(r0,:);                                           % ���������棬����ȡ���һ��
    P=ctrb(A',h')';                                         % ����任����P
    [V2,D2,U2]=svd(P);
    P_inv=U2/D2*V2';                                        % ����任�������
    A_std=P*A*P_inv;                                        % A����ȼ۱任�ɿɿر�׼��   
    
    poly = 1;
    for kk=1:r0
        poly=conv([1 -pole(kk)], poly);                     % �õ�����ʽϵ���Ӹ߽׵��ͽ�                               
    end
    A_bar_std = poly(end:-1:2);                             % ���� �ɿر�׼�͵�Ŀ��ϵͳ����A_bar���һ��
    K_bar=A_bar_std(1,:)+A_std(r0,:);
    K=K_bar*P;
elseif (size(B,2)>1)
    return 
end

