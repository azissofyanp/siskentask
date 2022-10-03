clearvars
clc
close all

%Persamaan plant

T = 16;
s = tf('s');
num=[1];
den=[T T/16 1];
plant = tf(num,den);

kp = 1;
kd = [1 3 5 7 9];

%Deklarasi variable control
control = tf(zeros(1,1,5));
sys=tf(zeros(1,1,5));
complete=tf(zeros(1,1,5));

%Transfer function sistem
for x = 1:5
    control(:,:,x) = tf([kd(x) kp 0],[1 0]);
    sys(:,:,x) = plant*control(:,:,x);
    complete(:,:,x) = feedback(sys(:,:,x),1);
end


for x = 1:5
    %Step response
    figure(1)
    subplot(3,2,x)

    step(complete(:,:,x));
    title(['Step Response Kd: ',num2str(kd(x))])
    
    %xlim([290 310]);
    % Mencari karakteristik gelombang 
    tf_info(x)= stepinfo(complete(:,:,x));
    % mencari steady state error
    [y,t]=step(complete(:,:,x));
    sserror(x)=(1-y(end));
    
    % Impulse Repsonse    
    figure(2)
    subplot(3,2,x)
    impulse(complete(:,:,x));
    title(['Impulse Response Kd: ',num2str(kd(x))])
    %xlim([290 310]);
    
    % Ramp Repsonse 
    figure(3)
    subplot(3,2,x)
    step(complete(:,:,x)/s);
    title(['Ramp Response Kd: ',num2str(kd(x))])
    xlim([0 20]);
end
