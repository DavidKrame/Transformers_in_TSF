if [ ! -d "./logs" ]; then
    mkdir ./logs
fi

if [ ! -d "./logs/MLP_LSTM" ]; then
    mkdir ./logs/MLP_LSTM
fi

num_epochs=10
model_name="LSTM"
seq_len=96
num_neurons=1000
num_layers=1
batch_size=4

for pred_len in 96 192 384 768
do

    python -u run_LSTM.py \
      --is_training 1 \
      --root_path ./dataset/ \
      --data_path ETTh1.csv \
      --model_id LSTM_96_$pred_len \
      --patience 10 \
      --batch_size $batch_size \
      --seq_len $seq_len \
      --pred_len $pred_len \
      --target "OT" \
      --num_neurons $num_neurons\
      --num_layers $num_layers \
      --num_epochs $num_epochs >logs/MLP_LSTM/$model_name'_Etth1'_$seq_len'_'$pred_len.log
    
    python -u run_LSTM.py \
      --is_training 1 \
      --root_path ./dataset/ \
      --data_path ETTm1.csv \
      --model_id LSTM_96_$pred_len \
      --batch_size $batch_size \
      --patience 10\
      --seq_len $seq_len \
      --pred_len $pred_len \
      --target "OT" \
      --num_neurons $num_neurons\
      --num_layers $num_layers \
      --num_epochs $num_epochs >logs/MLP_LSTM/$model_name'_Ettm1'_$seq_len'_'$pred_len.log

    python -u run_LSTM.py \
      --is_training 1 \
      --root_path ./dataset/ \
      --data_path weather.csv \
      --model_id LSTM_96_$pred_len \
      --patience 10\
      --batch_size $batch_size \
      --seq_len $seq_len \
      --pred_len $pred_len \
      --target "OT" \
      --num_neurons $num_neurons\
      --num_layers $num_layers \
      --num_epochs $num_epochs >logs/MLP_LSTM/$model_name'_weather'_$seq_len'_'$pred_len.log
    
    python -u run_LSTM.py \
      --is_training 1 \
      --root_path ./dataset/ \
      --data_path electricity.csv \
      --model_id LSTM_96_$pred_len \
      --patience 10\
      --batch_size $batch_size \
      --seq_len $seq_len \
      --pred_len $pred_len \
      --target "OT" \
      --num_neurons $num_neurons\
      --num_layers $num_layers \
      --num_epochs $num_epochs >logs/MLP_LSTM/$model_name'_electricity'_$seq_len'_'$pred_len.log

  done