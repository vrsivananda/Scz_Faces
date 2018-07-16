counter = 0;
for i = 1:2:length(data.rt)
   
    if(data.targetZScore(i) >= lowPECutoff)
    
        disp(i);
        disp(data.targetZScore(i));
        disp(data.nonTargetZScore(i));
        disp(data.distractorZScore(i));
        
        counter = counter + 1;
   
    end
    
end

disp(['counter: ' num2str(counter)]);