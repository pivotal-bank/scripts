# What am I??
A bunch of scripts - to deploy or clean out Spring Boot Trader / Pivotal bank in one fell shot

## Scripts to deploy the apps
** Before running these scripts, open setVars.sh and edit the line for BASE_DIR, point this at the location where you have Spring Boot Trader cloned. You're then good to go!**

These scripts are numbered, just run them in the logical order of numbering :) All the scripts execute

### 1_createService.sh
This script creates PCF Services from the marketplace - specifically an instance of MySQL, ConfigServer, ServiceDiscover and CircuitBreaker. It won't fail or re-build these services if they already exist in the space, with the same name. Run the corresponding delete script first if you want a clean start.
