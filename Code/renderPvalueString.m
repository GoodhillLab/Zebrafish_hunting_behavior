 function pstring=renderPvalueString(pval)
    if pval<0.01
        pstring=['p =10^{',num2str(ceil(log10(pval))),'}'];
    elseif pval>0.04
        pstring=['p =',sprintf('%.2f',pval)];
    else if pval>=0.015
            pstring=['p =',sprintf('%.2f',pval)];
    elseif pval<0.015
        pstring=['p =10^{',num2str(ceil(log10(pval))-1),'}'];
    end
 end
