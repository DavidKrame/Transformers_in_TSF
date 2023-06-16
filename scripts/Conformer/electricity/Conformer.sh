if [ ! -d "./logs" ]; then
    mkdir ./logs
fi

if [ ! -d "./logs/Conformer" ]; then
    mkdir ./logs/Conformer
fi


train_epochs=10
patience=5
model_name="Conformer"
seq_len=96

python -u ./Conformer/train.py \
    --data ECL \
    --root_path ./dataset/ \
    --data_path electricity.csv \
    --patience $patience\
    --target "OT" \
    --train_epochs $train_epochs >logs/Conformer/$model_name'_electricity_'.log
