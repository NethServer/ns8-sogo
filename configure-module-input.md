# configure-module input Schema

```txt
http://schema.nethserver.org/sogo/configure-module-input.json
```

Configure sogo

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                             |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [configure-module-input.json](sogo/configure-module-input.json "open original schema") |

## configure-module input Type

`object` ([configure-module input](configure-module-input.md))

## configure-module input Examples

```json
{
  "mail_server": "f38f9911-8341-452e-8941-d889385a59a8",
  "ldap_domain": "ad.domain.org",
  "admin_users": "Administrator,user1",
  "mail_domain": "domain.org",
  "lets_encrypt": false,
  "host": "sogo.domain.org",
  "workers_count": "3",
  "auxiliary_account": true,
  "activesync": true,
  "dav": true
}
```

# configure-module input Properties

| Property                                 | Type      | Required | Nullable       | Defined by                                                                                                                                                                     |
| :--------------------------------------- | :-------- | :------- | :------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [mail\_server](#mail_server)             | `string`  | Required | cannot be null | [configure-module input](configure-module-input-properties-mail_server.md "http://schema.nethserver.org/sogo/configure-module-input.json#/properties/mail_server")             |
| [ldap\_domain](#ldap_domain)             | `string`  | Required | cannot be null | [configure-module input](configure-module-input-properties-ldap_domain.md "http://schema.nethserver.org/sogo/configure-module-input.json#/properties/ldap_domain")             |
| [admin\_users](#admin_users)             | `string`  | Required | cannot be null | [configure-module input](configure-module-input-properties-admin_users.md "http://schema.nethserver.org/sogo/configure-module-input.json#/properties/admin_users")             |
| [mail\_domain](#mail_domain)             | `string`  | Required | cannot be null | [configure-module input](configure-module-input-properties-mail_domain.md "http://schema.nethserver.org/sogo/configure-module-input.json#/properties/mail_domain")             |
| [lets\_encrypt](#lets_encrypt)           | `boolean` | Required | cannot be null | [configure-module input](configure-module-input-properties-lets_encrypt.md "http://schema.nethserver.org/sogo/configure-module-input.json#/properties/lets_encrypt")           |
| [host](#host)                            | `string`  | Required | cannot be null | [configure-module input](configure-module-input-properties-host.md "http://schema.nethserver.org/sogo/configure-module-input.json#/properties/host")                           |
| [workers\_count](#workers_count)         | `string`  | Required | cannot be null | [configure-module input](configure-module-input-properties-workers_count.md "http://schema.nethserver.org/sogo/configure-module-input.json#/properties/workers_count")         |
| [auxiliary\_account](#auxiliary_account) | `boolean` | Required | cannot be null | [configure-module input](configure-module-input-properties-auxiliary_account.md "http://schema.nethserver.org/sogo/configure-module-input.json#/properties/auxiliary_account") |
| [activesync](#activesync)                | `boolean` | Required | cannot be null | [configure-module input](configure-module-input-properties-activesync.md "http://schema.nethserver.org/sogo/configure-module-input.json#/properties/activesync")               |
| [dav](#dav)                              | `boolean` | Required | cannot be null | [configure-module input](configure-module-input-properties-dav.md "http://schema.nethserver.org/sogo/configure-module-input.json#/properties/dav")                             |

## mail\_server



`mail_server`

*   is required

*   Type: `string`

*   cannot be null

*   defined in: [configure-module input](configure-module-input-properties-mail_server.md "http://schema.nethserver.org/sogo/configure-module-input.json#/properties/mail_server")

### mail\_server Type

`string`

## ldap\_domain



`ldap_domain`

*   is required

*   Type: `string`

*   cannot be null

*   defined in: [configure-module input](configure-module-input-properties-ldap_domain.md "http://schema.nethserver.org/sogo/configure-module-input.json#/properties/ldap_domain")

### ldap\_domain Type

`string`

## admin\_users



`admin_users`

*   is required

*   Type: `string`

*   cannot be null

*   defined in: [configure-module input](configure-module-input-properties-admin_users.md "http://schema.nethserver.org/sogo/configure-module-input.json#/properties/admin_users")

### admin\_users Type

`string`

## mail\_domain



`mail_domain`

*   is required

*   Type: `string`

*   cannot be null

*   defined in: [configure-module input](configure-module-input-properties-mail_domain.md "http://schema.nethserver.org/sogo/configure-module-input.json#/properties/mail_domain")

### mail\_domain Type

`string`

## lets\_encrypt



`lets_encrypt`

*   is required

*   Type: `boolean`

*   cannot be null

*   defined in: [configure-module input](configure-module-input-properties-lets_encrypt.md "http://schema.nethserver.org/sogo/configure-module-input.json#/properties/lets_encrypt")

### lets\_encrypt Type

`boolean`

## host



`host`

*   is required

*   Type: `string`

*   cannot be null

*   defined in: [configure-module input](configure-module-input-properties-host.md "http://schema.nethserver.org/sogo/configure-module-input.json#/properties/host")

### host Type

`string`

### host Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
\.
```

[try pattern](https://regexr.com/?expression=%5C. "try regular expression with regexr.com")

**hostname**: the string must be a hostname, according to [RFC 1123, section 2.1](https://tools.ietf.org/html/rfc1123 "check the specification")

## workers\_count



`workers_count`

*   is required

*   Type: `string`

*   cannot be null

*   defined in: [configure-module input](configure-module-input-properties-workers_count.md "http://schema.nethserver.org/sogo/configure-module-input.json#/properties/workers_count")

### workers\_count Type

`string`

## auxiliary\_account



`auxiliary_account`

*   is required

*   Type: `boolean`

*   cannot be null

*   defined in: [configure-module input](configure-module-input-properties-auxiliary_account.md "http://schema.nethserver.org/sogo/configure-module-input.json#/properties/auxiliary_account")

### auxiliary\_account Type

`boolean`

## activesync



`activesync`

*   is required

*   Type: `boolean`

*   cannot be null

*   defined in: [configure-module input](configure-module-input-properties-activesync.md "http://schema.nethserver.org/sogo/configure-module-input.json#/properties/activesync")

### activesync Type

`boolean`

## dav



`dav`

*   is required

*   Type: `boolean`

*   cannot be null

*   defined in: [configure-module input](configure-module-input-properties-dav.md "http://schema.nethserver.org/sogo/configure-module-input.json#/properties/dav")

### dav Type

`boolean`
