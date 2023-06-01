if [ ! -d "./logs" ]; then
    mkdir ./logs
fi

if [ ! -d "./logs/Conformer" ]; then
    mkdir ./logs/Conformer
fi

model_name="Conformer"
seq_len=96
initial_training_data=ETTh1.csv
with_reduced_train=1

python -u ./Conformer/Cross_prediction.py \
    --data ETTh1 \
    --root_path ./dataset/ \
    --original_model $initial_training_data \
    --with_reduced_train $with_reduced_train \
    --data_path ETTh1.csv \
    --target "OT" >logs/Conformer/$model_name'ETTh1_by_'$initial_training_data'_With_red_train_'$with_reduced_train.log

python -u ./Conformer/Cross_prediction.py \
    --data ETTm1 \
    --root_path ./dataset/ \
    --original_model $initial_training_data \
    --with_reduced_train $with_reduced_train \
    --data_path ETTm1.csv \
    --target "OT" >logs/Conformer/$model_name'ETTm1_by_'$initial_training_data'_With_red_train_'$with_reduced_train.log

python -u ./Conformer/Cross_prediction.py \
    --data WTH \
    --root_path ./dataset/ \
    --original_model $initial_training_data \
    --with_reduced_train $with_reduced_train \
    --data_path weather.csv \
    --target "OT" >logs/Conformer/$model_name'Weather_by_'$initial_training_data'_With_red_train_'$with_reduced_train.log

python -u ./Conformer/Cross_prediction.py \
    --data ECL \
    --root_path ./dataset/ \
    --original_model $initial_training_data \
    --with_reduced_train $with_reduced_train \
    --data_path electricity.csv \
    --target "OT" >logs/Conformer/$model_name'Electricity_by_'$initial_training_data'_With_red_train_'$with_reduced_train.log
