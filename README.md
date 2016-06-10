# What am I??
A bunch of scripts - to deploy or clean out Spring Boot Trader / Pivotal bank in one fell shot

## Scripts to deploy the apps
**PLEASE NOTE**
* Before running these scripts, open setVars.sh and edit the line for BASE_DIR, point this at the location where you have Spring Boot Trader cloned. 
* After running script 1, got into Apps Manager and configure the location of the backing Github Configuration.

These scripts are numbered, just run them in the logical order of numbering from script 1 all the way to script 3 :) After running scr

### 1_createService.sh
This script creates PCF Services from the marketplace - specifically an instance of MySQL, ConfigServer, ServiceDiscovery and CircuitBreaker. It chooses which services and service plans to create by reading a file called ```PCFServices.list```
It won't fail or re-build these services if they already exist in the space with the same name. Run the corresponding delete script first if you want a clean start.

To execute simply run:

``` ./1_createService.sh ```

Note - before running step 2, Log into Apps Manager, hit 'Manage' on the ConfigServer service and paste in the URL of the Github repo storing the config for Spring Boot Trader and apply changes.

After it creates the services, this script pauses 60 seconds to allow the Spring Cloud Services to initialise, if you want to skip this just hit Ctl+C.

### 2_buildAndDeploy.sh
This script performs a Gradle build and then a cf push of all the Microservices, sequentially. It reads the Micoservices to build and deploy from a file called ```microServices.list```. Edit this file if you have more microservices or need to remove any.

To execute simply run:

``` ./2_buildAndDeploy.sh ```

### 3_addTarget.sh
This script is necessary to make your Microservices register with Eureka in Service Discovery. This step is only necessary if you are running in a PCF environment which <a href="https://docs.pivotal.io/spring-cloud-services/service-registry/writing-client-applications.html" target="_blank">uses self-signed certificates</a>. If you ar eon such a PCF environment and you don't run this step, then none of your Microservices witll Register in Service Discovery even though they have bound to the service.

To execute simply run:

``` ./3_addTarget.sh ```
