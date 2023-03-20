clear all

fd=44100;
t=0:1/fd:0.2;
f = 15000 - 14000*exp(-2*t/max(t));
s=0.9*sin(2*pi*f.*t);
s = [zeros(size(s)) s s(end:-1:1)  s s(end:-1:1)  s s(end:-1:1)  s s(end:-1:1)  s s(end:-1:1)  s s(end:-1:1)  s s(end:-1:1)  s s(end:-1:1) zeros(size(s))];
specgram(s)

audiowrite('bell.wav', s, 44100);
