if [ ! -d "./logs" ]; then
    mkdir ./logs
fi

if [ ! -d "./logs/Conformer" ]; then
    mkdir ./logs/Conformer
fi

model_name="Conformer"
seq_len=96
initial_training_data=ETTh1.csv

python -u ./Conformer/prediction_WITHOUT_TRAIN.py \
    --data ETTh1 \
    --root_path ./dataset/ \
    --original_model $initial_training_data \
    --data_path ETTh1.csv \
    --target "OT" >logs/Conformer/$model_name'ETTh1_by_'$initial_training_data.log

python -u ./Conformer/prediction_WITHOUT_TRAIN.py \
    --data ETTm1 \
    --root_path ./dataset/ \
    --original_model $initial_training_data \
    --data_path ETTm1.csv \
    --target "OT" >logs/Conformer/$model_name'ETTm1_by_'$initial_training_data.log

python -u ./Conformer/prediction_WITHOUT_TRAIN.py \
    --data WTH \
    --root_path ./dataset/ \
    --original_model $initial_training_data \
    --data_path weather.csv \
    --target "OT" >logs/Conformer/$model_name'Weather_by_'$initial_training_data.log

python -u ./Conformer/prediction_WITHOUT_TRAIN.py \
    --data ECL \
    --root_path ./dataset/ \
    --original_model $initial_training_data \
    --data_path electricity.csv \
    --target "OT" >logs/Conformer/$model_name'Electricity_by_'$initial_training_data.log
