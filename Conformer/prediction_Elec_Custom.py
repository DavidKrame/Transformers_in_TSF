#!/usr/bin/env python
# -*-encoding=utf8 -*-
import argparse
import os
import torch
import numpy as np
import random
import time
from exp.exp_Model_Elec1 import Exp_Model

fix_seed = 2022
random.seed(fix_seed)
torch.manual_seed(fix_seed)
np.random.seed(fix_seed)

parser = argparse.ArgumentParser(
    description="TRANS_LEARN : Conformer for Very Long Sequences Forecasting"
)

parser.add_argument(
    "--model",
    type=str,
    default="Model",
    help="model of experiment, options: [informer, informerstack, informerlight(TBD)]",
)
parser.add_argument("--data", type=str, default="elec", help="data")
parser.add_argument(
    "--root_path", type=str, default="./datataset", help="root path of the data file"
)
parser.add_argument(
    "--data_path", type=str, default="ETTh1.csv", help="data file"
)  # Change the file name if necessary
parser.add_argument(
    "--features",
    type=str,
    default="S",
    help="forecasting task, options:[M, S, MS]; M:multivariate predict multivariate, S:univariate predict univariate, MS:multivariate predict univariate",
)
parser.add_argument(
    "--target", type=str, default="OT", help="target feature in S or MS task"
)
parser.add_argument(
    "--freq",
    type=str,
    default="t",
    help="freq for time features encoding, options:[s:secondly, t:minutely, h:hourly, d:daily, b:business days, w:weekly, m:monthly], you can also use more detailed freq like 15min or 3h",
)
parser.add_argument(
    "--checkpoints",
    type=str,
    default="./checkpoints/",
    help="location of model checkpoints",
)

parser.add_argument(
    "--seq_len", type=int, default=96, help="input sequence length of Informer encoder"
)
parser.add_argument(
    "--label_len", type=int, default=48, help="start token length of Informer decoder"
)
parser.add_argument(
    "--pred_len", type=int, default=96, help="prediction sequence length"
)
parser.add_argument("--step_len", type=int, default=25, help="step length")

parser.add_argument("--enc_in", type=int, default=21, help="encoder input size")
parser.add_argument("--dec_in", type=int, default=21, help="decoder input size")
parser.add_argument("--c_out", type=int, default=21, help="output size")
parser.add_argument("--d_model", type=int, default=512, help="dimension of model")
parser.add_argument("--n_heads", type=int, default=8, help="num of heads")
parser.add_argument("--e_layers", type=int, default=2, help="num of encoder layers")
parser.add_argument("--d_layers", type=int, default=1, help="num of decoder layers")
parser.add_argument("--normal_layers", type=int, default=2, help="num of normal layers")
parser.add_argument(
    "--enc_lstm", type=int, default=1, help="num of encoder lstm layers"
)
parser.add_argument(
    "--dec_lstm", type=int, default=2, help="num of decoder lstm layers"
)
parser.add_argument(
    "--weight", type=float, default=0.2, help="num of decoder lstm layers"
)
parser.add_argument("--window", type=float, default=2, help="size of sliding window")

parser.add_argument("--d_ff", type=int, default=2048, help="dimension of fcn")
parser.add_argument("--padding", type=int, default=0, help="padding type")
parser.add_argument(
    "--distil",
    action="store_false",
    help="whether to use distilling in encoder, using this argument means not using distilling",
    default=False,
)
parser.add_argument("--dropout", type=float, default=0.05, help="dropout")
parser.add_argument(
    "--attn",
    type=str,
    default="long",
    help="attention used in encoder, options:[long, full]",
)
parser.add_argument(
    "--embed",
    type=str,
    default="timeF",
    help="time features encoding, options:[timeF, fixed, learned]",
)
parser.add_argument("--activation", type=str, default="gelu", help="activation")

parser.add_argument(
    "--do_test",
    type=bool,
    default=True,
    help="whether to produce test data of validation",
)
parser.add_argument(
    "--do_predict", action="store_true", help="whether to predict unseen future data"
)
parser.add_argument(
    "--mix",
    action="store_false",
    help="use mix attention in generative decoder",
    default=True,
)
parser.add_argument("--cols", type=str, nargs="+", help="file list")
parser.add_argument(
    "--num_workers", type=int, default=0, help="data loader num workers"
)
parser.add_argument("--itr", type=int, default=1, help="experiments times")
parser.add_argument("--train_epochs", type=int, default=10, help="train epochs")
parser.add_argument(
    "--batch_size", type=int, default=32, help="batch size of train input data"
)
parser.add_argument("--patience", type=int, default=10, help="early stopping patience")
parser.add_argument(
    "--learning_rate", type=float, default=0.0001, help="optimizer learning rate"
)
parser.add_argument("--des", type=str, default="test", help="exp description")
parser.add_argument("--loss", type=str, default="mse", help="loss function")
parser.add_argument("--lradj", type=str, default="type1", help="adjust learning rate")
parser.add_argument(
    "--use_amp",
    action="store_true",
    help="use automatic mixed precision training",
    default=False,
)
parser.add_argument(
    "--inverse", action="store_true", help="inverse output data", default=False
)

