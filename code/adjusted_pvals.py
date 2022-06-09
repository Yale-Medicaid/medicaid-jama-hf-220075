import pandas as pd
import numpy as np
import statsmodels.stats.multitest as multitest


def adjusted_pvals_age_split():
    """
    Adjust p-values within domain, for the fully specified regressions (demographics, health status and previous providers fixed effects
    """

    output_p = FS().analysis_p+'paper1_adjusted_pvals_age_split/output/'
    data_p = FS().analysis_p+'paper1_regressions_yearly_with_attr_prov_age_split/output/'

    for age in ['adult', 'child']:
        df = pd.read_csv(data_p+f'paper1_main_results_with_prov_{age}.csv', sep='\t')

        df = df[df.variable.isin(['_cons', '1.recip_race_g'])]
        df['variable'] = df['variable'].map({'_cons': 'White', '1.recip_race_g': 'Black'})
        df['pval'] = pd.to_numeric(df.pval, errors='coerce')
        df = df[df.variable.eq('Black')]

        df = df.set_index('outcome')

        domains = [('cost', ['all_cost', 'medical_cost', 'pharm_cost', 'any_cost']),
                   ('util', ['pc_numdays', 'pc_any', 'spec_numdays', 'inpat_numdays',
                             'tests_imaging_numdays', 'ednoadmit_numdays']),
                   ('sel_drugs', ['pharm_numclms', 'antihypertensive_numclms_condnl', 'statins_numclms_condnl',
                                  'diabetes_numclms_condnl', 'asthma_numclms_condnl']),
                   ('prim_prev', ['awc_all', 'bcs', 'ccs', 'chl_all']),
                   ('acute', ['ha1c', 'ssd', 'poud', 'amr', 'ed_avoid_numdays']),
                   ('test', ['amr', 'ed_avoid_numdays', 'awc_all', 'chl_all'])
                  ]

        l = []
        for label, outcomes in domains:
            outcomes = df.index.intersection(outcomes)
            if not outcomes.empty:
                res = mult,itest.multipletests(df.loc[outcomes, 'pval'], method='fdr_bh')[1]
                l.append(pd.Series(res, index=outcomes))
        padj = pd.concat(l).to_frame('pval_adj')

        padj['pval_adj_fmt'] = padj['pval_adj'].apply(round_pval)
        padj.to_csv(output_p+f'adjusted_pvals_{age}.csv')
