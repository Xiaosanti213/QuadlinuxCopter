function K=get_feedback_gain(A,B,pole)
% A,B 系统矩阵
% P 特征多项式极点位置 行向量

U = ctrb(A,B);                                              % 计算可控性矩阵
r = rank(U);                                                % 可控性矩阵的秩
r0 = size(A,1);                                             % A的秩
%% 单输入 （A,B）不可控
if (r<r0 && size(B,2)==1)
    %计算不可控的特征值
    %在p中如果有不可控特征值则可配置，否则不可配置
    find_element_in_matrix(B,1); 
elseif (r==r0 && size(B,2)==1)
%% 单输入 （A,B）可控
    [V1,D1,U1]=svd(U);                                      % Singular Value Decomposition奇异值分解
    InvU=U1/(D1)*V1';                                       % Jordan型 U是方阵 D1是奇异值对角阵sigma = sqrt(lambda)
    h=InvU(r0,:);                                           % 计算矩阵的逆，并提取最后一行
    P=ctrb(A',h')';                                         % 计算变换矩阵P
    [V2,D2,U2]=svd(P);
    P_inv=U2/D2*V2';                                        % 计算变换矩阵的逆
    A_std=P*A*P_inv;                                        % A矩阵等价变换成可控标准型   
    
    poly = 1;
    for kk=1:r0
        poly=conv([1 -pole(kk)], poly);                     % 得到多项式系数从高阶到低阶                               
    end
    A_bar_std = poly(end:-1:2);                             % 计算 可控标准型的目标系统矩阵A_bar最后一行
    K_bar=A_bar_std(1,:)+A_std(r0,:);
    K=K_bar*P;
elseif (size(B,2)>1)
    return 
end

