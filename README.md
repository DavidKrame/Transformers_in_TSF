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
sh scripts/Conformer/Conformer_Cross_Training.sh
```  

We can also train models with reduced datas, using :
```sh
sh scripts/Conformer/Conformer_Reduced.sh
```  
But, in order to do that, you have to put trained models in an appropriate folder (checkpoint folder) or firstly train models with `sh scripts/Conformer/Conformer.sh` by reducing __num_epochs__ in *conformer.sh* file.


The results will be in **logs** directory.