function steady_state_error = get_stady_state_error(close_transfunc)

%��ֵ�������ջ���̬���
syms s
steady_state = limit(s*close_transfunc, s, 0);
steady_state_error = 1-steady_state;%��λ��Ծ��Ӧ
%limit������syms���ͱ��� syms�Ա��� inf������/-inf������/x0��,left right���߼���

%������������ʱ��Ƕ��ʹ��limit

