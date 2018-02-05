function traffic = PredictTraffic(lastNDayReqs, LastSlotReqs, SlotNumber)

slotNumArray = zeros(24);
slotNumArray(SlotNumber) = 1;

b = 0;
w = [1, 2, 3];

params = [lastNDayReqs LastSlotReqs slotNumArray];
traffic = w' * params + b;

