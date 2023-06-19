if [ ! -d "./logs" ]; then
    mkdir ./logs
fi

if [ ! -d "./logs/Conformer" ]; then
    mkdir ./logs/Conformer
fi

train_epochs=10
patience=3
model_name="Conformer"
seq_len=96

python -u ./Conformer/train_SIRN_ETTh_1_2.py \
    --data ETTh2 \
    --root_path ./dataset/ \
    --data_path ETTh2.csv \
    --patience $patience\
    --target "OT" \
    --train_epochs $train_epochs >logs/Conformer/$model_name'_ETTh_1_to_2_SIRN'.log
