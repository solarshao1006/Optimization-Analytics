reset;
option solver cplex;
option cplex_options 'sensitivity primal';
option presolve  0;

# Sets
set VARS;
set RESOURCES;
set QUOTA_GROUP;

# parameters
# profit for each desk
param profit_info{VARS};
# September order for each type of desk
param sept_order_info{VARS};
# the amount of aluminum required for each type of desk
param aluminum_info{VARS};
# the amount of particle board required for each type of desk
param particle_board_info{VARS};
# the amount of pine sheet required for each type of desk
param pine_sheet_info{VARS};
# time needed to produce each type of desk at line1 
param line1{VARS};
# time needed to produce each type of desk at line2
param line2{VARS};
# time needed to produce each type of desk at line3
param line3{VARS};
# assemble finshining time required for each type of desk
param AF{VARS};
# hand-crafting time required for each type of desk
param HC{VARS};

# resources availability for September
# labor
param LR;
# aluminum
param AL;
# particle board
param PB;
# pine sheets
param PS;
# production line 1
param PL1;
# production line 2
param PL2;
# production line 3
param PL3;

# production quotas 
param minimum_perc{VARS, QUOTA_GROUP};
param maximum_perc{VARS, QUOTA_GROUP};

# Variables
# ESTU: economy student desk
# ESTA: economy standard desk
# EEXE: economy executive desk 
# BSTU: basic student desk
# BSTA: basic standard desk
# BEXE: basic executive desk
# HCSTU: hand-crafted student desk
# HCSTA: hand-crafted standard desk
# HCEXE: hand-crafted executive desk
var production_amount{VARS} >= 0;

# Objective function
# We want to maximize the profit, which is computed by the sum of the amount of each desk produced times its corresponding profit
maximize total_profit:
	sum{desks in VARS} (production_amount[desks] * profit_info[desks]);

# Constraints
# material constrains
subject to aluminum_constraint:
	sum{desks in VARS} (production_amount[desks] * aluminum_info[desks]) <= AL;
subject to particle_board_constraint:
	sum{desks in VARS} (production_amount[desks] * particle_board_info[desks]) <= PB;
subject to pine_sheet_constrains:
	sum{desks in VARS} (production_amount[desks] * pine_sheet_info[desks]) <= PS;

# labor hour constraints
subject to line1_constraint:
	sum{desks in VARS} (production_amount[desks] * line1[desks]) <= PL1;
subject to line2_constraint:
	sum{desks in VARS} (production_amount[desks] * line2[desks]) <= PL2;
subject to line3_constraint:
	sum{desks in VARS} (production_amount[desks] * line3[desks]) <= PL3;
# from the article, we know the total amount of minimutes required to produce a desk equals to:
# 2 x (the total production line time) + (hand crafting time) + (assembly/finshing time)
subject to total_labor_hour_constrain:
	sum{desks in VARS} (production_amount[desks] * (2 * (line1[desks] + line2[desks] + line3[desks]) + AF[desks] + HC[desks])) <= LR;

# order demand constraint
subject to order_constraint{desks in VARS}:
	production_amount[desks] >= sept_order_info[desks];

# quotas constrains
subject to quotas_min{group in QUOTA_GROUP}:
	sum{desks in VARS} (minimum_perc[desks, group] * production_amount[desks]) >= 0;
subject to quotas_max{group in QUOTA_GROUP}:
	sum{desks in VARS} (maximum_perc[desks, group] * production_amount[desks]) <= 0;
	