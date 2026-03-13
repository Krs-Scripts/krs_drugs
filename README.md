
# KRS Drugs

Simple drugs system for **Qbox + ox_inventory + ox_target + ox_lib**

## Features

* Plant spawning system
* Collect drugs with ox_target
* Process drugs with NPC
* Server-side exploit checks
* Discord logging
* Configurable drugs

## Requirements

* qbx_core
* ox_inventory
* ox_lib
* ox_target

## Installation

1. Download the resource
2. Put it in your `resources` folder
3. Add to `server.cfg`

```
ensure ox_lib
ensure ox_inventory
ensure ox_target
ensure krs_drugs
```

## Config

All settings are inside:

```
shared/config.lua
```

You can configure:

* drugs
* collect zones
* process locations
* items
* amounts

## Support

If you have any issues or questions, open a ticket in the Discord server.
