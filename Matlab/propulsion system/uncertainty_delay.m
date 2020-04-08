s=tf('s');
tao=ureal('tao',0.1,'Percentage',10);
delay=exp(tao*s);
delay2=pade(delay,3);