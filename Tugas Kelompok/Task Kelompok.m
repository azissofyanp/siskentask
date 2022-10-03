clc 
clear all
close all

% Get the tangent line
J = 0.01;
b = 0.1;
K = 0.01;
R = 1;
L = 0.5;
s = tf('s');

num_motor = [K];
den_motor = [J*L J*R+b*L R*b+K*K];
motor = tf(num_motor,den_motor);

% =========== mencari tangenline dan menetukan nilai T dan Y ================
tic
timeVal=tic;
[y,t] = step(motor);
h = mean(diff(t));
dy = gradient(y, h);                                            % Numerical Derivative
[~,idx] = max(dy);                                              % Index Of Maximum
b = [t([idx-1,idx+1]) ones(2,1)] \ y([idx-1,idx+1]);            % Regression Line Around Maximum Derivative
tv = [-b(2)/b(1); (1-b(2))/b(1)];                               % Independent Variable Range For Tangent Line Plot
f = [tv ones(2,1)] * b;                                         % Calculate Tangent Line

L = tv(1);
T = tv(2);

figure(1)
plot(t, y)
hold on
plot(tv, f, '-r')                                               % Tangent Line
plot(t(idx), y(idx), '.r')
title('Mencari tangent line plant ')% Maximum Vertical
hold off
grid

% ================ menentukan control PID sistem ===================

% Deklarasi variable control
control = tf(zeros(1,1,5));
sys=tf(zeros(1,1,5));
complete=tf(zeros(1,1,5));

% sistem dengan P
kp = T/L
control(:,:,1)= tf([0 kp 0],[1 0]);

% sistem dengan PI
kp = 0.9*T/L
Ti= L/0.3;
ki = kp/Ti
control(:,:,2)= tf([0 kp ki],[1 0]);

% sistem dengan PID
kp = 1.2*T/L
Ti= 2*L;
ki = kp/Ti
Td = 0.5*L;
kd = kp*Td
control(:,:,3)= tf([kd kp ki],[1 0]);

toc

%menentukan transfer function sistem
for x = 1:3
    sys(:,:,x) = motor*control(:,:,x);
    complete(:,:,x) = feedback(sys(:,:,x),1);
end


for x = 1:3
    %Step response
    figure(2)
    hold on
    step(complete(:,:,x));
    title('Step Response sistem')
    legend('kendali P', 'kendali PI','kendali PID')
    hold off

    % Mencari karakteristik gelombang 
    tf_info(x)= stepinfo(complete(:,:,x));
    % mencari steady state error
    [y,t]=step(complete(:,:,x));
    sserror(x)=(1-y(end));
    
    % Impulse Repsonse    
    figure(3)
    hold on
    impulse(complete(:,:,x));
    title('Impulse Response sistem')
    legend('kendali P', 'kendali PI','kendali PID')
    hold off
    
    % Ramp Repsonse 
    figure(4)
    hold on
    step(complete(:,:,x)/s);
    title('Ramp Response sistem')
    legend('kendali P', 'kendali PI','kendali PID')
    hold off
    
    figure(5)
    hold on
    step(complete(:,:,x)/(s*s));
    title('Acceleration Response sistem')
    legend('kendali P', 'kendali PI','kendali PID')
    hold off
end
