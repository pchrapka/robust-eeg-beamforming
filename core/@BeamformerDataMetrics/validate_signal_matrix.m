function result = validate_signal_matrix(A)

if ~ismatrix(A)
    result = false;
% elseif (size(A,1) > size(A,2))
%     % matrix should be channels x samples
%     error('samples should be > channels');
else
    result = true;
end

end