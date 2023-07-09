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
file_name="Elec_Freeze_SIRN"

python -u ./Conformer/train_SIRN.py \
    --data ECL \
    --file_name $file_name \
    --root_path ./dataset/ \
    --data_path electricity_OTH.csv \
    --patience $patience\
    --target "OT" \
    --train_epochs $train_epochs >logs/Conformer/$model_name'_electricity_Elec1_SIRN'.log
