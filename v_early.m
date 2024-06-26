%% V_EARLY for Different Channel Length "L"
% Both PMOS and NMOS transistor where simulated with Vgs = 0.6V, W=10um.
clc; clear; close all;
addpath("HspiceToolbox");

L_name = ["01", "02", "03", "04", "05", "06", "07", "08", "09"];
L = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9];  % Length [um]
min_vds = 0.4;          % Minimum VDS to plot V_early     
D = ["nmos", "pmos"];   % Devices

for j=1:length(D)
    figure(NumberTitle="off", name=upper(D(j)));
    Legend = cell(length(L),1);

    for i=1:length(L)
        x = loadsig(sprintf('hspice_vds/hspice_%s_l%s.sw0', D(j), L_name(i)));
        
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
        
        subplot(2,1,1);
        plot(vds, abs(id)*1e6);
        hold on;
    
        subplot(2,1,2);
        plot(vds(index:end-1), vEarly(index:end));
        hold on;
        Legend{i,1}=sprintf("L=%0.1fum", L(i));
    end

    %% Plotting
    subplot(2,1,1)
    title(sprintf("%s current", upper(D(j))));
    legend(Legend{:,1});
    grid on;
    xlabel("V_{ds} [V]");
    ylabel("I_D [uA]");
    xlim([min(vds), max(vds)]);
    
    subplot(2,1,2)
    title(sprintf("%s V_{early} = 1/lambda", upper(D(j))));
    legend(Legend{:,1});
    grid on;
    xlabel("V_{ds} [V]");
    ylabel("V_{early} [V]");
end
