
tic;
clear all;
clc;
tic;
%Load the workspace obtained form training the model
load('trainedWorkSpace.mat');
% Extracting features from Ham mail Folder
folder = 'C:\Users\MILAN CHATTERJEE\Downloads\Naive Bayes Spam\nonspam-test';
testFiles=dir(fullfile(folder,'*.txt'));
TestHam=cell(1,length(testFiles));
for i=1:numel(testFiles)
  filename=fullfile(folder,testFiles(i).name);
  %TestHam{i}=readFile(filename);
  fid = fopen(filename);
% Read all lines & collect in cell array
 txt = textscan(fid,'%s','delimiter','\n');
 
 a=char(txt{1,1});
 b=string(a);
 c=strjoin(b(:,1));
 d=char(c);
  TestHam{i}=regexprep(d,'\s+',' ');
  fclose(fid);
end

N=[];
for i=1:numel(testFiles)
file_contents = TestHam{i};
[word_indices,freq ]  = processEmailMy(file_contents,dictionary);
temp=i*ones(length(freq),1);
tempN=[temp,freq];
N=[N;tempN];
end
length1=numel(testFiles);

% Extracting features from Ham mail Folder
folder = 'C:\Users\MILAN CHATTERJEE\Downloads\Naive Bayes Spam\spam-test';
testFiles=dir(fullfile(folder,'*.txt'));
TestSpam=cell(1,length(testFiles));
for i=1:numel(testFiles)
  filename=fullfile(folder,testFiles(i).name);
  %TestSpam{i}=readFile(filename);
  % Read all lines & collect in cell array
  fid = fopen(filename);
 txt = textscan(fid,'%s','delimiter','\n');
 
 a=char(txt{1,1});
 b=string(a);
 c=strjoin(b(:,1));
 d=char(c);
  TestSpam{i}=regexprep(d,'\s+',' ');
  fclose(fid);
end


for i=1+length1:numel(testFiles)+length1
file_contents = TestSpam{i-length1};
[word_indices,freq ]  = processEmailMy(file_contents,dictionary);
temp=i*ones(length(freq),1);
tempN=[temp,freq];
N=[N;tempN];
end


% store the dictionary size
numTokens = length(dictionary);
spmatrix = sparse(N(:,1), N(:,2), N(:,3), length1+numel(testFiles), numTokens);
test_matrix = full(spmatrix);



% Store the number of test documents and the size of the dictionary
numTestDocs = size(test_matrix, 1);
numTokens = size(test_matrix, 2);


% The output vector is a vector that will store the spam/ham prediction
% for the documents in our test set.
output = zeros(numTestDocs, 1);

%testing which is higher log_a for spam and log_b for ham
log_a = test_matrix*(log(prob_tokens_spam))' + log(prob_spam);
log_b = test_matrix*(log(prob_tokens_ham))'+ log(1 - prob_spam);  
output = log_a > log_b;


% Read the correct labels of the test set
test_labels = dlmread('test-labels.txt');

% Compute the error on the test set
% A document is misclassified if it's predicted label is different from
% the actual label, so count the number of 1's from an exclusive "or"
numdocs_wrong = sum(xor(output, test_labels))

%Print out error statistics on the test set
fraction_wrong = numdocs_wrong/numTestDocs

toc;
