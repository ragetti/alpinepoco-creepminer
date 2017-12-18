# alpinepoco-creepminer
Creepminer build on alpine 

https://github.com/Creepsky/creepMiner

Here is one way to run it. Assuming you setup your mining.conf file already.

I map in my mining.conf file through a volume mount: -v "/home/miner/dockerfiles/mycreepminer/mining.conf:/app/mining.conf"

The second volume mount is only since my mining configuration references all my plots off the same mount.
-v "/mnt/plots:/plots:ro"

Refer to Creeksky readme to how the configuration files is setup.


docker run -it \
-v "/home/miner/dockerfiles/mycreepminer/mining.conf:/app/mining.conf" \
-v "/mnt/plots:/plots:ro" \ 
-p 8126:8126 \
ragetti/alpinepoco-creepminer \
/app/creepMiner
