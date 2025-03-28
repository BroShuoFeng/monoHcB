%% B vs. EPS1
figure;hold on;box on;grid on;
xlabel('{\it\epsilon_1} / %');
ylabel('Breakage Index / %');

%%
for num=1:monNum
    x=EPS{num,sam}(:,1);
    y=BI{num,sam}(:,1);
    plot(x*100,y*100,'-');
    clear x y
end
