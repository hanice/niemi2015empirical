single_gene_analysis = function(counts) {
  diverge = TRUE
  attempt = 1
  
  
  while (diverge) {
    r = sampling(model, 
                 data = c(list(S       = length(counts), 
                               count   = as.numeric(counts),
                               variety = as.numeric(factor(gsub("_[0-9]{1,2}", "", colnames(counts)), levels=c("B73","Mo17","B73xMo17")))),
                          hyperparameters),
                 pars = c("phi","alpha","delta","psi","LPH","HPH"),
                 iter = 2000*2^(attempt-1),
                 thin = 2^(attempt-1))
    
    # Check PSRF for (lack of) convergence
    s = summary(r)$summary
    diverge = any(s[,"n_eff"] < 1000)
    attempt = attempt + 1
  }
  
  alpha_hat = s[rownames(s) == "alpha","mean"]
  delta_hat = s[rownames(s) == "delta","mean"]
  effectiveSize = 
    (delta_hat >  abs(alpha_hat))*(delta_hat - abs(alpha_hat)) + 
    (delta_hat < -abs(alpha_hat))*(delta_hat + abs(alpha_hat))  
    
  
  data.frame(
    phi      = s[rownames(s) == "phi",  "mean"],
    alpha    = s[rownames(s) == "alpha","mean"],
    delta    = s[rownames(s) == "delta","mean"],
    psi      = s[rownames(s) == "psi",  "mean"],
    prob_LPH = s[rownames(s) == "LPH",  "mean"],
    prob_HPH = s[rownames(s) == "HPH",  "mean"],
    effectiveSize = effectiveSize)
}
