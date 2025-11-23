
# Aplikacija Full Stack Form (Flask + PostgreSQL + Redis)

Ta repozitorij vsebuje preprosto full-stack spletno aplikacijo, zgrajeno z naslednjimi tehnologijami:

- Flask (Python spletni okvir)
- PostgreSQL (SQL baza podatkov)
- Redis (hitra podatkovna baza v RAM-u = cache)
- Bootstrap (stiliranje uporabniškega vmesnika)
- Nginx (ni namenjen za lokalni razvoj — uporablja se v Vagrant ali cloud-init VM-ju kot HTTP strežnik.)

---


# Kako zagnati projekt lokalno

Sledite tem korakom **v navedenem vrstnem redu**.

---

## 1. Kloniraj repozitorij

```bash
git clone https://github.com/Vid8866/FullStackForm.git
```

## 2. Namestite Python odvisnosti

```
pip install -r requirements.txt
```

## 3. Namestite in zaženite PostgreSQL

macOS (Homebrew):

```
brew install postgresql
brew services start postgresql
```

Ustvarite zahtevano bazo podatkov:

```
createdb demo
psql -d demo -c "CREATE USER \"user\" WITH PASSWORD 'pass';"
psql -d demo -c "GRANT ALL PRIVILEGES ON DATABASE demo TO \"user\";"
```

## 4. Zaženite Redis

```
brew services start redis
```

## 5. Zaženite aplikacijo

```
python main.py
```


# Lokalna uporaba aplikacije z cloud-init preko multipass
## 1. Naložite [multipass](https://documentation.ubuntu.com/multipass/latest/how-to-guides/install-multipass/)
## 2. Zaženite vm z cloud-init
Uporabite multipass, da naredite nov vm.
```
multipass launch --memory=2G --disk=5G --cpus=1 --name testvm --bridged --cloud-init cloud-config.yaml
```
To lahko traja nekaj minut. Možen je tudi "Timeout waiting for instance launch" ampak bi aplikacija vseeno morala delovati.
Kasneje boste potrebovali IPv4 naslov od testvm, pokažete ga lahko s tem ukazom:
```
multipass list
```
## 3. Odprite lupino in zaženite aplikacijo
Odprite lupino od testvm
```
multipass shell testvm
```
Ko ste v lupini, lahko aplikacijo Full Stack Form odprete z ukazom:
```
python3 /home/ubuntu/FullStackForm/application/app/main.py
```
## 4. Uporaba aplikacije
V brskalniku se povežite na IP, ki ste si ga prej zapomnili, na port 5001 (na primer 10.209.93.241:5001)
