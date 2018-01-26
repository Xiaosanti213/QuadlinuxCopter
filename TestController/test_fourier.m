%test fourier
syms x
f = x*(x-pi)*(x-2*pi);

[A,B,F] = fourier_series(f,x,12,0,2*pi);