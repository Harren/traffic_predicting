function lastNDaysSlot = SmoothedNDayReqs(reqs, len, k, start)

history = zeros(k, 1);
for i=1:k
    history(i, 1) = reqs(start + i ,len);    
end
lastNDaysSlot = prod(history)^(1/length(history)); 

