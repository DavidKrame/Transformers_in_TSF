
if [ ! -d "./logs" ]; then
    mkdir ./logs
fi

if [ ! -d "./logs/Linears" ]; then
    mkdir ./logs/Linears
fi
seq_len=96

for model_name in NLinear DLinear
do

python -u run_longExp.py \
  --is_training 1 \
  --root_path ./dataset/ \
  --data_path ETTm1.csv \
  --model_id ETTm1_$seq_len'_'96 \
  --model $model_name \
  --data ETTm1 \
  --features S \
  --seq_len $seq_len \
  --pred_len 96 \
  --enc_in 7 \
  --des 'Exp' \
  --itr 1 --batch_size 8 --learning_rate 0.0001 >logs/Linears/$model_name'_'ETTm1_$seq_len'_'96.log

python -u run_longExp.py \
  --is_training 1 \
  --root_path ./dataset/ \
  --data_path ETTm1.csv \
  --model_id ETTm1_$seq_len'_'192 \
  --model $model_name \
  --data ETTm1 \
  --features S \
  --seq_len $seq_len \
  --pred_len 192 \
  --enc_in 7 \
  --des 'Exp' \
  --itr 1 --batch_size 8 --learning_rate 0.0001 >logs/Linears/$model_name'_'ETTm1_$seq_len'_'192.log

python -u run_longExp.py \
  --is_training 1 \
  --root_path ./dataset/ \
  --data_path ETTm1.csv \
  --model_id ETTm1_$seq_len'_'384 \
  --model $model_name \
  --data ETTm1 \
  --features S \
  --seq_len $seq_len \
  --pred_len 384 \
  --enc_in 7 \
  --des 'Exp' \
  --itr 1 --batch_size 8 --learning_rate 0.0001 >logs/Linears/$model_name'_'ETTm1_$seq_len'_'384.log

python -u run_longExp.py \
  --is_training 1 \
  --root_path ./dataset/ \
  --data_path ETTm1.csv \
  --model_id ETTm1_$seq_len'_'768 \
  --model $model_name \
  --data ETTm1 \
  --features S \
  --seq_len $seq_len \
  --pred_len 768 \
  --enc_in 7 \
  --des 'Exp' \
  --itr 1 --batch_size 8 --learning_rate 0.0001 >logs/Linears/$model_name'_'ETTm1_$seq_len'_'768.log
  
done