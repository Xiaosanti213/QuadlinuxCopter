function rot = euler2dcm(ang)
phi=ang(1);theta=ang(2);psi=ang(3);
L1=[1 0 0;0 cos(phi) sin(phi);0 -sin(phi) cos(phi)];
L2=[cos(theta) 0 -sin(theta);0 1 0;sin(theta) 0 cos(theta)];
L3=[cos(psi) sin(psi) 0;-sin(psi) cos(psi) 0;0 0 1];
rot=(L3*L2*L1)';
end

