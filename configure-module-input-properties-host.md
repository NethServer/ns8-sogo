# Untitled string in configure-module input Schema

```txt
http://schema.nethserver.org/sogo/configure-module-input.json#/properties/host
```



| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                               |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [configure-module-input.json\*](sogo/configure-module-input.json "open original schema") |

## host Type

`string`

## host Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
\.
```

[try pattern](https://regexr.com/?expression=%5C. "try regular expression with regexr.com")

**hostname**: the string must be a hostname, according to [RFC 1123, section 2.1](https://tools.ietf.org/html/rfc1123 "check the specification")
