import torch
import torch.nn as nn
import torch.nn.functional as F

import numpy as np


class Model(nn.Module):
    def __init__(self, args):
        super(Model, self).__init__()
        self.lstm = nn.LSTM(
            input_size=1, hidden_size=1000, num_layers=1, batch_first=True
        )
        self.linear = nn.Linear(1000, 1)

    def forward(
        self,
        x_enc,
        x_mark_enc,
        x_dec,
        x_mark_dec,
        enc_self_mask=None,
        dec_self_mask=None,
        dec_enc_mask=None,
    ):
        out, _ = self.lstm(x_enc)
        out = self.linear(out)
        return out
