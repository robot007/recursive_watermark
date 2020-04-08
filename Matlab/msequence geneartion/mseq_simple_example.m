%% Initialization of Pseudo Random M-sequence calculation
stages = 7;
uniqueLen = 7;
% Running the search for the primitive polynom weights
poly_weights = mseqSearchSiemens(stages, uniqueLen, 1);

period=stages^uniqueLen-1;
register=ones(uniqueLen,1);

mseqence=zeros(period,1);
reg_start = register;

  
%% M-sequence calculation
for i=1:period
  % calculating next sequence state with modulo stages arithmetic
  % register
  mseqence(i)=rem(poly_weights*register+stages,stages);
  
  % updating the register
  register=[mseqence(i); register(1:uniqueLen-1)];

  if register == reg_start
    % If register is the same as on the beggingin the period polynom is nor
    % primitive
    break 
  end
end

%% Perform a "burst" serach algotrithm to check the PRm sequence
clear cor
% minimal uniqe window is uniqueLen
searchWindow = uniqueLen;
offset = round(period/4);

for i = 1: length(mseqence) - searchWindow
   cor(i) = sum(abs(...
       mseqence(offset:searchWindow+offset) - mseqence(i:i+searchWindow)...
       ));    
end
% the plot must show only one 0 value of algorithm plot 
% and the exact place of the 0 value must me offet
figure(1)
subplot(2,1,1)
title('M-sequence')
plot(mseqence)
subplot(2,1,2)
title('Search algorithm output')
hold on;
plot(cor)
plot(offset,0,'or');

