function dcm = quad2dcm(quad)
    q0=quad(1);q1=quad(2);q2=quad(3);q3=quad(4);
    dcm=[q0^2+q1^2-q2^2-q3^2,2*(q1*q2+q0*q3),2*(q1*q3-q0*q2);...
        2*(q1*q2-q0*q3),q0^2-q1^2+q2^2-q3^2,2*(q2*q3+q0*q1);...
        2*(q1*q3+q0*q2),2*(q2*q3-q0*q1),q0^2-q1^2-q2^2+q3^2];
end

