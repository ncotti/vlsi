%% gm/ID Curves
% Plot the gm/Id curves for the NMOS and PMOS transistor of the SAED_PDK_90
% All curves were measured with W=5um, VDS=0.6V
clc; clear; close all;
addpath("HspiceToolbox")

W = 5e-6; % Channel width
L = [0.1 0.2 0.3 0.4 0.5 0.8 1 5]*1e-6;        % Channel length
L_name = ["01", "02", "03", "04", "05", "08", "1", "5"];
D = ["nmos", "pmos"];               % Devices

for k=1:length(D)
    figure(NumberTitle="off", Name=upper(D(k)));
    Legend = cell(length(L)*length(W),2);
    for j=1:length(L)
        for i=1:length(W)
            x = loadsig(sprintf('hspice_vgs/hspice_%s_l%s_w%d.sw0', D(k), L_name(j), W(i)*1e6));
            
            vgs = evalsig(x, 'vgs');
            if (D(k) == "nmos")
                id = evalsig(x, 'i_m0_');
            else
                id = -evalsig(x, 'i_m10_');
            end

            gm = diff(id)/(vgs(2)-vgs(1));
            gm_id = gm./id(1:end-1);
            
            subplot(2,1,1)
            plot(vgs(1:end-1), gm_id);
            hold on;
            Legend{i+(j-1)*length(W),1}=sprintf("L=%0.1fum, W=%dum", L(j)*1e6, W(i)*1e6);
            
            subplot(2,1,2)
            semilogx(id(1:end-1)/(W(i)/L(j))/1e-6, gm_id);
            hold on;
            Legend{i+(j-1)*length(W),2}=sprintf("L=%0.1fum, W=%dum", L(j)*1e6, W(i)*1e6);
        end
    end

    %% Plotting
    subplot(2,1,1);
    title(sprintf("%s g_m/I_D(V_{gs})", upper(D(k))));
    legend(Legend{:,1});
    grid on;
    xlabel("V_{gs} [V]");
    ylabel("g_m/I_D [1/V]");
    
    subplot(2,1,2);
    title(sprintf("%s g_m/I_D(I_D/(W/L))", upper(D(k))));
    legend(Legend{:,2});
    grid on;
    xlabel("I_D/(W/L) [uA]");
    ylabel("g_m/I_D [1/V]");
end
