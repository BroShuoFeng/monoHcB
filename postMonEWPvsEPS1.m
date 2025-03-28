% q vs. epsq
figure;hold on;box on;grid on;
xlabel('{\it\epsilon_q} / %');
ylabel('Excess Porewater Pressure / MPa');

%%
for num=1:monNum
    x = EPS{num,sam}(:,1);
    y = EWP{num,sam}(:);
    plot(100*x,y/1000,'-');
    
    clear x y
end
