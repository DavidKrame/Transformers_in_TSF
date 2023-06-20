if [ ! -d "./logs" ]; then
    mkdir ./logs
fi

if [ ! -d "./logs/Conformer" ]; then
    mkdir ./logs/Conformer
fi

model_name="Conformer"
seq_len=96

python -u ./Conformer/prediction_Elec_Custom.py \
    --data elec \
    --root_path ./dataset/ \
    --data_path custom_elec_04.csv \
    --target "OT" >logs/Conformer/$model_name'_custom_elec_04_Prediction_from_01'.log
