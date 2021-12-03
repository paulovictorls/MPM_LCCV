%validation function
function  [cmx,cmu,cmv,eS,eK] = validationcalc(matpoints)

cmx = 0; cmu = 0; cmv = 0; cmm = 0; eS = 0; eK =0;
for i=1:length(matpoints)
    cmv = cmv + matpoints(i).velocity*matpoints(i).mass;
    cmx = cmx + matpoints(i).pos*matpoints(i).mass;
    cmu = cmu + matpoints(i).disp*matpoints(i).mass;
    cmm = cmm + matpoints(i).mass;
    eS = eS + .5*matpoints(i).volume*matpoints(i).stress*(matpoints(i).Fp-1);
    eK = eK + .5*matpoints(i).velocity^2*matpoints(i).mass;
end

cmx = cmx/cmm;
cmu = cmu/cmm;
cmv = cmv/cmm;

end