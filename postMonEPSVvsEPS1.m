%% epsv vs. eps1
figure;hold on;box on;grid on;
xlabel('{\it\epsilon}_1 / %');
ylabel('{\it\epsilon_v} / %');

%%
for num=1:monNum
    x=EPS{num,sam}(:,1);
    y=EPS{num,sam}(:,1)+EPS{num,sam}(:,2)+EPS{num,sam}(:,3);
    plot(x*100,y*100,'-');
    clear x y
end
