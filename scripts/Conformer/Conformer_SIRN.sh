if [ ! -d "./logs" ]; then
    mkdir ./logs
fi

if [ ! -d "./logs/Conformer" ]; then
    mkdir ./logs/Conformer
fi

train_epochs=10
patience=5
model_name="Conformer"
seq_len=96

python -u ./Conformer/train_SIRN.py \
    --data ETTh1 \
    --root_path ./dataset/ \
    --data_path ETTh1_OTH.csv \
    --patience $patience \
    --target "OT" \
    --train_epochs $train_epochs >logs/Conformer/$model_name'_ETTh1_SIRN_OTH_'.log

python -u ./Conformer/train_SIRN.py \
    --data ETTm1 \
    --root_path ./dataset/ \
    --data_path ETTm1_OTH.csv \
    --patience $patience\
    --target "OT" \
    --train_epochs $train_epochs >logs/Conformer/$model_name'_ETTm1_SIRN_OTH_'.log
