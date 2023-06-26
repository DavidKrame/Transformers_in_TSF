if [ ! -d "./logs" ]; then
    mkdir ./logs
fi

if [ ! -d "./logs/LSTM" ]; then
    mkdir ./logs/LSTM
fi

model_name=LSTM
seq_len=96

for pred_len in 96 192 384 768
do

    python -u ./LSTM_MLP/predict_Elec_Custom.py \
      --is_training 0 \
      --root_path ./dataset/ \
      --data_path custom_elec_04.csv \
      --model_id custom_elec_04_96_$pred_len \
      --model $model_name \
      --data custom \
      --features S \
      --seq_len 96 \
      --label_len 48 \
      --pred_len $pred_len \
      --e_layers 2 \
      --d_layers 1 \
      --factor 3 \
      --enc_in 1 \
      --dec_in 1 \
      --c_out 1 \
      --itr 1 \
      --des 'Exp' >logs/LSTM/$model_name'_Prediction_elec_custom_on_04'_$seq_len'_'$pred_len.log

done