# Question 'PyMC3: Different predictions for identical inputs' ----
# (available online: https://stackoverflow.com/questions/59288938/pymc3-different-predictions-for-identical-inputs)

import seaborn as sns
import pymc3 as pm
import pandas as pd
import numpy as np


### . training ----

dat = sns.load_dataset('iris')
trn = dat.iloc[:-1]

with pm.Model() as model:
    s_data = pm.Data('s_data', trn['petal_width'])
    outcome = pm.glm.GLM(x = s_data, y = trn['petal_length'], labels = 'petal_width')
    trace = pm.sample(500, cores = 1, random_seed = 1899)


### . testing ----
    
tst = dat.iloc[-1:]
tst = pd.concat([tst, tst], axis = 0, ignore_index = True)

with model:
    pm.set_data({'s_data': tst['petal_width']})
    ppc = pm.sample_posterior_predictive(trace, random_seed = 1900)

np.mean(ppc['y'], axis = 0)
