## EXEMPLES
To train *NLinear* and *DLinear* on **ETTh1** dataset, use :  
```sh
sh scripts/EXP-LongForecasting/Linear/univariate/etth1UNI.sh
```
To train *NLinear* and *DLinear* on **ETTm1** dataset, use :  
```sh
sh scripts/EXP-LongForecasting/Linear/univariate/ettm1UNI.sh
```
To train *NLinear* and *DLinear* on **weather** dataset, use :  
```sh
sh scripts/EXP-LongForecasting/Linear/univariate/weatherUNI.sh
```
To train *NLinear* and *DLinear* on **electricity** dataset, use :  
```sh
sh scripts/EXP-LongForecasting/Linear/univariate/electricityUNI.sh
```
To train *vanilla transformer* on **all datasets**, use :  
```sh
sh scripts/EXP-LookBackWindow/Formers_LookBackWindow.sh
```
The results will be in **logs** directory.
## LTSF-Linear
### LTSF-Linear family
LTSF-Linear is a set of linear models. 
- Linear: It is just a one-layer linear model, but it outperforms Transformers.
- NLinear: **To boost the performance of Linear when there is a distribution shift in the dataset**, NLinear first subtracts the input by the last value of the sequence. Then, the input goes through a linear layer, and the subtracted part is added back before making the final prediction. The subtraction and addition in NLinear are a simple normalization for the input sequence.
- DLinear: It is a combination of a Decomposition scheme used in Autoformer and FEDformer with linear layers. It first decomposes a raw data input into a trend component by a moving average kernel and a remainder (seasonal) component. Then, two one-layer linear layers are applied to each component and we sum up the two features to get the final prediction. By explicitly handling trend, **DLinear enhances the performance of a vanilla linear when there is a clear trend in the data.** 

Although LTSF-Linear is simple, it has some compelling characteristics:
- An O(1) maximum signal traversing path length: The shorter the path, the better the dependencies are captured, making LTSF-Linear capable of capturing both short-range and long-range temporal relations.
- High-efficiency: As each branch has only one linear layer, it costs much lower memory and fewer parameters and has a faster inference speed than existing Transformers.
- Interpretability: After training, we can visualize weights to have some insights on the predicted values.
- Easy-to-use: LTSF-Linear can be obtained easily without tuning model hyper-parameters.

## Getting Started
### Environment Requirements

First, please make sure you have installed Conda. Then, our environment can be installed by:
```
conda create -n LTSF_Linear python=3.6.9
conda activate LTSF_Linear
pip install -r requirements.txt
```

### Data Preparation

You can obtain all the nine benchmarks from [Google Drive](https://drive.google.com/drive/folders/1ZOYpTUa82_jCcxIdTmyr0LXQfvaM9vIy) provided in Autoformer. All the datasets are well pre-processed and can be used easily.

```
mkdir dataset
```
**Please put them in the `./dataset` directory**
## Citing

If you find this repository useful for your work, please consider citing it as follows:

```bibtex
@inproceedings{Zeng2022AreTE,
  title={Are Transformers Effective for Time Series Forecasting?},
  author={Ailing Zeng and Muxi Chen and Lei Zhang and Qiang Xu},
  journal={Proceedings of the AAAI Conference on Artificial Intelligence},
  year={2023}
}
```

Please remember to cite all the datasets and compared methods if you use them in your experiments.
