# ns8-sogo

This module intends to istall the SOGo groupware : https://www.sogo.nu/

## Install

Instantiate the module with:

    add-module ghcr.io/nethserver/sogo:latest 1

The output of the command will return the instance name.
Output example:

    {"module_id": "sogo1", "image_name": "sogo", "image_url": "ghcr.io/nethserver/sogo:latest"}

## Get the configuration
You can retrieve the configuration with

api-cli run get-configuration --agent module/sogo1

## Configure

Let's assume that the sogo instance is named `sogo1`.


Launch `configure-module`, by setting the following parameters:
- `host`: a fully qualified domain name for the application
- `lets_encrypt`: enable or disable Let's Encrypt certificate (true/false)
- `mail_server`: the module UUID of the the mail server (only on NS8), for example `24c52316-5af5-4b4d-8b0f-734f9ee9c1d9`
- `mail_domain`: the mail domain used for user IMAP login and SOGo user identifier. It must correspond to a valid mail domain handled by `mail_server` where user names are valid mail addresses too
- `ldap_domain`:  a Ldap domain where to authenticate the users, it could be different than hostname. The ldap_domain is used to find an existing LDAP through LDAP proxy
- `admin_users`: the administrator of SOGo, a comma separated list (user1,user2)
- `workers_count`: The number of workers for SOGo; you need to adapt it to the numbers of users
- `auxiliary_account`: Allow users to set other email accounts inside the SOGo webmail (boolean)
- `activesync`: Enable the activesync protocom (boolean)
- `dav`: Enable the DAV protocol (caldav,cardav) (boolean)

Example:

    api-cli run configure-module --agent module/sogo1 --data - <<EOF
    {
    "mail_server": "f38f9911-8341-452e-8941-d889385a59a8",
    "ldap_domain": "ad.rocky9-pve4.org",
    "admin_users" : "Administrator",
    "mail_domain": "rocky9-pve4.org",
    "lets_encrypt": false,
    "host": "sogo3.rocky9-pve4.org",
    "workers_count": "3",
    "auxiliary_account": true,
    "activesync": true,
    "dav": true
    }
    EOF

The above command will:
- start and configure the SOGo instance
- configure a virtual host for trafik to access the instance

## Manual configuration

Some settings are not available in the UI, you need to change them manually, refer to documentation : https://www.sogo.nu/files/docs/SOGoInstallationGuide.html

```
ssh sogo1@::1
vim .config/state/environment
```
modify the settings, then restart sogo : `systemctl restart --user sogo`

```
BACKUPTIME=#30 0
DRAFTSFOLDER=Drafts
SENTFOLDER=Sent
SESSIONDURATION=1440
SOGOACLSSENDEMAILNOTIFICATIONS=NO
SOGOAPPOINTMENTSENDEMAILNOTIFICATIONS=YES
SOGOENABLEEMAILALARMS=YES
SOGOFOLDERSSENDEMAILNOTIFICATIONS=NO
SOGOINTERNALSYNCINTERVAL=30
SOGOMAXIMUMPINGINTERVAL=3540
SOGOMAXIMUMSYNCINTERVAL=3540
SOGOMAXIMUMSYNCRESPONSESIZE=2048
SOGOMAXIMUMSYNCWINDOWSIZE=100
SXVMEMLIMIT=512
WOWATCHDOGREQUESTTIMEOUT=60
```

## Fine tuning

SOGo must be tuned https://sogo.nu/files/docs/SOGoInstallationGuide.html#_microsoft_enterprise_activesync_tuning following the number of users, some settings can be tested.

Keep in mind to set one worker per active user for the activesync connection. The  SXVMEMLIMIT https://sogo.nu/files/docs/SOGoInstallationGuide.html#_general_preferences could be be adjusted also, between 25MB to 45 MB per active user with the activesync service.

## Custom configuration files

You can modify the configuration by adding new files to the folder `/home/sogo1/.config/state/templates`, if the files are present they are used instead of the default one and they are included in the backup of the module

- sogo configuration: `templates/sogo.conf.local`
- apache configuration: `templates/SOGo.conf.local`
- cron configuration: `templates/cron.conf.local`

```
runagent -m sogo1
# copy the relevant files (copy and edit only the file you need)
cp ../templates/sogo.conf templates/sogo.conf.local 
cp ../templates/SOGo.conf templates/SOGo.conf.local 
cp ../templates/cron.conf templates/cron.conf.local 
# edit the files
vim template/sogo.conf.local
vim templates/SOGo.conf.local
vim templates/cron.conf.local
# restart the service
systemctl restart --user sogo
```


## Backup database

You can enable a database backup for each users of their addressbooks and their calendars, older entries more than 31 days are removed. The syntax is cron based, in the example it will be triggered each day at 00h30. the backup is disabled by default

```
- BACKUPTIME=#30 0
+ BACKUPTIME=30 0
```

you can restore the data with a tool ``sogo-restore-user``, for example:

  `sogo-restore-user /var/lib/sogo/backups/sogo-2017-12-10_0030/ stephane`

or for all users:

  `sogo-restore-user /var/lib/sogo/backups/sogo-2017-12-10_0030/ -A`

## Uninstall

To uninstall the instance:

    remove-module --no-preserve sogo1

## Testing

Test the module using the `test-module.sh` script:


    ./test-module.sh <NODE_ADDR> ghcr.io/nethserver/sogo:latest

The tests are made using [Robot Framework](https://robotframework.org/)

## UI translation

Translated with [Weblate](https://hosted.weblate.org/projects/ns8/).

To setup the translation process:

- add [GitHub Weblate app](https://docs.weblate.org/en/latest/admin/continuous.html#github-setup) to your repository
- add your repository to [hosted.weblate.org]((https://hosted.weblate.org) or ask a NethServer developer to add it to ns8 Weblate project
