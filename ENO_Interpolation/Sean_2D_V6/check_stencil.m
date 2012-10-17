function [ Top Bottom] = check_stencil(i0, j0,...
    Top, Bottom, c2, c2b, Order)

% if (Left(i0+1, j0) ~= Right(i0+1, j0) || Left(i0-1, j0) ~= Right(i0-1, j0))
%     sumr = 0;
%     suml = 0;
%     for n=1:Order
%         for m=1:Order
%             suml = suml+abs(c1 (i0+n-1, j0+m-1, Order));
%             sumr = sumr+abs(c1r(i0+n-1, j0+m-1, Order));
%         end
%     end
%     if suml > sumr
%         Left(i0, j0) = Right(i0, j0)-Order+1;
%     elseif sumr > suml
%         Right(i0, j0) = Left(i0, j0)+Order-1;
%     end
% end

if (Top(i0, j0-1) ~= Bottom(i0, j0-1) || Top(i0, j0+1) ~= Bottom(i0, j0+1))
    sumt = 0;
    sumb = 0;
    for n=1:Order
        for m=1:Order
            sumb = sumb+abs(c2 (i0+n-1, j0+m-1, Order));
            sumt = sumt+abs(c2b(i0+n-1, j0+m-1, Order));
        end
    end
    if sumb > sumt
        Bottom(i0, j0) = Top(i0, j0)-Order+1;
    elseif sumt > sumb
        Top(i0, j0) = Bottom(i0, j0)+Order-1;
    end
end