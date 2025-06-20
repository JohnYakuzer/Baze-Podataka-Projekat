# Baze podataka - Web aplikacija avio-agencije

Ova aplikacija predstavlja simulaciju funkcionalnog sistema za upravljanje rezervacijama, korisnicima i letovima u sklopu avio-agencije. Projekat je realizovan kao zadatak sa ciljem izrade aplikacije koja omogućava efikasnu komunikaciju između korisnika i backend API-ja, uz pregledan i intuitivan korisnički interfejs.

## Ključne funkcionalnosti

- Registracija i prijava korisnika
- Promjena lozinke i reset zaboravljene lozinke
- Pretraga letova po destinaciji, cijeni i klasi
- Rezervacije i otkazivanje rezervacija
- Pregled postojećih rezervacija
- Sigurno čuvanje korisničkih podataka (hash lozinki, enkripcija)
- Administrator panel:
  - Dodavanje i brisanje letova
  - Pregled svih korisnika
  - Pregled transakcija i uplata

## Tehnologije i alati

- Frontend: HTML, CSS, JavaScript
- Backend: Python (Flask)
- Baza podataka: MySQL
- Šablon sistem: Jinja2
- Testiranje API poziva: HTTPie
- Sigurnost: Enkripcija osjetljivih podataka i hashovanje lozinki

## Pokretanje projekta lokalno

1. Klonirajte repozitorijum:
   ```bash
   git clone https://github.com/ime-korisnika/naziv-repozitorijuma.git
   cd naziv-repozitorijuma
   ```

2. Kreirajte i aktivirajte virtuelno okruženje (preporučeno):
   - **Na Linux/macOS:**
     ```bash
     python3 -m venv venv
     source venv/bin/activate
     ```
   - **Na Windows:**
     ```bash
     python -m venv venv
     venv\Scripts\activate
     ```

3. Instalirajte zavisnosti:
   ```bash
   pip install -r requirements.txt
   ```

4. Pokrenite Flask aplikaciju:
   ```bash
   python app.py
   ```

5. Otvorite aplikaciju u pretraživaču:
   ```
   http://localhost:5000
   ```
