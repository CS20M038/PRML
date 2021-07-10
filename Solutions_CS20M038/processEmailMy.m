function [word_indices,freq ] = processEmailMy(email_contents,dictionary)

word_indices = [];


% Lower case
email_contents = lower(email_contents);

% Strip all HTML
% Looks for any expression that starts with < and ends with > and replace
% and does not have any < or > in the tag it with a space
email_contents = regexprep(email_contents, '<[^<>]+>', ' ');

% Handle Numbers
% Look for one or more characters between 0-9
email_contents = regexprep(email_contents, '[0-9]+', 'number');

% Handle URLS
% Look for strings starting with http:// or https://
email_contents = regexprep(email_contents, ...
                           '(http|https)://[^\s]*', 'httpaddr');

% Handle Email Addresses
% Look for strings with @ in the middle
email_contents = regexprep(email_contents, '[^\s]+@[^\s]+', 'emailaddr');

% Handle $ sign
email_contents = regexprep(email_contents, '[$]+', 'dollar');


% ========================== Tokenize Email ===========================


% Process file
l = 0;
B=[]; present_words=[];idx=[];
while ~isempty(email_contents)

    % Tokenize and also get rid of any punctuation
    [str, email_contents] = ...
       strtok(email_contents, ...
              [' @$/#.-:&*+=[]?!(){},''">_<;%' char(10) char(13)]);
   
    % Remove any non alphanumeric characters
    str = regexprep(str, '[^a-zA-Z0-9]', '');

    % Stem the word 
    try str = porterStemmer(strtrim(str)); 
    catch str = ''; continue;
    end;

    % Skip the word if it is too short
    if length(str) < 1
       continue;
    end
    B=[B;string(str)];
    
   l = l + length(str) + 1;

end

[uniqueB, ~, J]=unique(B) ;
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
