function dictionary = createDctionary(words)
tokenizedSonnets = tokenizedDocument(words);
bag = bagOfWords(tokenizedSonnets);
%Taking top 2500 words for our dictionary
B=topkwords(bag, 2500);
dictionary1= B{:,1};
vocabList =readtable('vocab.txt');
dictionary2=string(vocabList{:,2});
dictionary3=[dictionary1;dictionary2];
dictionary=unique(dictionary3);
end