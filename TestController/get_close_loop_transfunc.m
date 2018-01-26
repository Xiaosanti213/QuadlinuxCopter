function close_transfunc = get_close_loop_transfunc(transfunc, feedback_gain)

%单输入单输出
close_transfunc = simplify(transfunc/(1+transfunc*feedback_gain));





