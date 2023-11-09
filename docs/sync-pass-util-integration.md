# Sync Pass util intergration
 * requirements:
    * [gpg util](https://gnupg.org)
    * [pass util](https://www.passwordstore.org)
    * [ripgrep](#recomended-requirements)

---

## initialize
```bash
# create new gpg pairs kit
gpg --full-generate-key

# for checking sum
gpg --list-secret-keys --keyid-format=long
gpg --fingerprint

# create new password sync storage
pass init $(gpg --list-secret-keys --keyid-format=long | rg -o -e 'uid\s+[^\n]+' | rg -o -e '<([^>]+)>' --replace '$1')

# save generated GPT token in storage
echo <openai-api-key> | pass insert --echo --force api/tokens/openai
```

---

## Relation links

* [Homepage](../README.md)

* [Sync pass util integration](sync-pass-util-integration.md)

* [Sell-infrastructure](shell-infrastructure-manual.md)

* [Shell configuration](shell-configuration-manual.md)