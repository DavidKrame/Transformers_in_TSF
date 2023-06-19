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

python -u ./Conformer/train_SIRN_Elec_Custom.py \
    --data elec \
    --root_path ./dataset/ \
    --data_path custom_elec_04.csv \
    --patience $patience\
    --target "OT" \
    --train_epochs $train_epochs >logs/Conformer/$model_name'_custom_elec_01_to_04_SIRN'.log
