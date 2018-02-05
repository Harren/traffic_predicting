function lastSlotReqs = SmoothedLastSlotReqs(reqs, len, k, tol, start)
history = zeros(k, 1);
if len == 1
    originalLastReqs = reqs(start + 1, 24);
    for i = 2:k
        history(i) = reqs(start + i + 1, 24);
    end  
else
     originalLastReqs = reqs(start, len - 1);
     for i = 2:k
         history(i) = reqs(start + i, len - 1);
     end
end
    
avg = mean(history);
std = var(history);
if abs(originalLastReqs - avg)/std > tol
    history(1) = originalLastReqs;
    lastSlotReqs = geo_mean(history); 
else
    lastSlotReqs = originalLastReqs;
end