parser.add_argument("--use_gpu", type=bool, default=True, help="use gpu")
parser.add_argument("--gpu", type=int, default=0, help="gpu")
parser.add_argument(
    "--use_multi_gpu", action="store_true", help="use multiple gpus", default=False
)
parser.add_argument(
    "--devices", type=str, default="0,1,2,3", help="device ids of multile gpus"
)

args = parser.parse_args()

print("Args: ")
print(args)
print("dimension")
args.use_gpu = True if torch.cuda.is_available() and args.use_gpu else False

if args.use_gpu and args.use_multi_gpu:
    args.devices = args.devices.replace(" ", "")
    device_ids = args.devices.split(",")
    args.device_ids = [int(id_) for id_ in device_ids]
    args.gpu = args.device_ids[0]

data_parser = {
    "ETTh1": {
        "data": "ETTh1.csv",
        "T": "OT",
        "M": [7, 7, 7],
        "S": [1, 1, 1],
        "MS": [7, 7, 1],
        "freq": "h",
    },
    "ETTh2": {
        "data": "ETTh2.csv",
        "T": "OT",
        "M": [7, 7, 7],
        "S": [1, 1, 1],
        "MS": [7, 7, 1],
        "freq": "h",
    },
    "ETTm1": {
        "data": "ETTm1.csv",
        "T": "OT",
        "M": [7, 7, 7],
        "S": [1, 1, 1],
        "MS": [7, 7, 1],
        "freq": "t",
    },
    "ETTm2": {
        "data": "ETTm2.csv",
        "T": "OT",
        "M": [7, 7, 7],
        "S": [1, 1, 1],
        "MS": [7, 7, 1],
        "freq": "t",
    },
    "WTH": {
        "data": "weather.csv",
        "T": "OT",
        "M": [21, 21, 21],
        "S": [1, 1, 1],
        "MS": [21, 21, 1],
        "freq": "h",
    },
    "ECL": {
        "data": "electricity.csv",
        "T": "OT",
        "M": [321, 321, 321],
        "S": [1, 1, 1],
        "MS": [321, 321, 1],
        "freq": "t",
    },
    "TRAF": {
        "data": "traffic.csv",
        "T": "tensor862",
        "M": [861, 861, 861],
        "S": [1, 1, 1],
        "MS": [861, 861, 1],
        "freq": "h",
    },
    "EXCH": {
        "data": "exchange_rate.csv",
        "T": "county8",
        "M": [8, 8, 8],
        "S": [1, 1, 1],
        "MS": [8, 8, 1],
    },
    "elec": {
        "T": "OT",
        "M": [7, 7, 7],
        "S": [1, 1, 1],
        "MS": [7, 7, 1],
        "freq": "t",
    },
    "air": {
        "T": "target",
        "M": [6, 6, 6],
        "S": [1, 1, 1],
        "MS": [7, 7, 1],
        "freq": "t",
    },
}
if args.data in data_parser.keys():
    data_info = data_parser[args.data]
    args.target = data_info["T"]
    args.enc_in, args.dec_in, args.c_out = data_info[args.features]

args.detail_freq = args.freq
args.freq = args.freq[-1:]

print("Args in experiment:")
print(args)
Exp = Exp_Model

pred_length = [96, 192, 384, 768]
for i in range(len(pred_length)):
    time_begin = time.time()
    all_mse = []
    all_mae = []
    data_pth = str(args.data_path)

    data_pth = data_pth[:-5]
    data_pth = data_pth + "1.csv"

    args.pred_len = pred_length[i]
    for ii in range(args.itr):
        # setting record of experiments
        setting = "{}_{}_ft{}_sl{}_ll{}_pl{}_step{}_dm{}_nh{}_el{}_dl{}_{}".format(
            args.model,
            data_pth,
            args.features,
            args.seq_len,
            args.label_len,
            args.pred_len,
            args.step_len,
            args.d_model,
            args.n_heads,
            args.e_layers,
            args.d_layers,
            ii,
        )

        exp = Exp(args, setting)  # set experiments

        print(">>>>>>>testing : {}<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<".format(setting))
        mae, mse = exp.test(setting)
        all_mae.append(mae)
        all_mse.append(mse)
        # if args.do_predict:
        #    print('>>>>>>>predicting : {}<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<'.format(setting))
        #    exp.predict(setting, True)
        torch.cuda.empty_cache()
    print("MEANs :")
    print(np.mean(np.array(all_mse)), np.mean(np.array(all_mae)))
    print("STDs :")
    print(np.std(np.array(all_mse)), np.std(np.array(all_mae)))
    time_end = time.time()
    total_time = time_end - time_begin
    print("TOTAL_TIME : {}".format(total_time))
