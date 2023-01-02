reset;
option solver cplex;
option cplex_options 'sensitivity';
option presolve 0;

# initialize row, col index
set row;
set col;

# parameters 
param per{row, col}; #percentage of selling price to profit
param p{row, col}; #selling price, calculation detail showing in the report
param lot_size{row, col}; #lot size constant, detail showing in report
param parking{row, col}; #parking constant, detail showing in report

# decision variable
var x{row, col} >= 0; 
var products{i in 1..4} >= 0; #the total unit of homes in each series

# objective function
maximize profit: sum{i in row} sum{j in col} per[i, j] * p[i,j] * x[i,j];

# constraint
# construction amount constraint
subject to amount_c11:
	x[1,1] >= 8;
subject to amount_c12:
	x[2,1] >= 8;
	subject to amount_c13:
	x[3,1] >= 8;
	subject to amount_c14:
	x[4,1] >= 8;
subject to amount_c2:
	x[5,1] <= 0.25 * (x[5,1] + x[5,2]);
subject to amount_c3:
	x[9,1] <= 0.25 * (x[9,1] + x[9,2]);

# lot size constraint
subject to lot_size_c:
	(x[1,1] + x[2,1] + x[3,1] + x[4,1]) * 0.5 * 43560 <= 50 * 0.5 * 43560;

# parking constraint
subject to parking_c:
	sum{i in row} sum{j in col} x[i,j] * parking[i,j] <= 15 * 43560;

# total land space constraint
subject to total_land_space_c:
	sum{i in row} sum{j in col} x[i,j] * (lot_size[i, j] + parking[i, j] + 1000) <= 300*43560;

# bedroom variety constraints
subject to five_bedroom_max_c:
	x[1,1] + x[1,2] <= 0.15 * sum{i in row} sum{j in col} x[i, j];
subject to five_bedroom_min_c:
	x[1,1] + x[1,2] >= 0.05 * sum{i in row} sum{j in col} x[i, j];
subject to four_bedroom_max_c:
	sum{j in col} (x[2,j] + x[3,j] + x[5,j] + x[6,j] + x[9,j]) <= 0.4 * sum{i in row} sum{j in col} x[i, j];
subject to four_bedroom_min_c:
	sum{j in col} (x[2,j] + x[3,j] + x[5,j] + x[6,j] + x[9,j]) >= 0.25 * sum{i in row} sum{j in col} x[i, j];
subject to three_bedroom_max_c:
	sum{j in col} (x[4,j] + x[7,j] + x[8,j] + x[10,j] + x[11,j] + x[13,j]) <= 0.4 * sum{i in row} sum{j in col} x[i, j];
subject to three_bedroom_min_c:
	sum{j in col} (x[4,j] + x[7,j] + x[8,j] + x[10,j] + x[11,j] + x[13,j]) >= 0.25 * sum{i in row} sum{j in col} x[i, j];
subject to two_bedroom_max_c:
	sum{j in col} (x[12,j] + x[14,j] + x[15,j]) <= 0.25 * sum{i in row} sum{j in col} x[i, j];
subject to two_bedroom_min_c:
	sum{j in col} (x[12,j] + x[14,j] + x[15,j]) >= 0.15 * sum{i in row} sum{j in col} x[i, j];

subject to products_definition1:
	products[1] = sum{i in 1..4} sum{j in col} x[i,j];
subject to products_definition2:
	products[2] = sum{i in 5..8} sum{j in col} x[i,j];
subject to products_definition3:
	products[3] = sum{i in 9..12} sum{j in col} x[i,j];
subject to products_definition4:
	products[4] = sum{i in 13..15} sum{j in col} x[i,j];

# product variety constraints
subject to product1_max_c:
	products[1] <= 0.35 * sum{i in row} sum{j in col} x[i, j];
subject to product1_min_c:
	products[1] >= 0.15 * sum{i in row} sum{j in col} x[i, j];
