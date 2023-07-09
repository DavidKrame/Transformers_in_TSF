if [ ! -d "./logs" ]; then
    mkdir ./logs
fi

if [ ! -d "./logs/Conformer" ]; then
    mkdir ./logs/Conformer
fi

train_epochs=3
patience=2
model_name="Conformer"
seq_len=96
file_name="Elec_Custom_Continue"

python -u ./Conformer/train_Elec_Custom_Continue.py \
    --data elec \
    --root_path ./dataset/ \
    --file_name $file_name \
    --data_path custom_elec_04.csv \
    --patience $patience\
    --target "OT" \
    --train_epochs $train_epochs >logs/Conformer/$model_name'_Elec_Custom_Continue_01_on_04'.log
