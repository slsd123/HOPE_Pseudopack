% Compute the local and L2 error between two functions
function [err_loc err_L2] = error_analysis(ORBF, Empirical)

err_loc = ORBF;

for i = 1:length(ORBF(:,1))
    for j = 1:length(ORBF(1,:))
        err_loc(i,j) = abs(ORBF(i,j) - Empirical(i,j));
    end
end
err_L2 = norm(err_loc);