#/bin/bash


mysql -u root -p'111111' --local-infile=1 ccdb -e "LOAD DATA LOCAL INFILE '/home/q/cardev/carbin.yang/resource_data/order_basic_data.txt' 
INTO TABLE order_basic_data FIELDS TERMINATED BY '\t'" 

