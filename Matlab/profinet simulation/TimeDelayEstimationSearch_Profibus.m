function index  = fcn( u, y_eth, y_rt)
 %% PROFIBUS settings
 % Cnannels sampling time
 Ts_RT = 1e-3;
 Ts_Eth = 2.5e-1;
 % Estimation algorithm sampling time 
 Ts = 1e-3;
 % Number of elements in verification buffer - in controller
 N_ver = 200;
 % Number messages in ethernet package - sent by sensor
 N_samples = 13;

persistent y_rt_buf u_buf ind  t y_rt_snap_buf u_snap_buf y_eth_buf y_eth_buf_snap;

%% Initialization
if isempty(t)
    
    ind = [0 0];
    % local time variable
    t = 0;
    
    % buffers needed
    u_snap_buf = zeros(1,N_ver);
    y_rt_snap_buf = zeros(1,N_ver);
    y_eth_buf_snap = zeros(1,N_samples);
    u_buf = zeros(1,N_ver);
    y_rt_buf = zeros(1,N_ver);
    y_eth_buf = zeros(1,N_samples);
else
    t=t+1;
    %% Filling the buffers - Simulating Network behavior
    %
    % This part of the code basically fills contorller verification buffer 
    % and Ethernet package of the sensor with exact data. 
    %
    % It's not too important for the algorithm to understand this part of
    % the code
    %
    %
    % THE IMPORTANT THING IS THAT ALL PACKAGES ARRIVE ON TIME - THERE IS
    % NO PACKAGE LOSS OR STOHASTIC DELIVERY TIME SIMULATION IN THIS BLOCK
    %
    if ~mod(t,floor(Ts_Eth/Ts))
        % Every Etherent sampling time save the data to buffer snapshots 
        % This simulates data receival in controller
        y_rt_snap_buf = y_rt_buf;
        y_eth_buf_snap = y_eth_buf;
        u_snap_buf = u_buf;
    else
        % In every RT channel sampling time, save the data in buffers
        %
        % This simulates controller RT packet receival
        if mod(t,floor(Ts_Eth/Ts)) <= (N_ver+1)*Ts_RT/Ts+1
            if ~mod(t,Ts_RT/Ts)
                y_rt_buf = [y_rt, y_rt_buf(:,1:N_ver-1)];
                u_buf = [u, u_buf(:,1:N_ver-1)];
            end
        end
        % In first N_samples RT channel sampling times save data for
        % sending to controller in Ethernet package 
        %
        % This is Sensor simualtions
        if mod(t,floor(Ts_Eth/Ts)) <= (N_samples+1)*Ts_RT/Ts+1
            if ~mod(t,Ts_RT/Ts)
                y_eth_buf = [y_eth, y_eth_buf(:,1:N_samples-1)];
            end
        end
    end
end


if ~mod(t,floor(Ts_Eth/Ts))
    %% Estiamtion of the time-dealy with two different methods after receival 
    % of Etherent package - every Etherent channel sampling time
    ind(1) = findDelaySamplingBurst(y_rt_snap_buf, y_eth_buf_snap);
    ind(2) = findDelayElnagar(y_rt_snap_buf, y_eth_buf_snap,u_snap_buf);
end

% output
index =  ind;%[RT_snap_buf(i,:), SRT(i,2:end)];%SRT(1,2:end);%[y_SRT, SRT];

end


function ind = findDelaySamplingBurst(y_rt,y_eth)
    % Helping variables initialisation
    s_min =  inf;
    index = -1;
    
    persistent index_old max_index;
    if isempty(index_old)
        index_old = -1;
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
    % Additionally last index is saved and introduced as heuristic value to
    % the algorithm
    %
    for i =  1 : max_index
      % Simple absolute distance calculation in between two arrays
      s=sum(abs(...
                y_rt( i:length(y_eth)-1+i ) - y_eth...
                ));
      
      if abs(s) <= abs(s_min)
        s_min = s;
        index = i;
        % heuristic part
        if  index_old == i
            % 1e-4 is empiric value
            s_min = s_min - 1e-4;
        end
      end
    end
    index_old=index;
    ind = max_index - index;
end

function ind = findDelayElnagar(y_rt,y_eth,u)
    % Helping variables initialisation
    Emin =  inf;
    index = -1;
    
    persistent J lambda max_index;
    if isempty(J)
        % Maximal time delay value/index that can be estimated
        % basically N_ver - N_samples + 1 
        max_index = length(y_rt)-length(y_eth)+1;
        
        % An performance index - algorithm searches for it's minimum
        J = zeros(max_index,1);
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
    % In it's core, the algorithm is RLS and is used to estimate system
    % parameters, but in this case, we know exact output of the system and
    % therefore there is no need to estimate parameters and output
    % accordingly
    %
    for ki = 1 : max_index
        % To improve the performance of this algrithm burst sampling in
        % introduced
        %
        % Algorithm minimizes criterium by calculating distance in between
        % array as in Burst sampling algorithm 
        % It becomes a lot more stable
        
        % Burst sampling  
        J(ki) = lambda*J(ki) + sum(((y_rt(ki:ki+length(y_eth)-1) - y_eth)).^2);
        %J(ki) = lambda*J(ki) + sum((u(ki:ki+length(y_eth)-1).*(y_rt(ki:ki+length(y_eth)-1) - y_eth)).^2);
        
        % Just one value
        %J(ki) = lambda*J(ki) + sum((y_rt(ki) - y_eth(1))).^2);
        %J(ki) = lambda*J(ki) + sum((u(ki).*(y_rt(ki) - y_eth(1))).^2);
        
        if J(ki) <= Emin
           Emin = J(ki);
           index = ki;
        end
    end
    ind = max_index - index;
end
