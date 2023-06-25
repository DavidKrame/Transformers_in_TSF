if [ ! -d "./logs" ]; then
    mkdir ./logs
fi

if [ ! -d "./logs/MLP" ]; then
    mkdir ./logs/MLP
fi

model_name=MLP
seq_len=96

for pred_len in 96 192 384 768
do

    python -u ./LSTM_MLP/run_longExp.py \
      --is_training 1 \
      --root_path ./dataset/ \
      --data_path custom_elec_01.csv \
      --model_id custom_elec_01_96_$pred_len \
      --model $model_name \
      --data custom \
      --features S \
      --patience 5\
      --seq_len 96 \
      --label_len 48 \
      --pred_len $pred_len \
      --e_layers 2 \
      --d_layers 1 \
      --factor 3 \
      --enc_in 1 \
      --dec_in 1 \
      --c_out 1 \
      --des 'Exp' \
      --itr 1 \
      --train_epochs 10 >logs/MLP/$model_name'_custom_elec_01'_$seq_len'_'$pred_len.log

done
