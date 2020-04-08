%% 
% Simple primitive polinomial search algorthm
%
% stages - number of values of the sequence - dictionary length
% uniqueLength - length of the unique sequence window
% startWeight - the weight to start iterative search 
%               default is [0 0 ... 0]
% number - number of polinomials to find, if the user does not need all of
% them.
% 
%
function weights = mseqSearchSiemens(stages, uniqueLength, number, startWeight)

    order=stages^uniqueLength-1;
    p=zeros(1,uniqueLength);
    weights = p;
    
    loopCountStart = 0;
    
    if nargin == 4
        p = startWeight; 
         for l = 0: uniqueLength -1
           loopCountStart =  loopCountStart + p(uniqueLength - l)*stages^l; 
        end 
    end
    if nargin < 3
        number = inf;
    end
    count = 0;
    
    for n = loopCountStart:stages^uniqueLength
        for l = 0: uniqueLength -1
           p(uniqueLength - l) =  mod(floor(n*stages^(-l)),stages);
        end        
        clear o ms
        register = ones(uniqueLength,1);
        reg_start = register;
        for o=1:order
          % calculating next digit with modulo powerVal arithmetic
          % register, (tap(1).No)

          % ms(i)=rem(sum(register(tap(whichSeq).No)),baseVal);
          ms(o)=rem(p*register+stages,stages);
          % updating the register

          register=[ms(o); register(1:uniqueLength-1)];
          if register == reg_start
              break;
          end
        end
        r = 0;
        for i = 1: length(ms) - uniqueLength
           if 0 == sum(abs(ms(1:uniqueLength+1) - ms(i:i+uniqueLength)));    
                r = r+1;
                if r > 1
                    break
                end
           end
        end
        if r == 1 && o == order
           weights = [weights; p]; 
           count = count + 1; % counting number of polynomials
        end
        if count >= number
           break; 
        end
        clear o ms  i
    end
    weights = weights(2:end,:);
end