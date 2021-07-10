clc;
clear all;
tic;
%Read dataset
A=readtable('SpamCollection5574.xlsx');
m=height(A);
words=[];
B=string;
%Preprocessing the data and store words of each email
for i=1:m
file_contents = char(A{i,2});
[temp,processed_email]=WordArray(file_contents);
words=[words;temp];
%B(i,1)=char(A{i,1});
B(i,2)=processed_email;
end
%create dictionary of words
dictionary=createDctionary(words);
%Create Feature Matrix for 1st training set containing 5574 emails
M=[];
for i=1:m
freq  = createFeature(B(i,2),dictionary);
temp=i*ones(size(freq,1),1);
tempM=[temp,freq];
M=[M;tempM];
end



% Extracting features for second data set containing only ham mails
% Extracting features from Ham mail Folder
currentFolder=pwd;
folder=strcat(currentFolder,'\nonspam-train');
%folder = 'C:\Users\MILAN CHATTERJEE\Downloads\Naive Bayes Spam\nonspam-train';
testFiles=dir(fullfile(folder,'*.txt'));
TrainHam=cell(1,length(testFiles));
for i=1:numel(testFiles)
  filename=fullfile(folder,testFiles(i).name);
  TrainHam{i}=readFile(filename);
end
%Assinging train label of zeros to Ham mails
train_labels2=zeros(length(testFiles),1);
n=numel(testFiles)+m;
for i=m+1:n
file_contents = TrainHam{i-m};
[word_indices,freq ]  = processEmailMy(file_contents,dictionary);
temp=i*ones(length(freq),1);
tempM=[temp,freq];
M=[M;tempM];
end

% Extracting features for third data set containing only spam mails
% Extracting features from SPam mail Folder
currentFolder=pwd;
folder=strcat(currentFolder,'\spam-train');
testFiles=dir(fullfile(folder,'*.txt'));
TrainSpam=cell(1,length(testFiles));
for i=1:numel(testFiles)
  filename=fullfile(folder,testFiles(i).name);
  TrainSpam{i}=readFile(filename);
end
%Assinging train label of ones to Spam mails
train_labels3=ones(length(testFiles),1);
for i=n+1:numel(testFiles)+n
file_contents = TrainSpam{i-n};
[word_indices,freq ]  = processEmailMy(file_contents,dictionary);
temp=i*ones(length(freq),1);
tempM=[temp,freq];
M=[M;tempM];
end





%training the model
% store the number of training examples
numTrainDocs = i;

% store the dictionary size
numTokens = size(dictionary,1);
spmatrix = sparse(M(:,1), M(:,2), M(:,3), numTrainDocs, numTokens);
train_matrix = full(spmatrix);



% read the training labels 
train_labels1=(strcmp("spam",string(A{:,1})));

train_labels=[train_labels1;train_labels2;train_labels3];
% the i-th entry of train_labels now indicates whether document i is spam
% % 

% Find the indices for the spam and ham labels
spam_indices = find(train_labels);
ham_indices = find(train_labels == 0);

% Calculate probability of spam
prob_spam = length(spam_indices) / numTrainDocs;

% Sum the number of words in each email by summing along each row of
% train_matrix
email_lengths = sum(train_matrix, 2);
p=find(email_lengths == 0);

% Now find the total word counts of all the spam emails and ham emails
spam_wc = sum(email_lengths(spam_indices));
ham_wc = sum(email_lengths(ham_indices));

% Calculate the probability of the tokens in spam emails
prob_tokens_spam = (sum(train_matrix(spam_indices, :)) + 1) ./ ...
    (spam_wc + numTokens);
% Now the k-th entry of prob_tokens_spam represents phi_(k|y=1)

% Calculate the probability of the tokens in non-spam emails
prob_tokens_ham = (sum(train_matrix(ham_indices, :)) + 1)./ ...
    (ham_wc + numTokens);
% Now the k-th entry of prob_tokens_ham represents phi_(k|y=0)

toc;