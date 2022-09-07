T = 10;
s = tf('s');
num=1;
den=[T T/16 1];
sys = tf(num,den);

figure(1)
step(sys);

figure(2)
impulse(sys);

figure(3)
step(sys/s); %ramp response
xlim([0 50]);
title("Ramp response");

%mendapatkan overshoot, risetime dan settling time
s1 = stepinfo(sys);
disp(s1);

% Menghitung steady state error
[y,t]=step(sys);
sserror=(1-y(end));
