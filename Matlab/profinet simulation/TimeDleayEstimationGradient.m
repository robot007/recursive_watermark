function Td    = fcn( u, y_eth,y_rt)
    
    persistent Td_est  u_buf y_attack_buf An Bn Td_max ha hb y_real_buf Td_index mi em Phi
    
    if isempty(mi)
        
       %% Process initialization 
       % 
       % IMPORTANT !!!
       % The right process has to be uncomented to run the estimation
       %
       % Simple process 1 
       hb = [0.001665];ha = [0.9983];
       
       % Motor Discrete Transfer Function
       %hb = [4.99e-05, 5.875e-05, 2.081e-07];ha = [1.997, -0.997, 1.184e-10];

       An = length(ha);
       Bn = length(hb);
       
       %% Buffers and helping variables
       Td_est = 1; 
       Td_max = 200;
       u_buf = zeros(Td_max, 1);
       y_attack_buf = zeros(Td_max, 1);
       y_real_buf = zeros(Td_max, 1);
       
       %% Convergence gain
       mi = 1e4;
    else
        %% In every step update all buffers
        % system input
        u_buf = [u; u_buf(1:end-1)];
        % system output before attack
        y_real_buf = [y_eth; y_real_buf(1:end-1)];
        % system output after attack
        y_attack_buf = [y_rt; y_attack_buf(1:end-1)];
    end

    % Limiting the Td    
    if Td_est  < 0
        Td_est = 0;
    end
    if Td_est >= Td_max - Bn - 15
        Td_est = Td_max - 1 - Bn - 15;
    end    
    
    
    %% Estimation algorithm 
    % See: 
    % New Reasults on Discrete-time Delay Systems Identification 
    % Author S.Bedoni
    % Equation (8,9,10) 
    Theta = [Td_est];
    Td_index = round(Td_est)+1;
    % input signal differential
    dU = u_buf(Td_index:Td_index+Bn-1)-u_buf(Td_index+1:Td_index+1+Bn-1);
    Phi = [sum(-hb*dU)];
    % prediction error calculation
    % not actual prediction since we know the true value in advance
    em = sum(y_real_buf(1) - y_attack_buf(Td_index)); 
    % limiting the convergence criteria 
    if Phi && mi > 2/Phi^2
        mi = 1/Phi^2*0;
    end
    Theta = Theta + mi*Phi*em ;
    Td_est = Theta ;
   
    
    Td = [Td_est,Td_index];
    
end