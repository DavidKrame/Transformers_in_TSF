import torch
import torch.nn as nn
import torch.nn.functional as F

import numpy as np


class Model(nn.Module):
    def __init__(self, args):
        super(Model, self).__init__()
        self.input_layer = nn.Linear(1, 1000)
        self.activation = nn.GELU()
        self.output_layer = nn.Linear(1000, 1)

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
        out = self.input_layer(x_enc)
        out = self.activation(out)
        out = self.output_layer(out)

        return out
