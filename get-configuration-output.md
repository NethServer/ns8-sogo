# get-configuration output Schema

```txt
http://schema.nethserver.org/sogo/get-configuration-output.json
```

Get sogo configuration

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                 |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [get-configuration-output.json](sogo/get-configuration-output.json "open original schema") |

## get-configuration output Type

`object` ([get-configuration output](get-configuration-output.md))

## get-configuration output Examples

```json
{
  "host": "sogo8.rocky9-pve4.org",
  "lets_encrypt": false,
  "mail_server": "f38f9911-8341-452e-8941-d889385a59a8",
  "mail_domain": "rocky9-pve4.org",
  "admin_users": "",
  "workers_count": "20",
  "auxiliary_account": true,
  "activesync": true,
  "dav": true,
  "mail_server_URL": [
    {
      "name": "mail1",
      "label": "rocky9-pve4.org (R4-pve.rocky9-pve4.org)",
      "value": "f38f9911-8341-452e-8941-d889385a59a8,rocky9-pve4.org"
    },
    {
      "name": "mail1",
      "label": "prout.com (R4-pve.rocky9-pve4.org)",
      "value": "f38f9911-8341-452e-8941-d889385a59a8,prout.com"
    }
  ],
  "user_domains_list": [
    {
      "name": "rocky9-pve4.org",
      "label": "rocky9-pve4.org",
      "value": "rocky9-pve4.org"
    },
    {
      "name": "ad.rocky9-pve4.org",
      "label": "ad.rocky9-pve4.org",
      "value": "ad.rocky9-pve4.org"
    }
  ]
}
```

# get-configuration output Properties

| Property                                  | Type      | Required | Nullable       | Defined by                                                                                                                                                                           |
| :---------------------------------------- | :-------- | :------- | :------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [host](#host)                             | `string`  | Required | cannot be null | [get-configuration output](get-configuration-output-properties-host.md "http://schema.nethserver.org/sogo/get-configuration-output.json#/properties/host")                           |
| [lets\_encrypt](#lets_encrypt)            | `boolean` | Required | cannot be null | [get-configuration output](get-configuration-output-properties-lets_encrypt.md "http://schema.nethserver.org/sogo/get-configuration-output.json#/properties/lets_encrypt")           |
| [mail\_server](#mail_server)              | `string`  | Required | cannot be null | [get-configuration output](get-configuration-output-properties-mail_server.md "http://schema.nethserver.org/sogo/get-configuration-output.json#/properties/mail_server")             |
| [mail\_domain](#mail_domain)              | `string`  | Required | cannot be null | [get-configuration output](get-configuration-output-properties-mail_domain.md "http://schema.nethserver.org/sogo/get-configuration-output.json#/properties/mail_domain")             |
| [admin\_users](#admin_users)              | `string`  | Required | cannot be null | [get-configuration output](get-configuration-output-properties-admin_users.md "http://schema.nethserver.org/sogo/get-configuration-output.json#/properties/admin_users")             |
| [workers\_count](#workers_count)          | `string`  | Required | cannot be null | [get-configuration output](get-configuration-output-properties-workers_count.md "http://schema.nethserver.org/sogo/get-configuration-output.json#/properties/workers_count")         |
| [auxiliary\_account](#auxiliary_account)  | `boolean` | Required | cannot be null | [get-configuration output](get-configuration-output-properties-auxiliary_account.md "http://schema.nethserver.org/sogo/get-configuration-output.json#/properties/auxiliary_account") |
| [activesync](#activesync)                 | `boolean` | Required | cannot be null | [get-configuration output](get-configuration-output-properties-activesync.md "http://schema.nethserver.org/sogo/get-configuration-output.json#/properties/activesync")               |
| [dav](#dav)                               | `boolean` | Required | cannot be null | [get-configuration output](get-configuration-output-properties-dav.md "http://schema.nethserver.org/sogo/get-configuration-output.json#/properties/dav")                             |
| [mail\_server\_URL](#mail_server_url)     | `array`   | Required | cannot be null | [get-configuration output](get-configuration-output-properties-mail_server_url.md "http://schema.nethserver.org/sogo/get-configuration-output.json#/properties/mail_server_URL")     |
| [user\_domains\_list](#user_domains_list) | `array`   | Required | cannot be null | [get-configuration output](get-configuration-output-properties-user_domains_list.md "http://schema.nethserver.org/sogo/get-configuration-output.json#/properties/user_domains_list") |

## host



`host`

* is required

* Type: `string`

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-host.md "http://schema.nethserver.org/sogo/get-configuration-output.json#/properties/host")

### host Type

`string`

## lets\_encrypt



`lets_encrypt`

* is required

* Type: `boolean`

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-lets_encrypt.md "http://schema.nethserver.org/sogo/get-configuration-output.json#/properties/lets_encrypt")

### lets\_encrypt Type

`boolean`

## mail\_server



`mail_server`

* is required

* Type: `string`

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-mail_server.md "http://schema.nethserver.org/sogo/get-configuration-output.json#/properties/mail_server")

### mail\_server Type

`string`

## mail\_domain



`mail_domain`

* is required

* Type: `string`

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-mail_domain.md "http://schema.nethserver.org/sogo/get-configuration-output.json#/properties/mail_domain")

### mail\_domain Type

`string`

## admin\_users



`admin_users`

* is required

* Type: `string`

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-admin_users.md "http://schema.nethserver.org/sogo/get-configuration-output.json#/properties/admin_users")

### admin\_users Type

`string`

## workers\_count



`workers_count`

* is required

* Type: `string`

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-workers_count.md "http://schema.nethserver.org/sogo/get-configuration-output.json#/properties/workers_count")

### workers\_count Type

`string`

## auxiliary\_account



`auxiliary_account`

* is required

* Type: `boolean`

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-auxiliary_account.md "http://schema.nethserver.org/sogo/get-configuration-output.json#/properties/auxiliary_account")

### auxiliary\_account Type

`boolean`

## activesync



`activesync`

* is required

* Type: `boolean`

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-activesync.md "http://schema.nethserver.org/sogo/get-configuration-output.json#/properties/activesync")

### activesync Type

`boolean`

## dav



`dav`

* is required

* Type: `boolean`

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-dav.md "http://schema.nethserver.org/sogo/get-configuration-output.json#/properties/dav")

### dav Type

`boolean`

## mail\_server\_URL



`mail_server_URL`

* is required

* Type: `object[]` ([Details](get-configuration-output-properties-mail_server_url-items.md))

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-mail_server_url.md "http://schema.nethserver.org/sogo/get-configuration-output.json#/properties/mail_server_URL")

### mail\_server\_URL Type

`object[]` ([Details](get-configuration-output-properties-mail_server_url-items.md))

## user\_domains\_list



`user_domains_list`

* is required

* Type: `object[]` ([Details](get-configuration-output-properties-user_domains_list-items.md))

* cannot be null

* defined in: [get-configuration output](get-configuration-output-properties-user_domains_list.md "http://schema.nethserver.org/sogo/get-configuration-output.json#/properties/user_domains_list")

### user\_domains\_list Type

`object[]` ([Details](get-configuration-output-properties-user_domains_list-items.md))
