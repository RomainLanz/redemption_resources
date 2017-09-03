# Source Code of Redemption Server

## Configuration

```
endpoint_add_tcp "0.0.0.0:30120"
endpoint_add_udp "0.0.0.0:30120"

# Default Variable
sv_hostname "XXX"
rcon_password XXX

sv_scriptHookAllowed 0
sv_endpointprivacy true

# EssentialMode Configuration
set mysql_connection_string "server=127.0.0.01;port=3306;database=essentialmode;userid=root;password=XXX"
set es_enableCustomData 1

# Preload Resources
start mysql-async
start async
start cron
start instance
start skinchanger

# Boot FiveM
start sessionmanager
start spawnmanager
start mapmanager
start baseevents
start chat
start hardcap

# Boot Essential Mode
start essentialmode
start es_admin2
start esplugin_mysql

# Boot ESX
start es_extended
start esx_menu_default
start esx_menu_list
start esx_menu_dialog
start esx_phone
start esx_skin
start esx_addonaccount
start esx_society
start esx_billing
start esx_datastore
start esx_addoninventory
start esx_status
start esx_service

# Start ESX
start esx_policejob
start esx_ambulancejob
start esx_taxijob
start esx_mecanojob
start esx_jobs
start esx_vehicleshop
start esx_barbershop
start esx_clotheshop
start esx_weashop
start esx_shops
start esx_atm
start esx_property
start esx_basicneeds
start esx_joblisting
start esx_garage
start esx_lscustom
start esx_holdup
start esx_drugs

# Boot Redemption Source Code
start redemption
start menu
start sexyspeedometer
start loadscreen
start coords
start whitelist

# Restart Buggy Resources
restart sessionmanager
```