function freq  = createFeature(email_contents,dictionary)
C=split(email_contents);
present_words=[];idx=[];
word_indices = [];
[uniqueB, ~, J]=unique(C) ;
occ = histc(J, 1:numel(uniqueB));
freq=[uniqueB,occ];
for j=1:length(uniqueB)
    for i = 1:size(dictionary,1)
        if strcmp(uniqueB{j},dictionary{i})
            present_words=[ present_words;uniqueB(j)];
            idx=[idx;j];
            word_indices = [word_indices; i];
            break;
        end
    end 
end
V=uniqueB(idx,:);
count=occ(idx,:);
freq=[word_indices,count];
end