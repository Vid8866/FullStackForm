# Full Stack Form – Dockerizirana Aplikacija

Ta repozitorij vsebuje **full-stack spletno aplikacijo**, ki je v celoti **dockerizirana** in zagnana z **Docker Compose**.

---

## Arhitektura aplikacije

Aplikacijski stack je sestavljen iz **štirih ločenih storitev**, vsaka v svojem Docker kontejnerju:

- **Flask (Python)** – backend spletna aplikacija
- **PostgreSQL** – relacijska baza podatkov
- **Redis** – cache in števec vnosov
- **Nginx** – reverse proxy + TLS terminacija (HTTPS)

Vse storitve tečejo v **Docker Compose okolju** in komunicirajo preko Docker omrežja.

---

## Tehnologije

- Python (Flask)
- PostgreSQL 16
- Redis 7
- Nginx (Alpine)
- Docker & Docker Compose
- Docker BuildX
- GitHub Actions (CI)
- Docker Hub (registry)
- OpenSSL (self-signed TLS certifikat)

---

## Docker image

Flask aplikacija je zgrajena kot **custom Docker image**:

- uporabljen je **multi-stage Dockerfile**
- build stage vsebuje build odvisnosti (compilerji, headers)
- runtime stage uporablja **minimalni `python:3.12-slim`**
- rezultat je manjši in varnejši image
- image se avtomatsko gradi in objavlja s CI/CD

Docker Hub image: vid8866/fullstackform-app:latest

---

## CI/CD – GitHub Actions

Projekt uporablja **GitHub Actions** za avtomatsko gradnjo in objavo Docker image-a.

Ob vsakem `push` na branch **docker** se sproži workflow, ki:

1. zgradi Docker image (multi-stage build)
2. uporabi Docker BuildX
3. image označi z `latest`
4. image objavi na Docker Hub

Workflow se nahaja v: .github/workflows/docker.yml

---

## HTTPS / TLS

- HTTPS je omogočen z **Nginx reverse proxy-jem**
- uporabljeni so **self-signed TLS certifikati**
- TLS terminacija poteka v Nginx kontejnerju
- Flask aplikacija teče interno prek HTTP (port 5001)

Ker gre za self-signed certifikat, bo brskalnik prikazal varnostno opozorilo.

---

## Zagon aplikacije (Docker Compose)

### Zahteve

- Docker
- Docker Compose (v2)

---

### 1. Kloniranje repozitorija

```bash
git clone https://github.com/Vid8866/FullStackForm.git
cd FullStackForm
git checkout docker
```

### 2. Zagon celotnega stacka

```bash
docker compose up -d
```

### 3. Preverjanje stanja

```bash
docker ps
```

### 4. Dostop do aplikacije

```bash
https://<PUBLIC_IP_VM> (HTTPS, port 443)
```
