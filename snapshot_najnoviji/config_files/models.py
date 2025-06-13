from flask_sqlalchemy import SQLAlchemy
from flask_login import UserMixin
from werkzeug.security import generate_password_hash, check_password_hash
from sqlalchemy import event

db = SQLAlchemy()

class Let(db.Model):
    __tablename__ = 'letovi'
    let_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    polazni_aerodrom = db.Column(db.String(100))
    odredisni_aerodrom = db.Column(db.String(100))
    drzava_input = db.Column(db.String(100))
    drzava_output = db.Column(db.String(100))
    vrijeme_i_datum_polaska = db.Column(db.String(100))
    vrijeme_i_datum_dolaska = db.Column(db.String(100))
    cijena = db.Column(db.Float)
    klasa = db.Column(db.String(30))
    avio_kompanija = db.Column(db.String(100))
    dostupna_sjedista = db.Column(db.Integer)
    broj_terminala = db.Column(db.String(10))
    broj_izlaza = db.Column(db.String(10))
    trajanje_leta = db.Column(db.String(50))
    dodatne_informacije = db.Column(db.String(200))

    rezervacije = db.relationship('Rezervacija', back_populates='let')

    def serialize(self):
        return {
            'let_id': self.let_id,
            'polazni_aerodrom': self.polazni_aerodrom,
            'odredisni_aerodrom': self.odredisni_aerodrom,
            'drzava_input': self.drzava_input,
            'drzava_output': self.drzava_output,
            'vrijeme_i_datum_polaska': self.vrijeme_i_datum_polaska,
            'vrijeme_i_datum_dolaska': self.vrijeme_i_datum_dolaska,
            'cijena': self.cijena,
            'klasa': self.klasa,
            'avio_kompanija': self.avio_kompanija,
            'dostupna_sjedista': self.dostupna_sjedista,
            'broj_terminala': self.broj_terminala,
            'broj_izlaza': self.broj_izlaza,
            'trajanje_leta': self.trajanje_leta,
            'dodatne_informacije': self.dodatne_informacije
            # po potrebi možeš dodati i rezervacije ako želiš
        }


class Korisnik(UserMixin, db.Model):
    __tablename__ = 'korisnici'
    korisnik_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    ime = db.Column(db.String(50))
    prezime = db.Column(db.String(50))
    email = db.Column(db.String(100), unique=True)
    lozinka_hash = db.Column(db.String(500))
    broj_telefona = db.Column(db.String(15), nullable=True)
    profile_slika = db.Column(db.String(200), nullable=True)
    is_admin = db.Column(db.Boolean, default=False)

    rezervacije = db.relationship('Rezervacija', back_populates='korisnik')
    placanja = db.relationship('Placanje', backref='korisnik', lazy=True)
    rola = db.relationship('Role', back_populates='korisnik', uselist=False)

    def has_role(self, role_name):
        if not self.rola:
            return False
        if role_name == "admin":
            return self.rola.is_admin
        elif role_name == "user":
            return not self.rola.is_admin
        return False

    def get_id(self):
        return str(self.korisnik_id)

    def set_lozinku(self, lozinka):
        self.lozinka_hash = generate_password_hash(lozinka)

    def provjeri_lozinku(self, lozinka):
        return check_password_hash(self.lozinka_hash, lozinka)


class Rezervacija(db.Model):
    __tablename__ = 'rezervacije'
    rezervacija_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    korisnik_id = db.Column(db.Integer, db.ForeignKey('korisnici.korisnik_id'))
    let_id = db.Column(db.Integer, db.ForeignKey('letovi.let_id'))
    datum_rezervacije = db.Column(db.String(50))
    status = db.Column(db.String(50), default="potvrdjeno")
    rezervisana_sjedista = db.Column(db.Integer)
    ukupna_cijena = db.Column(db.Float)

    korisnik = db.relationship('Korisnik', back_populates='rezervacije')
    let = db.relationship('Let', back_populates='rezervacije')


class Role(db.Model):
    __tablename__ = 'roles'
    role_user_id = db.Column(db.Integer, primary_key=True)
    korisnik_id = db.Column(db.Integer, db.ForeignKey('korisnici.korisnik_id'), unique=True)
    is_admin = db.Column(db.Boolean, default=False)

    korisnik = db.relationship('Korisnik', back_populates='rola')


class Placanje(db.Model):
    __tablename__ = 'payment'
    payment_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    korisnik_id = db.Column(db.Integer, db.ForeignKey('korisnici.korisnik_id'))
    first_name = db.Column(db.String(50))
    last_name = db.Column(db.String(50))
    card_number_hash = db.Column(db.String(200))
    date_of_expiration = db.Column(db.String(20))  # format MM/YY
    security_number_hash = db.Column(db.String(200))
    billing_address = db.Column(db.String(200))
    country = db.Column(db.String(50))

    def set_card_data(self, card_number, security_number):
        self.card_number_hash = generate_password_hash(card_number)
        self.security_number_hash = generate_password_hash(security_number)

    def verify_card_number(self, card_number):
        return check_password_hash(self.card_number_hash, card_number)

    def verify_security_number(self, security_number):
        return check_password_hash(self.security_number_hash, security_number)


@event.listens_for(Korisnik, 'after_insert')
def after_insert_korisnik(mapper, connection, target):
    role_table = Role.__table__
    connection.execute(
        role_table.insert().values(
            korisnik_id=target.korisnik_id,
            is_admin=target.is_admin if target.is_admin is not None else False
        )
    )


@event.listens_for(Korisnik, 'after_update')
def after_update_korisnik(mapper, connection, target):
    role_table = Role.__table__
    # Pokušaj update, ako nema reda, insert
    update_result = connection.execute(
        role_table.update()
        .where(role_table.c.korisnik_id == target.korisnik_id)
        .values(is_admin=target.is_admin if target.is_admin is not None else False)
    )
    if update_result.rowcount == 0:
        connection.execute(
            role_table.insert().values(
                korisnik_id=target.korisnik_id,
                is_admin=target.is_admin if target.is_admin is not None else False
            )
        )
