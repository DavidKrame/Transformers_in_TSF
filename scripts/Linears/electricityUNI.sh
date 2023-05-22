
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
  --data_path electricity.csv \
  --model_id Electricity_$seq_len'_'96 \
  --model $model_name \
  --data custom \
  --features S \
  --seq_len $seq_len \
  --pred_len 96 \
  --enc_in 321 \
  --des 'Exp' \
  --itr 1 --batch_size 16  --learning_rate 0.001 >logs/Linears/$model_name'_'electricity_$seq_len'_'96.log 

python -u run_longExp.py \
  --is_training 1 \
  --root_path ./dataset/ \
  --data_path electricity.csv \
  --model_id Electricity_$seq_len'_'192 \
  --model $model_name \
  --data custom \
  --features S \
  --seq_len $seq_len \
  --pred_len 192 \
  --enc_in 321 \
  --des 'Exp' \
  --itr 1 --batch_size 16  --learning_rate 0.001 >logs/Linears/$model_name'_'electricity_$seq_len'_'192.log  

python -u run_longExp.py \
  --is_training 1 \
  --root_path ./dataset/ \
  --data_path electricity.csv \
  --model_id Electricity_$seq_len'_'384 \
  --model $model_name \
  --data custom \
  --features S \
  --seq_len $seq_len \
  --pred_len 384 \
  --enc_in 321 \
  --des 'Exp' \
  --itr 1 --batch_size 16  --learning_rate 0.001  >logs/Linears/$model_name'_'electricity_$seq_len'_'384.log  

python -u run_longExp.py \
  --is_training 1 \
  --root_path ./dataset/ \
  --data_path electricity.csv \
  --model_id Electricity_$seq_len'_'768 \
  --model $model_name \
  --data custom \
  --features S \
  --seq_len $seq_len \
  --pred_len 768 \
  --enc_in 321 \
  --des 'Exp' \
  --itr 1 --batch_size 16  --learning_rate 0.001  >logs/Linears/$model_name'_'electricity_$seq_len'_'768.log  
done