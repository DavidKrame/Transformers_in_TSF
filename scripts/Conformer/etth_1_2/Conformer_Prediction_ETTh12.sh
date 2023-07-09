if [ ! -d "./logs" ]; then
    mkdir ./logs
fi

if [ ! -d "./logs/Conformer" ]; then
    mkdir ./logs/Conformer
fi

model_name="Conformer"
seq_len=96
file_name="Etth_Prediction"

python -u ./Conformer/prediction_ETTh.py \
    --data ETTh2 \
    --file_name $file_name \
    --root_path ./dataset/ \
    --data_path ETTh2.csv \
    --target "OT" >logs/Conformer/$model_name'_ETTh2_Prediction_from_ETTh1'.log
