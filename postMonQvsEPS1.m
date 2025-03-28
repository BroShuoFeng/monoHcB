% q vs. eps1
figure;hold on;box on;grid on;
xlabel('{\it\epsilon}_1 / %');
ylabel('{\itq} / MPa');

%%
for num=1:monNum
    x=EPS{num,sam}(:,1);
    y=SIG{num,sam}(:,1)-SIG{num,sam}(:,3);
    plot(100*real(x),real(y)/1e3,'-');
    clear x y
end
