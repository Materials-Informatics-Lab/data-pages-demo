function json = minifyjson(json)
% Remove new lines and spaces in json stream from json lab

characters = {'\n','\t'};

for ii = 1 : numel( characters )
    json = regexprep( json, characters{ii}, '' );
end