if [ ! -d "./logs" ]; then
    mkdir ./logs
fi

if [ ! -d "./logs/Conformer" ]; then
    mkdir ./logs/Conformer
fi

model_name="Conformer"
seq_len=96

python -u ./Conformer/prediction_Elec1.py \
    --data ECL \
    --root_path ./dataset/ \
    --data_path electricity_OTH.csv \
    --target "OT" >logs/Conformer/$model_name'_electricity_Prediction'.log
