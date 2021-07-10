clear all;
clc;
%Load the workspace obtained form training the model
load('trainedWorkSpace.mat');
%store the address of current directory
currentFolder=pwd;
%Get address of the folder named test
folder=strcat(currentFolder,'\test');

%Read test email data set
testFiles=dir(fullfile(folder,'*.txt'));
Test=cell(1,length(testFiles));
for i=1:numel(testFiles)
  filename=fullfile(folder,testFiles(i).name);
 % Test{i}=readFile(filename);
  fid = fopen(filename);
  if fid
    file_contents = fscanf(fid, '%c', inf);
    fclose(fid);
  else
    file_contents = '';
    fprintf('Unable to open %s\n', filename);
  end
  Test{i}=file_contents;
  end
%Extract features from test email data set
N=[];
for i=1:numel(testFiles)
file_contents = Test{i};
[word_indices,freq ]  = processEmailMy(file_contents,dictionary);
temp=i*ones(length(freq),1);
tempN=[temp,freq];
N=[N;tempN];
end

% conut numbr of tokens
numTokens = length(dictionary);

%Create the test matrix in desired format
spmatrix = sparse(N(:,1), N(:,2), N(:,3), numel(testFiles), numTokens);
test_matrix = full(spmatrix);

% Store the number of test documents and the size of the dictionary
numTestDocs = size(test_matrix, 1);
numTokens = size(test_matrix, 2);


% The output vector is a vector that will store the spam/ham prediction
% for the documents in our test set.
output = zeros(numTestDocs, 1);
%testing which is higher log_a for spam and log_b for ham
%output vector contains 1 for the spam email and 0 for the ham emails
log_a = test_matrix*(log(prob_tokens_spam))' + log(prob_spam);
log_b = test_matrix*(log(prob_tokens_ham))'+ log(1 - prob_spam);  
output = log_a > log_b
fid=fopen('output.txt','wt');
fprintf(fid, '%d\n', output);
fclose(fid);




