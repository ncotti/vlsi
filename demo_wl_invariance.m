%% Demo W/L Invariance
% This file demonstrates that the curves "gm/Id(Vgs)" and 
% "gm/Id( Id/(W/L) )" are independent of the values of "L" and "W", i.e.,
% the length and width of the channel.
clc; clear; close all;
addpath("HspiceToolbox")

W = [5e-6 10e-6 15e-6 20e-6 25e-6];
L = [1e-6 5e-6];
Legend = cell(length(L)*length(W),2);

for j=1:length(L)
    for i=1:length(W)
        x = loadsig(sprintf('hspice_vgs/hspice_nmos_l%d_w%d.sw0', L(j)*1e6, W(i)*1e6));
        vgs = evalsig(x, 'vgs');
        id = evalsig(x, 'i_m0_');
        
        gm = diff(id)/(vgs(2)-vgs(1));
        gm_id = gm./id(1:end-1);
        
        subplot(2,1,1)
        plot(vgs(1:end-1), gm_id);
        hold on;
        Legend{i+(j-1)*length(W),1}=sprintf("L=%dum, W=%dum", L(j)*1e6, W(i)*1e6);
        
        subplot(2,1,2)
        semilogx(id(1:end-1)/(W(i)/L(j))/1e-6, gm_id);
        hold on;
        Legend{i+(j-1)*length(W),2}=sprintf("L=%dum, W=%dum", L(j)*1e6, W(i)*1e6);
    end
end

%% Plotting
subplot(2,1,1);
title("g_m/I_D(V_{gs})");
legend(Legend{:,1});
grid on;
xlabel("V_{gs} [V]");
ylabel("g_m/I_D [1/V]");

subplot(2,1,2);
title("g_m/I_D(I_D/(W/L))");
legend(Legend{:,2});
grid on;
xlabel("I_D/(W/L) [uA]");
ylabel("g_m/I_D [1/V]");
