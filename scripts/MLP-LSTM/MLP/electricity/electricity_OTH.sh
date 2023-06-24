if [ ! -d "./logs" ]; then
    mkdir ./logs
fi

if [ ! -d "./logs/MLP_LSTM" ]; then
    mkdir ./logs/MLP_LSTM
fi

num_epochs=10
model_name="MLP"
seq_len=96
num_neurons=1000
batch_size=4

for pred_len in 96 192 384 768
do

    python -u run_MLP.py \
      --is_training 1 \
      --root_path ./dataset/ \
      --data_path electricity_OTH.csv \
      --model_id MLP_96_$pred_len \
      --patience 5\
      --batch_size $batch_size \
      --seq_len $seq_len \
      --pred_len $pred_len \
      --target "OT" \
      --num_neurons $num_neurons\
      --num_epochs $num_epochs >logs/MLP_LSTM/$model_name'_electricity_OTH'_$seq_len'_'$pred_len.log

  done