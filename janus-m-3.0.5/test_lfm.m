clear all

fd=44100;
t=0:1/fd:1;
f=2000 + (15000-5000)*t/max(t);
s=0.9*sin(2*pi*f.*t);
s = [zeros(size(s)) s s(end:-1:1) zeros(size(s))];
specgram(s)

audiowrite('sweep.wav', s, 44100);
