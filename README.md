## For MLP
For Electricity Normal and OTH :
```sh
sh scripts/MLP-LSTM/MLP/electricity/electricity_OTH.sh

sh scripts/MLP-LSTM/MLP/electricity/electricity.sh
```
For ETTh1 and ETTh2 :
```sh
!sh scripts/MLP-LSTM/MLP/etth_1_2/ETTh1.sh

!sh scripts/MLP-LSTM/MLP/etth_1_2/ETTh2.sh
```
For Elec_Custom 01 and 04 :
```sh
!sh scripts/MLP-LSTM/MLP/elec_custom/elec_custom_01.sh

!sh scripts/MLP-LSTM/MLP/elec_custom/elec_custom_04.sh
```  
## For V_Transformer
For Electricity Normal and OTH :
```sh
sh scripts/V_Transformer/electricity/V_T_Electricity.sh

sh scripts/V_Transformer/electricity/V_T_Electricity_OTH.sh

sh scripts/V_Transformer/electricity/V_T_Elec_Continue.sh

sh scripts/V_Transformer/electricity/V_T_Elec_Prediction.sh

sh scripts/V_Transformer/electricity/V_T_Elec_Freeze.sh
```
For Elec_Custom 01 and 04 :
```sh
sh scripts/V_Transformer/elec_custom/V_T_Elec_Custom01.sh

sh scripts/V_Transformer/elec_custom/V_T_Elec_Custom04.sh

sh scripts/V_Transformer/elec_custom/V_T_Elec_Custom_Continue.sh

sh scripts/V_Transformer/elec_custom/V_T_Elec_Custom_Prediction.sh

sh scripts/V_Transformer/elec_custom/V_T_Elec_Custom_Freeze.sh
```
For ETTh1 and ETTh2 :
```sh
sh scripts/V_Transformer/etth_1_2/V_T_ETTh1.sh

sh scripts/V_Transformer/etth_1_2/V_T_ETTh2.sh

sh scripts/V_Transformer/etth_1_2/V_T_etth_Continue.sh

sh scripts/V_Transformer/etth_1_2/V_T_etth_Prediction.sh

sh scripts/V_Transformer/etth_1_2/V_T_etth_Freeze.sh
```

### For Conformer on Elec_Custom (EXPLAINED)
Firstly, we'll train with :
```sh
sh scripts/Conformer/elec_custom/Conformer.sh
```
After that, we have to manually save a copy of the `checkpoints_SIRN/init` folder (somewhere on the computer) and then launch :
```sh
sh scripts/Conformer/elec_custom/Conformer_Continue.sh
```

After, also save manually the content of `checkpoints_SIRN/init` somewhere on the computer and replace the content of this folder with that which was firstly saved. We have to launch then :
```sh
sh scripts/Conformer/elec_custom/Conformer_Elec_Cust_SIRN.sh
```
Finally, we will take again our first saved folder and put in `checkpoints_SIRN/init`. Then, type :
```sh
sh scripts/Conformer/elec_custom/Conformer_Prediction_Elec_Custom.sh
```
After each operation, we have to take a copy of `Logs` folder.

## For Conformer
For Electricity Normal and OTH :
```sh
sh scripts/Conformer/electricity/Conformer.sh

sh scripts/Conformer/electricity/ConformerOthers.sh

sh scripts/Conformer/electricity/Conformer_Prediction_Elec1.sh

sh scripts/Conformer/electricity/Conformer_Elec1_SIRN.sh

sh scripts/Conformer/electricity/Conformer_Continue.sh
```
For Elec_Custom 01 and 04 :
```sh
sh scripts/Conformer/elec_custom/Conformer.sh

sh scripts/Conformer/elec_custom/Conformer_Continue.sh

sh scripts/Conformer/elec_custom/Conformer_Prediction_Elec_Custom.sh

sh scripts/Conformer/elec_custom/Conformer_Elec_Cust_SIRN.sh
```
For ETTh1 and ETTh2 :
```sh
sh scripts/Conformer/etth_1_2/Conformer.sh

sh scripts/Conformer/etth_1_2/Conformer_Continue.sh

sh scripts/Conformer/etth_1_2/Conformer_Prediction_ETTh12.sh

sh scripts/Conformer/etth_1_2/Conformer_ETTh_1_2_SIRN.sh
```

## EXEMPLES
To train *NLinear* and *DLinear* on **ETTh1, ETTm1, electricity** and **weather** datasets, use :  
```sh
sh scripts/Linears/etth1UNI.sh

sh scripts/Linears/ettm1UNI.sh

sh scripts/Linears/weatherUNI.sh

sh scripts/Linears/electricityUNI.sh
```

To train all datas on **MLP** and **LSTM** models, use :
```sh
sh scripts/MLP-LSTM/MLP.sh

sh scripts/MLP-LSTM/LSTM.sh

```

To train **vanilla transformer** on **all datasets**, use :  
```sh
sh scripts/V_Transformer/V_Transformer.sh
```

To train them all on **Conformer**, use :
```sh
sh scripts/Conformer/Conformer.sh
```

After and only after `sh scripts/Conformer/Conformer.sh`, you can use the obtained models to train `Conformer` by frozen `SIRN` module. For that, use :
```sh
sh scripts/Conformer/Conformer_SIRN.sh
```

To use a model trained on one dataset (_ETTh1_ by default) to predict another dataset, use :
```sh
sh scripts/Conformer/Conformer_Cross_Prediction.sh
```  
This script is also usable to complete a cross training with reduced datas. To do that, it will be necessary to turn `with_reduced_train` parameter to `1` (True) in *Conformer_Cross_Prediction.sh* file.

We can also train models with reduced datas, using :
```sh
sh scripts/Conformer/Conformer_Reduced.sh
```  
But, in order to do that, you have to put trained models in an appropriate folder (checkpoint folder) or firstly train models with `sh scripts/Conformer/Conformer.sh` by reducing __num_epochs__ in *conformer.sh* file.

## For electricity_data (New procedure)
```sh
sh scripts/Conformer/electricity/Conformer.sh

sh scripts/Conformer/electricity/ConformerOthers.sh

sh scripts/Conformer/electricity/Conformer_Continue.sh

sh scripts/Conformer/electricity/Conformer_Prediction_Elec1.sh

sh scripts/Conformer/electricity/Conformer_Elec1_SIRN.sh
```

But, as said previously, be sure to put init models in the right place (folder `checkpoints_SIRN/init`) before lunching the 3 last scripts.

## To be explained (later)
```sh
sh scripts/Conformer/etth_1_2/Conformer_Prediction_ETTh12.sh

sh scripts/Conformer/elec_custom/Conformer_Prediction_Elec_Custom.sh

sh scripts/Conformer/etth_1_2/Conformer_ETTh_1_2_SIRN.sh

sh scripts/Conformer/elec_custom/Conformer_Elec_Cust_SIRN.sh

sh scripts/Conformer/etth_1_2/Conformer_Continue.sh

sh scripts/Conformer/elec_custom/Conformer_Continue.sh

sh scripts/Conformer/elec_custom/Conformer.sh
```

The results will be in **logs** directory.