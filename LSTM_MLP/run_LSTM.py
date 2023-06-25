import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import torch
import torch.nn as nn
import torch.optim as optim
import torch.utils.data as data
import argparse
import os
import random
from torch.utils.data import Dataset, DataLoader
from sklearn.preprocessing import StandardScaler
from math import sqrt

fix_seed = 2021
random.seed(fix_seed)
torch.manual_seed(fix_seed)
np.random.seed(fix_seed)


parser = argparse.ArgumentParser(
    description='LSTM for Time series forecasting')

# Basics configurations
parser.add_argument('--is_training', type=int,
                    required=True, default=1, help='status')
parser.add_argument('--model_id', type=str, required=True,
                    default='test', help='model id')

# Dataloader

parser.add_argument('--root_path', type=str,
                    default='./dataset/', help='root path of the data file')
parser.add_argument('--data_path', type=str,
                    default='ETTh1.csv', help='data file')
parser.add_argument('--target', type=str, default='OT',
                    required=True, help='Cibled coloumn')
parser.add_argument('--checkpoints', type=str,
                    default='./checkpoints/', help='location of model checkpoints')

# Forecasting parameters
parser.add_argument('--seq_len', type=int, default=96,
                    help='input sequence length')
parser.add_argument('--pred_len', type=int, default=96,
                    help='prediction sequence length')

# Model parameters
parser.add_argument('--num_neurons', type=int, default=1000,
                    help='number of neurons in hidden layer')
parser.add_argument('--num_epochs', type=int, default=10,
                    help='number of epochs')
parser.add_argument('--learning_rate', type=float,
                    default=0.001, help='optimizer learning rate')
parser.add_argument('--batch_size', type=int, default=4,
                    help='batch size of train input data')
parser.add_argument("--num_layers", type=int, default=1,
                    help="Number of layers in LSTM")
parser.add_argument('--patience', type=int, default=5,
                    help='early stopping patience')

# GPU
parser.add_argument('--use_gpu', type=bool, default=True, help='use gpu')
parser.add_argument('--gpu', type=int, default=0, help='gpu')
parser.add_argument('--use_multi_gpu', action='store_true',
                    help='use multiple gpus', default=False)
parser.add_argument('--devices', type=str, default='0,1,2,3',
                    help='device ids of multile gpus')
parser.add_argument('--test_flop', action='store_true',
                    default=False, help='See utils/tools for usage')

args = parser.parse_args()

args.use_gpu = True if torch.cuda.is_available() and args.use_gpu else False

if args.use_gpu and args.use_multi_gpu:
    args.devices = args.devices.replace(' ', '')
    device_ids = args.devices.split(',')
    args.device_ids = [int(id_) for id_ in device_ids]
    args.gpu = args.device_ids[0]
elif (torch.cuda.is_available()) and not (args.use_multi_gpu):
    device = "cuda:0"
    args.gpu = torch.device(device)
else:
    device = "cpu"
    args.gpu = torch.device(device)

device = "cpu"
args.gpu = torch.device(device)

print("WORK USING {}".format(args.gpu))

print('Args :')
print(args)


class MyDatas(Dataset):
    def __init__(self, X, y):
        # convert into PyTorch tensors and remember them
        self.X = X
        self.y = y

    def __len__(self):
        # this should return the size of the dataset
        return len(self.X)

    def __getitem__(self, idx):
        # this should return one sample from the dataset
        features = self.X[idx]
        target = self.y[idx]
        return features, target


def create_dataset(dataset, lookback, lookforward):
    """Transform a time series into a prediction dataset

    Args:
        dataset: A numpy array of time series, first dimension is the time steps
        lookback: Size of back window used for prediction
        lookforward : Size of windows for prediction
    """
    X, y = [], []
    for i in range(len(dataset)-(lookback+lookforward)):
        feature = dataset[i:i+lookback]
        target = dataset[i+lookback+1:i+lookback+1+lookforward]
        N = len(target) - len(feature)
        for id in range(N):
            feature = np.append(feature, [float(0)])
        feature = torch.tensor(feature)
        if lookback != lookforward:
            feature = torch.unsqueeze(feature, 1)
        feature = feature.numpy()

        X.append(feature)
        y.append(target)
    X = np.array(X)
    y = np.array(y)
    return torch.tensor(X, dtype=torch.float), torch.tensor(y, dtype=torch.float)


path = os.path.join(args.root_path, args.data_path)
column = args.target

df = pd.read_csv(path)
timeseries = df[[column]].values.astype('float')
# prepare data for standardization
timeseries = timeseries.reshape((len(timeseries), 1))
# train the standardization
scaler = StandardScaler()
scaler = scaler.fit(timeseries)
print('Mean: %f, StandardDeviation: %f' % (scaler.mean_, sqrt(scaler.var_)))
# standardization the dataset
timeseries = scaler.transform(timeseries)

total_len = int(len(timeseries)*0.1)  # 10 % of datas for test
train_size = int(len(timeseries[:total_len]) * 0.70)
test_size = len(timeseries[:total_len]) - train_size
train, test = timeseries[:train_size], timeseries[train_size:total_len]

lookback = int(args.seq_len)
lookforward = int(args.pred_len)
X_train, y_train = create_dataset(
    train, lookback=lookback, lookforward=lookforward)
X_test, y_test = create_dataset(
    test, lookback=lookback, lookforward=lookforward)

X_train = X_train.to(args.gpu)
y_train = y_train.to(args.gpu)
X_test = X_test.to(args.gpu)
y_test = y_test.to(args.gpu)

# set up DataLoader for training set
train_dataset = MyDatas(X_train, y_train)
test_dataset = MyDatas(X_test, y_test)
train_loader = DataLoader(train_dataset, shuffle=True,
                          batch_size=int(args.batch_size))
# test_loader = DataLoader(test_dataset, shuffle=True,
#                          batch_size=int(args.batch_size))

num_hidden_neurons = int(args.num_neurons)


class Shallow_LSTM(nn.Module):

    def __init__(self):
        super().__init__()
        self.lstm = nn.LSTM(
            input_size=1, hidden_size=num_hidden_neurons, num_layers=args.num_layers, batch_first=True)
        self.linear = nn.Linear(num_hidden_neurons, 1)

    def forward(self, x):
        x, _ = self.lstm(x.to(args.gpu))
        x = self.linear(x)
        return x


model = Shallow_LSTM()
model.to(args.gpu)
optimizer = optim.Adam(model.parameters(), lr=float(args.learning_rate))
loss_fn = nn.MSELoss()
loss_fn2 = nn.L1Loss()
# loader = data.DataLoader(data.TensorDataset(
#     X_train, y_train), shuffle=True, batch_size=int(args.batch_size))

n_epochs = int(args.num_epochs)
model.float()
for epoch in range(n_epochs):
    model.train()
    for X_batch, y_batch in train_loader:
        y_pred = model(X_batch)
        loss = loss_fn(y_pred, y_batch)
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
    # Validation
    model.eval()
    with torch.no_grad():
        y_pred = model(X_train)
        train_mse = loss_fn(y_pred, y_train)
        train_mae = loss_fn2(y_pred, y_train)
        y_pred = model(X_test)
        test_mse = loss_fn(y_pred, y_test)
        test_mae = loss_fn2(y_pred, y_test)
    print("Epoch %d: train MSE %.4f, test MSE %.4f || train_MAE %.4f, test_MAE %.4f" % (
        epoch, train_mse, test_mse, train_mae, test_mae))
