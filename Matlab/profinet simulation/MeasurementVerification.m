function [y,index,number] = fcn(Ethernet, RT, IRT, SensorCh, Ts_RT, Ts_SRT, Ts_IRT, Ts, N_ver)


persistent RT_buf IRT_buf ind num t RT_snap_buf IRT_snap_buf;
%% Initialization
if isempty(t)
    RT_snap_buf = zeros(length(RT),N_ver);
    IRT_snap_buf = zeros(length(IRT),N_ver);
    RT_buf = zeros(length(RT),N_ver);
    IRT_buf = zeros(length(IRT),N_ver);
    ind = zeros(length(Ethernet(:,1)),3);
    num = zeros(length(Ethernet(:,1)),3);
    t = 0;
else
    t=t+1;
    if ~mod(t,floor(Ts_SRT/Ts))
        if SensorCh == 1
            RT_snap_buf = RT_buf;
        elseif  SensorCh == 2
            IRT_snap_buf = IRT_buf;
        end
    else
        if (mod(t,floor(Ts_SRT/Ts)) <= (N_ver+1)*Ts_RT/Ts+1 && SensorCh == 1) || (mod(t,floor(Ts_SRT/Ts)) <= (N_ver+1)*Ts_IRT/Ts+1 && SensorCh == 2)
            if ~mod(t,Ts_RT/Ts) && SensorCh == 1
                RT_buf = [RT, RT_buf(:,1:N_ver-1)];
            elseif  ~mod(t,Ts_IRT/Ts) && SensorCh == 2
                IRT_buf = [IRT, IRT_buf(:,1:N_ver-1)];
            end
        end
    end
end

%%  Sensor data is accepted via PROFIBUS channel RT or IRT 
if SensorCh == 1
    y = [RT;zeros(3-length(RT),1)];
else
    y = [IRT;zeros(3-length(IRT),1)];
end

%% Signal verification upon receiving Etherent package 
for i = 1:length(Ethernet(:,1))
    if Ethernet(i,1)
        if SensorCh == 1
            [ind(i,:), num(i,:)] = findDelaySamplingBurstExact(RT_snap_buf(i,:), Ethernet(i,2:end),i);
            [ind(i,:), num(i,:)] = findDelaySamplingBurst(RT_snap_buf(i,:), Ethernet(i,2:end),i);
            [ind(i,:), num(i,:)] = findDelayElnagar(RT_snap_buf(i,:), Ethernet(i,2:end),i);
        else
            [ind(i,:), num(i,:)] = findDelaySamplingBurstExact(IRT_snap_buf(i,:), Ethernet(i,2:end),i);
        end
    end
end


index =  ind;
number =  num;

end


function [ind, n] = findDelaySamplingBurstExact(y_rt,y_eth,state)
    % Helping variables initialization
    s_max =  0;
    index = -1;
    
    persistent index_old max_index;
    if isempty(index_old)
        index_old = [-1 -1 -1];
        % Maximal time delay value/index that can be estimated
        % basically N_ver - N_samples + 1 
        max_index = length(y_rt)-length(y_eth)+1;
    end
    
    % The algorithm performs iterative search shifting y_eth array and
    % comparing to y_rt array in with the length(y_eth) window size 
    %
    % The algorithm searches for exact same pattern of values/measurements 
    %
    % The number of same patterns in tracked to calcualte confidence index
    %
    % Additionally last index is saved and introduced as heuristic value to
    % the algorithm
    %
    n = 0;
    for i = 1:max_index
      s_tmp = y_rt(i:length(y_eth)-1+i)-y_eth(1:length(y_eth));
      s=sum(s_tmp==0);
      if abs(s) >= abs(s_max)
        % Keeping track of number of repetitions of y_eth measurements
        % pattern the controller buffer - to be used for estimation 
        % confidence index
        if s == length(y_eth)
            n = n + 1;
        end
        % heuristic part
        if  index_old(state) == i
            % 1.01 is empiric value
            s_max = s*1.01;
        else
            s_max = s;
        end
        index = i;
      end
    end
    ind = max_index - index;
    % if it's not the perfect matching return -1
    if abs(s_max) < length(y_eth)
        ind = -1;
    end
    index_old(state)=index;
