# tcbsd-ioc-boot-tool

Proof-of-concept tool for automatically building and running EPICS IOCs on TwinCAT/BSD PLCs.

## Requirements
* TwinCAT/BSD
* Python (`python3`)
* pytmc (`python3 -m pip install pytmc`)
* `gmake` (note: BSD make is not the same)
* [ads-deploy](https://github.com/pcdshub/ads-deploy) (** see notes)
* [ads-ioc](https://github.com/pcdshub/ads-ioc/) (** see notes)
* BSD must have LinuxEmu subsystem enabled (``sudo service linux start``)

### ads-ioc big important notes

ads-ioc BSD-compatibility Makefile changes are pending:
* https://github.com/pcdshub/ads-ioc/pull/98

#### Statically-linked Linux binary is required

ads-ioc must be built ahead of time on Linux (statically linked).
It's unclear if/when these required changes for localhost communication will be
merged. For now, you'll need to rebuild ads-ioc with these:
* https://github.com/pcdshub/ADS/pull/1
* https://github.com/pcdshub/twincat-ads/pull/12

You might consider using Docker to handle the build process:
* https://github.com/pcdshub/ads-ioc-docker/

#### Docker?
And then copy the built version out:
* ``docker cp $(docker create --name temp pcdshub/ads-ioc:R0.Y.Z):/cds/group/pcds/epics/ioc/common/ads-ioc/ .; docker rm temp``
* Re-iterating the warning: R0.6.1 is on Docker Hub but this doesn't include
  the localhost fixes required for BSD

### ads-deploy

#### Failure to install due to numpy

* ads-deploy typhos dependency won't install due to numpy
   * No one (including myself) has used typhos in ads-deploy since 2019 so it
     could be removed
   * Hotfixing it for now locally (remove ``typhos`` from ``requirements.txt``)

## File location notes
Project is available here:
`/usr/local/etc/TwinCAT/3.1/Boot/`
The remainder of the project files are in `CurrentConfig/*.tpzip` (where `*` is the project name), excluding the .tsproj.
For some reason, the `.tsproj` (which we need for ads-deploy) is in `CurrentConfig.tszip`

### TwinCAT/BSD

Provision by way of Ansible and our playbooks for ease of getting started:
https://github.com/pcdshub/twincat-bsd-ansible
