function close_transfunc = get_close_loop_transfunc(transfunc, feedback_gain)

%�����뵥���
close_transfunc = simplify(transfunc/(1+transfunc*feedback_gain));





