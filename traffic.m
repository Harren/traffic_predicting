%% 选择最近K天的流量为基准
k = 15;             %% 生成的请求的数据
tol = 400;          %% 最大容忍度
trainK = 7;         %% 训练样本的天数
T = 24;             %% 每天的时间片数
fakeSmooth = 4;
lastNDayRequest = zeros(trainK, T);
lastSlotReqs = zeros(trainK, T);
trueValue = zeros(trainK, T);

reqs = zeros(k, T);

for i = 1:k
    reqs(i, 1) = 23 + rand(1);
    reqs(i, 2) = 12.445 + rand(1) * 10.445/fakeSmooth;
    reqs(i, 3) = 6.454 + rand(1) * 4.454/fakeSmooth;
    reqs(i, 4) = 3.2155 + rand(1) * 2.215/fakeSmooth;
    reqs(i, 5) = 2.394 + rand(1) * 1.394/fakeSmooth;
    reqs(i, 6) = 3.273 + rand(1) * 2.273/fakeSmooth;
    reqs(i, 7) = 6.225 + rand(1) * 5.225/fakeSmooth;
    reqs(i, 8) = 11.523 + rand(1) * 11.523/fakeSmooth;
    reqs(i, 9) = 15.911 + rand(1) * 15.911/fakeSmooth;
    reqs(i, 10) = 16.839 + rand(1) * 16.839/fakeSmooth;
    reqs(i, 11) = 16.414 + rand(1) * 16.414/fakeSmooth;
    reqs(i, 12) = 16.808 + rand(1) * 16.808/fakeSmooth;
    reqs(i, 13) = 19.598 + rand(1) * 19.598/fakeSmooth;
    reqs(i, 14) = 15.036 + rand(1) * 15.036/fakeSmooth;
    reqs(i, 15) = 15.204 + rand(1) * 15.204/fakeSmooth;
    reqs(i, 16) = 19.085 + rand(1) * 19.085/fakeSmooth;
    reqs(i, 17) = 18.855 + rand(1) * 18.855/fakeSmooth;
    reqs(i, 18) = 19.520 + rand(1) * 19.520/fakeSmooth;
    reqs(i, 19) = 19.713 + rand(1) * 19.713/fakeSmooth;
    reqs(i, 20) = 21.547 + rand(1) * 21.547/fakeSmooth;
    reqs(i, 21) = 23.107 + rand(1) * 3.107/fakeSmooth;
    reqs(i, 22) = 25.534 + rand(1) * 25.534/fakeSmooth;
    reqs(i, 23) = 24.329 + rand(1) * 24.329/fakeSmooth;
    reqs(i, 24) = 22 + rand(1) * 22/fakeSmooth;
end

%% 获取到训练数据, 需要估计的参数有27个，训练样本有24 * 7 = 168个
X = zeros(trainK * T, 27);
Y = zeros(trainK * T, 1);
for i = 1:trainK
    for j=1:T
        %% SmoothedNDayReqs
        lastNDayRequest(i, j) = SmoothedNDayReqs(reqs, j, trainK, i);
        %% SmoothedLastSlotReqs
        lastSlotReqs(i,j) = SmoothedLastSlotReqs(reqs, j, trainK, tol, i);
        trueValue(i, j) = reqs(i,j);
        
        w = zeros(1, T);
        w(1, j) = 1;
        
        X((i-1) * T + j, :) = [w, lastNDayRequest(i, j), lastSlotReqs(i,j), 1];
        Y((i - 1) * T + j, 1) = trueValue(i, j);
    end
end

%% LR, r为残差，rint置信区间，
[b, bint, r, rint, stats] = regress(Y, X);

predict = X * b;

x=1:1:24;
plot(x, predict(1:24, 1), '--*r', x, Y(1:24, 1), '-xb')
legend('预测流量','真实流量');
xlabel('时段');
ylabel('流量');

figure
rcoplot(r(1:24, :), rint(1:24, :));

%% PredictTraffic
%x=1:1:24;
%plot(x, reqs(1, :), '--*r', x, reqs(1, :) - 4 * rand(1, 24) - 1, '-xb')
%legend('广告总流量','已购买总流量');
%xlabel('时段');
%ylabel('流量');
%%plot(x, reqs(1, :), x,reqs(2, :),  x,reqs(3, :),  x,reqs(4, :),  x,reqs(5, :),  x,reqs(6, :),  x,reqs(7, :));




