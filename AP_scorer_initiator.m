p = uipickfiles;

for i = 1:length(p)
    subfolder = p{i};
    cd(subfolder)
    AP_manual_scorer
end
PluriIQ