subject to product2_max_c:
	products[2] <= 0.35 * sum{i in row} sum{j in col} x[i, j];
subject to product2_min_c:
	products[2] >= 0.15 * sum{i in row} sum{j in col} x[i, j];
subject to product3_max_c:
	products[3] <= 0.35 * sum{i in row} sum{j in col} x[i, j];
subject to product3_min_c:
	products[3] >= 0.15 * sum{i in row} sum{j in col} x[i, j];
subject to product4_max_c:
	products[4] <= 0.35 * sum{i in row} sum{j in col} x[i, j];
subject to product4_min_c:
	products[4] >= 0.15 * sum{i in row} sum{j in col} x[i, j];

# constraints for each series
# Grand Estate
subject to variety_c1:
	x[1,1] + x[1,2] <= 0.35 * products[1];
subject to variety_c2:
	x[1,1] + x[1,2] >= 0.2 * products[1];
subject to variety_c3:
	x[2,1] + x[2,2] <= 0.35 * products[1];
subject to variety_c4:
	x[2,1] + x[2,2] >= 0.2 * products[1];
subject to variety_c5:
	x[3,1] + x[3,2] <= 0.35 * products[1];
subject to variety_c6:
	x[3,1] + x[3,2] >= 0.2 * products[1];
subject to variety_c7:
	x[4,1] + x[4,2] <= 0.35 * products[1];
subject to variety_c8:
	x[4,1] + x[4,2] >= 0.2 * products[1];

# Glen Wood Collection
subject to variety_c9:
	x[5,1] + x[5,2] <= 0.35 * products[2];
subject to variety_c10:
	x[5,1] + x[5,2] >= 0.2 * products[2];
subject to variety_c11:
	x[6,1] + x[6,2] <= 0.35 * products[2];
subject to variety_c12:
	x[6,1] + x[6,2] >= 0.2 * products[2];
subject to variety_c13:
	x[7,1] + x[7,2] <= 0.35 * products[2];
subject to variety_c14:
	x[7,1] + x[7,2] >= 0.2 * products[2];
subject to variety_c15:
	x[8,1] + x[8,2] <= 0.35 * products[2];
subject to variety_c16:
	x[8,1] + x[8,2] >= 0.2 * products[2];

# Lakeview Patio Homes
subject to variety_c17:
	x[9,1] + x[9,2] <= 0.35 * products[3];
subject to variety_c18:
	x[9,1] + x[9,2] >= 0.2 * products[3];
subject to variety_c19:
	x[10,1] + x[10,2] <= 0.35 * products[3];
subject to variety_c20:
	x[10,1] + x[10,2] >= 0.2 * products[3];
subject to variety_c21:
	x[11,1] + x[11,2] <= 0.35 * products[3];
subject to variety_c22:
	x[11,1] + x[11,2] >= 0.2 * products[3];
subject to variety_c23:
	x[12,1] + x[12,2] <= 0.35 * products[3];
subject to variety_c24:
	x[12,1] + x[12,2] >= 0.2 * products[3];

# Country Condominiums
subject to variety_c25:
	x[13,1] + x[13,2] <= 0.35 * products[4];
subject to variety_c26:
	x[13,1] + x[13,2] >= 0.2 * products[4];
subject to variety_c27:
	x[14,1] + x[14,2] <= 0.35 * products[4];
subject to variety_c28:
	x[14,1] + x[14,2] >= 0.2 * products[4];
subject to variety_c29:
	x[15,1] + x[15,2] <= 0.35 * products[4];
subject to variety_c30:
	x[15,1] + x[15,2] >= 0.2 * products[4];

subject to appearence_c:
	0.7 * sum{i in 1..3} products[i] >= sum{j in col} (x[1,j] + x[2,j] + x[5,j] + x[6,j] + x[7,j] + x[9,j] + x[10,j]);

subject to affordable_c:
	sum{j in col} (x[12,j] + x[14,j] + x[15,j]) >= 0.15 * sum{i in row} sum{j in col} x[i,j];