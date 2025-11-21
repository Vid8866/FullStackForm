
# Aplikacija Full Stack Form (Flask + PostgreSQL + Redis)

Ta repozitorij vsebuje preprosto full-stack spletno aplikacijo, zgrajeno z naslednjimi tehnologijami:

- Flask (Python spletni okvir)
- PostgreSQL (SQL baza podatkov)
- Redis (predpomnilnik v pomnilniku)
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