end


function [ind,n] = findDelaySamplingBurst(y_rt,y_eth,state)
    % Helping variables initialization
    s_min =  inf;
    index = -1;
    
    persistent index_old max_index;
    if isempty(index_old)
        index_old = [-1 -1 -1];
        % Maximal time delay value/index that can be estimated
        % basically N_ver - N_samples + 1 
        max_index = length(y_rt)-length(y_eth)+1;
    end
    
    % The algorithm performs iterative search shifting y_eth array and
    % comparing to y_rt array in with the length(y_eth) window size
    %
    %
    % The minimal distance index is saved and it is the taken as time-dealy
    % estimate
    %
    % The number of same patterns in tracked to calcualte confidence index
    %
    % Additionally last index is saved and introduced as heuristic value to
    % the algorithm
    %
    n = 0;
    for i =  1 : max_index
      % Simple absolute distance calculation in between two arrays
      s=sum(abs(...
                y_rt( i:length(y_eth)-1+i ) - y_eth...
                ));
      
      if abs(s) <= abs(s_min)
        s_min = s;
        index = i;
        % heuristic part
        if  index_old(state) == i
            % 1e-2 is empiric value
            s_min = s_min - 1e-2;
        end
        % Keeping track of number of repetitions of y_eth measurements
        % pattern the controller buffer - to be used for estimation 
        % confidence index
        if s <= 0
            n = n + 1;
        end
      end
    end
    index_old(state)=index;
    ind = max_index - index;
end

function [ind, n] = findDelayElnagar(y_rt,y_eth,state)
    % Helping variables initialisation
    Emin =  inf;
    index = -1;
    
    persistent J lambda max_index;
    if isempty(J)
        % Maximal time delay value/index that can be estimated
        % basically N_ver - N_samples + 1 
        max_index = length(y_rt)-length(y_eth)+1;
        
        % An performance index - algorithm searches for it's minimum
        J = zeros(max_index,3);
        % forgetting factor - Recursive estimation
        lambda = 0.1;
    end
    
    
    %% This algorithm is as well very simple and for explanantion see: 
    % System Identification and Adaptive control Based on a Variable Regression for System Having Unknown Delay
    % A. Elnagar
    % Equation (11,12,13,14,15)
    % 
    % New Method for Delay Estimation
    % A. Elnagar
    %
    % The algorithm is based on iterative search to minimize performance
    % index criterion
    % 
    %
    % The number of same patterns in tracked to calcualte confidence index
    %
    %
    % In it's core, the algorithm is RLS and is used to estimate system
    % parameters, but in this case, we know exact output of the system and
    % therefore there is no need to estimate parameters and output
    % accordingly
    %
    n = 0;
    for ki = 1 : max_index
        % To improve the performance of this algrithm burst sampling in
        % introduced
        %
        % Algorithm minimizes criterium by calculating distance in between
        % array as in Burst sampling algorithm 
        % It becomes a lot more stable
         
        % Burst sampling   
        dY = (y_rt(ki:ki+length(y_eth)-1) - y_eth);
        J(ki,state) = lambda*J(ki,state) + sum(dY.^2);
        %J(ki,state) = lambda*J(ki,state) + sum((u(ki:ki+length(y_eth)-1).*dY).^2);
        
        % Just one value
        %J(ki) = lambda*J(ki) + sum(((y_rt(ki) - y_eth(1))).^2);
        %J(ki) = lambda*J(ki) + sum((u(ki).*(y_rt(ki) - y_eth(1))).^2);
        
        if J(ki,state) <= Emin
           Emin = J(ki,state);
           index = ki;
        end
        % Keeping track of number of repetitions of y_eth measurements
        % pattern the controller buffer - to be used for estimation 
        % confidence index
        if abs(dY) == 0
           n = n+1;
        end
    end
    ind = max_index - index;
end