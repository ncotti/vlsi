%% V_EARLY for Different Channel Length "L"
% Both PMOS and NMOS transistor where simulated with Vgs = 0.6V, W=10um.
clc; clear; close all;
addpath("HspiceToolbox");

L = (1:1:12)*1e-6;      % Channel length
min_vds = 0.4;          % Minimum VDS to plot V_early     
D = ["nmos", "pmos"];   % Devices

for j=1:length(D)
    figure(NumberTitle="off", name=upper(D(j)));
    Legend = cell(length(L),1);

    for i=1:length(L)
        x = loadsig(sprintf('hspice_vds/hspice_%s_l%d.sw0', D(j), L(i)*1e6));
        
        vds = evalsig(x, 'vds');
        if(D(j) == "nmos")
            id = evalsig(x, 'i_m0_');
        else
            id = evalsig(x, 'i_m10_');
        end
        
    
        [~, index] = min(abs(min_vds - vds));
    
        gds = diff(id)/(vds(2)-vds(1));
        lambda = gds./id(floor(end/2));
        vEarly = lambda.^-1;
        %lambda = gds./id(1:end-1);
        %lambda = id(1:end-1)
        
        subplot(2,1,1);
        plot(vds, abs(id));
        hold on;
    
        subplot(2,1,2);
        plot(vds(index:end-1), vEarly(index:end));
        hold on;
        Legend{i,1}=sprintf("L=%dum", L(i)*1e6);
    end

    %% Plotting
    subplot(2,1,1)
    title(sprintf("%s current", upper(D(j))));
    legend(Legend{:,1});
    grid on;
    xlabel("V_{ds} [V]");
    ylabel("I_D [A]");
    xlim([min(vds), max(vds)]);
    
    subplot(2,1,2)
    title(sprintf("%s V_{early} = 1/lambda", upper(D(j))));
    legend(Legend{:,1});
    grid on;
    xlabel("V_{ds} [V]");
    ylabel("V_{early} [V]");
end
