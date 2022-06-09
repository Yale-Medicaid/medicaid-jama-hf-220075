local fname `1' // Name of input data to use
local sname `2' // Name of output save file for fstats

set matsize 11000
set linesize 250

import delimited `fname'

local outcomes any_cost ///
               all_cost ///
               all_cost_log ///
               all_cost_wins40 ///
               all_cost_wins125 ///
               medical_cost ///
               pharm_cost ///
			   asthma_any_condnl ///
			   diabetes_any_condnl ///
			   statins_any_condnl ///
			   antihypertensive_any_condnl ///
			   asthma_numclms_condnl ///
			   diabetes_numclms_condnl ///
			   statins_numclms_condnl ///
			   antihypertensive_numclms_condnl ///
			   asthma_mpm_condnl ///
			   diabetes_mpm_condnl ///
			   statins_mpm_condnl ///
			   antihypertensive_mpm_condnl ///
               pc_numdays /// 
               pc_any ///
               pharm_numclms /// 
               ednoadmit_numdays ///
               inpat_numdays ///
               spec_numdays ///
               ed_avoid_numdays ///
               lvc_uri ///
               tests_imaging_numdays ///
               capch_all ///
               awc_all ///
               ha1c ///
               adv ///
               chl_ad ///
               chl_ch ///
               chl_all ///
               ccs ///
               bcs ///
               ssd ///
               mpm_acearb ///
               mpm_diur ///
               amr /// 
               poud
               
quietly file open myfile using `sname', write replace
file write myfile "regression" _tab "outcome" _tab "variable" _tab "coeff" _tab "se" ///
                               _tab "pval" _tab "lb" _tab "ub" _n


// No Controls
foreach outcome of local outcomes{
	capture noisily {							   
	  reghdfe `outcome' i.recip_race_g, noabsorb vce(robust)
						 
	  local names : colfullnames e(b)
		foreach var of local names{
		  local t = _b[`var']/_se[`var']
		  local p = 2*ttail(e(df_r),abs(`t'))
		  local lb = (_b[`var'] - invttail(e(df_r), 0.025) * _se[`var'])
		  local ub = (_b[`var'] + invttail(e(df_r), 0.025) * _se[`var'])

		  file write myfile "raw" _tab "`outcome'" _tab ("`var'") ///
									   _tab (_b[`var']) _tab (_se[`var']) ///
									   _tab (`p') _tab (`lb') _tab (`ub') _n
		}            
	}
}


// Demographic
foreach outcome of local outcomes{
	capture noisily {
	  reghdfe `outcome' i.recip_race_g, ///
			   absorb(recip_age_g recip_gender_g recip_zip elig_cat state) ///
			   vce(robust)
						 
	  local names : colfullnames e(b)
		foreach var of local names{
		  local t = _b[`var']/_se[`var']
		  local p = 2*ttail(e(df_r),abs(`t'))
		  local lb = (_b[`var'] - invttail(e(df_r), 0.025) * _se[`var'])
		  local ub = (_b[`var'] + invttail(e(df_r), 0.025) * _se[`var'])


		  file write myfile "demo" _tab "`outcome'" _tab ("`var'") ///
									   _tab (_b[`var']) _tab (_se[`var']) ///
									   _tab (`p') _tab (`lb') _tab (`ub') _n
		}            
	}
}

// Demographic + health controls
foreach outcome of local outcomes{
	capture noisily {
	  reghdfe `outcome' i.recip_race_g hcc*, ///
			   absorb(recip_age_g recip_gender_g recip_zip elig_cat state) ///
			   vce(robust)
						 
	  local names : colfullnames e(b)
		foreach var of local names{
		  local t = _b[`var']/_se[`var']
		  local p = 2*ttail(e(df_r),abs(`t'))
		  local lb = (_b[`var'] - invttail(e(df_r), 0.025) * _se[`var'])
		  local ub = (_b[`var'] + invttail(e(df_r), 0.025) * _se[`var'])

		  file write myfile "demo_health" _tab "`outcome'" _tab ("`var'") ///
										  _tab (_b[`var']) _tab (_se[`var']) ///
										  _tab (`p') _tab (`lb') _tab (`ub') _n
		}            
	}
}

file close myfile


clear
exit
