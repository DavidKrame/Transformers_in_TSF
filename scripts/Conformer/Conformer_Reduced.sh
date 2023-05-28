if [ ! -d "./logs" ]; then
    mkdir ./logs
fi

if [ ! -d "./logs/Conformer" ]; then
    mkdir ./logs/Conformer
fi


train_epochs=2
patience=1
model_name="Conformer"
seq_len=96

python -u ./Conformer/train_Reduced.py \
    --data ETTh1 \
    --root_path ./dataset/ \
    --data_path ETTh1.csv \
    --patience $patience \
    --target "OT" \
    --train_epochs $train_epochs >logs/Conformer/$model_name'_ETTh1_Reduced'.log

python -u ./Conformer/train_Reduced.py \
    --data ETTm1 \
    --root_path ./dataset/ \
    --data_path ETTm1.csv \
    --patience $patience\
    --target "OT" \
    --train_epochs $train_epochs >logs/Conformer/$model_name'_ETTm1_Reduced'.log

python -u ./Conformer/train_Reduced.py \
    --data WTH \
    --root_path ./dataset/ \
    --data_path weather.csv \
    --patience $patience\
    --target "OT" \
    --train_epochs $train_epochs >logs/Conformer/$model_name'_weather_Reduced'.log

python -u ./Conformer/train_Reduced.py \
    --data ECL \
    --root_path ./dataset/ \
    --data_path electricity.csv \
    --patience $patience\
    --target "OT" \
    --train_epochs $train_epochs >logs/Conformer/$model_name'_electricity_Reduced'.log
