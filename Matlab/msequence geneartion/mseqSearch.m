function [ms]=mseqSearch(baseVal,powerVal,shift,whichSeq)
%		 Maximum length sequence assuming distinct values = baseVal
%       [ms]=mseqSearch(powerVal,baseVal)
%
%       OUTPUT:
%         ms:       generated maximum length sequence, of length basisVal^powerVal-1
%                   such that all values occur with equal frequency except
%                   zero
%
%       INPUT:
%		  baseVal:  any prime number up to 31
%         powerVal: an integer
%       NB: the algorithm is performing search in m-sequence register space
%         so the calculation time grows with baseVal and powerVal
%         Tested on Matlab 7.9.0 (R2009b)
%
% (C) Written by Giedrius T. Buracas, SNL-B, Salk Institute 
%                                 and Center for Functional MRI, UCSD

if nargin<4, whichSeq=1; end
if nargin<3, shift=0; end;

seqLen=baseVal^powerVal-1;
register=ones(powerVal,1);
regLen=length(register);
tap = zeros(regLen);

isM=0; % is m-sequence?
count=0;
% preallocation
ms=zeros(seqLen*2,1);
weights=[];
while ~isM
    noContinue=0;
    count=count+1;
    if count>seqLen*4, break; end;
   % now generate taps incrementally 
   tap = dec2base(count,baseVal,regLen);
   
   for i=1:regLen, 
       %weights(i)=str2num(tap(i)); 
       weights(i)=base2dec(tap(i),baseVal); 
   end;
   %regLen=length(tap);
   %weights
  
   for seq=2*regLen:2:seqLen*2-2
       %seq
       ms(1:seq)=zeros(seq,1);
       for i=1:seq
          %   calculating next digit with modulo powerVal arithmetic
          ms(i)=rem(weights*register+baseVal,baseVal);
          % updating the register
          register=[ms(i);register(1:powerVal-1)];
          
          %[ms(i), register']
       end;
      %ms(1:seq)';
       %pause

       foo = (ms(1:seq/2)==ms(seq/2+1:seq));
       if sum(foo)==seq/2, 
           noContinue=1;
           register=ones(powerVal,1);
           break ; 
       end; % if two halfs equal
       
   end
   
   if ~noContinue,
        for i=1:seqLen*2
          %   calculating next digit with modulo powerVal arithmetic
          ms(i)=rem(weights*register+baseVal,baseVal);
          % updating the register
          register=[ms(i);register(1:powerVal-1)];
      end;
     foo = (ms(1:seqLen)==ms(seqLen+1:seqLen*2)); 
     if sum(foo)==seqLen, isM=1; weights; end;
   end;
   %ms'
   
end; % while

ms=ms(1:seqLen);
%count

if ~isempty(shift),
   shift=rem(shift, length(ms));
   ms=[ms(shift+1:end); ms(1:shift)];
end;

if ~isM, ms=[]; end;
weights
