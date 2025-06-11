from flask import Blueprint, request, jsonify
from flask_login import login_user, logout_user, login_required, current_user
from config_files.models import db, Korisnik, Role, Let, Rezervacija, Placanje
from werkzeug.security import generate_password_hash, check_password_hash
from config_files.models import Rezervacija


routes = Blueprint("routes", __name__)

# ------------------ HOME ------------------
@routes.route("/", methods=["GET"])
def home():
    return jsonify({"msg": "API IS WORKING CORRECTLY!"}), 200

# ------------------ REGISTER ------------------

@routes.route("/register", methods=["POST"])
def register():
    data = request.json or {}
    required_fields = ["ime", "prezime", "email", "lozinka"]

    if not all(field in data for field in required_fields):
        return jsonify({"error": "Nedostaju podaci za registraciju."}), 400

    # Postavi na False ako nije poslato
    is_admin = data.get("is_admin", False)
    if not isinstance(is_admin, bool):
        return jsonify({"error": "Polje is_admin mora biti boolean."}), 400

    if Korisnik.query.filter_by(email=data["email"]).first():
        return jsonify({"error": "Email je već u upotrebi."}), 400

    korisnik = Korisnik(
        ime=data["ime"],
        prezime=data["prezime"],
        email=data["email"],
        is_admin=is_admin
    )
    korisnik.set_lozinku(data["lozinka"])

    korisnik.broj_telefona = data.get("broj_telefona")
    korisnik.profile_slika = data.get("profile_slika")

    db.session.add(korisnik)
    db.session.commit()

    return jsonify({"msg": "Registracija uspješna."}), 201

# ------------------ LOGIN ------------------
@routes.route("/login", methods=["POST"])
def login():
    data = request.json or {}

    korisnik = Korisnik.query.filter_by(email=data.get("email")).first()

    if not korisnik or not korisnik.provjeri_lozinku(data.get("lozinka")):
        return jsonify({"error": "Pogrešan email ili lozinka."}), 401

    login_user(korisnik)

    return jsonify({"msg": "Uspješno ste se prijavili."}), 200

# ------------------ LOGOUT ------------------
@routes.route("/logout", methods=["POST"])
@login_required
def logout():
    logout_user()
    return jsonify({"msg": "Uspješno ste se odjavili."}), 200

# ------------------ ADD FLIGHT (ADMIN) ------------------
@routes.route("/admin/let", methods=["POST"])
@login_required
def add_let():
    if not current_user.rola or not current_user.rola.is_admin:
        return jsonify({"error": "Pristup zabranjen."}), 403

    data = request.json or {}
    let = Let(**data)
    db.session.add(let)
    db.session.commit()
    return jsonify({"msg": "Let dodat."}), 201

# ------------------ DELETE FLIGHT (ADMIN) ------------------
@routes.route("/admin/let/<int:let_id>", methods=["DELETE"])
@login_required
def delete_let(let_id):
    if not current_user.rola or not current_user.rola.is_admin:
        return jsonify({"error": "Pristup zabranjen."}), 403

    let = Let.query.get(let_id)
    if not let:
        return jsonify({"error": "Let ne postoji."}), 404

    db.session.delete(let)
    db.session.commit()
    return jsonify({"msg": "Let obrisan."}), 200

# ------------------ BOOK FLIGHT (USER) ------------------
@routes.route("/book", methods=["POST"])
@login_required
def book_flight():
    data = request.json or {}
    let = Let.query.get(data.get("let_id"))
    if not let:
        return jsonify({"error": "Let ne postoji."}), 404

    broj_sjedista = data.get("rezervisana_sjedista", 1)
    if let.dostupna_sjedista < broj_sjedista:
        return jsonify({"error": "Nema dovoljno slobodnih mjesta."}), 400

    rezervacija = Rezervacija(
        korisnik_id=current_user.korisnik_id,
        let_id=let.let_id,
        datum_rezervacije=data.get("datum_rezervacije"),
        rezervisana_sjedista=broj_sjedista,
        ukupna_cijena=let.cijena * broj_sjedista
    )
    let.dostupna_sjedista -= broj_sjedista
    db.session.add(rezervacija)
    db.session.commit()

    return jsonify({"msg": "Rezervacija uspješna."}), 201

# ------------------ CANCEL BOOKING (USER) ------------------
@routes.route("/cancel/<int:rezervacija_id>", methods=["DELETE"])
@login_required
def cancel_booking(rezervacija_id):
    rezervacija = Rezervacija.query.get(rezervacija_id)
    if not rezervacija or rezervacija.korisnik_id != current_user.korisnik_id:
        return jsonify({"error": "Rezervacija ne postoji ili nije vaša."}), 403

    let = rezervacija.let
    let.dostupna_sjedista += rezervacija.rezervisana_sjedista
    db.session.delete(rezervacija)
    db.session.commit()
    return jsonify({"msg": "Rezervacija otkazana."}), 200

# ------------------ SAVE PAYMENT ------------------
@routes.route("/payment", methods=["POST"])
@login_required
def save_payment():
    data = request.json or {}
    placanje = Placanje(
        korisnik_id=current_user.korisnik_id,
        first_name=data.get("first_name"),
        last_name=data.get("last_name"),
        date_of_expiration=data.get("date_of_expiration"),
        billing_address=data.get("billing_address"),
        country=data.get("country")
    )
    placanje.set_card_data(data.get("card_number"), data.get("security_number"))
    db.session.add(placanje)
    db.session.commit()
    return jsonify({"msg": "Podaci o plaćanju sačuvani."}), 201

# ------------------ DELETE PAYMENT ------------------
"""
@routes.route("/payment/<int:payment_id>", methods=["DELETE"])
@login_required
def delete_payment(payment_id):
    placanje = Placanje.query.get(payment_id)
    if not placanje:
        return jsonify({"error": "Plaćanje nije pronađeno."}), 404

    # Provera da li je korisnik vlasnik placanja ili admin
    if placanje.korisnik_id != current_user.korisnik_id and not current_user.has_role("admin"):
        return jsonify({"error": "Nema pristupa ovom plaćanju."}), 403

    db.session.delete(placanje)
    db.session.commit()
    return jsonify({"msg": "Plaćanje obrisano."}), 200
"""

# ------------------ CHANGE PASSWORD ------------------
@routes.route("/change-password", methods=["POST"])
@login_required
def change_password():
    data = request.json or {}
    if current_user.email != data.get("email") or current_user.ime != data.get("ime"):
        return jsonify({"error": "Podaci ne odgovaraju trenutnom korisniku."}), 403

    if not data.get("nova_lozinka"):
        return jsonify({"error": "Nova lozinka nije validna."}), 400

    current_user.set_lozinku(data.get("nova_lozinka"))
    db.session.commit()
    return jsonify({"msg": "Lozinka promijenjena."}), 200

# ------------------ SEND MESSAGE TO USER (ADMIN) ------------------
@routes.route("/admin/send-message", methods=["POST"])
@login_required
def send_message():
    if not current_user.rola or not current_user.rola.is_admin:
        return jsonify({"error": "Pristup zabranjen."}), 403

    data = request.json or {}
    korisnik_id = data.get("korisnik_id")
    poruka = data.get("poruka")

    korisnik = Korisnik.query.get(korisnik_id)
    if not korisnik:
        return jsonify({"error": "Korisnik ne postoji."}), 404

    # Ovde ide slanje poruke – za sada logujemo
    print(f"[ADMIN PORUKA] Za korisnika {korisnik.email}: {poruka}")

    return jsonify({"msg": "Poruka poslana korisniku."}), 200

# ------------------ GET ALL FLIGHTS ------------------
@routes.route("/letovi", methods=["GET"])
def svi_letovi():
    letovi = Let.query.all()
    return jsonify([let.serialize() for let in letovi]), 200


@routes.route('/bookings', methods=['GET'])
@login_required
def get_my_bookings():
    korisnik_id = current_user.korisnik_id  # <-- OVO JE PRAVO

    rezervacije = Rezervacija.query.filter_by(korisnik_id=korisnik_id).all()
    if not rezervacije:
        return jsonify({"message": "Nemate rezervacija"}), 200

    def serialize_rez(r):
        return {
            "rezervacija_id": r.rezervacija_id,
            "let_id": r.let_id,
            "datum_rezervacije": r.datum_rezervacije,
            "status": r.status,
            "rezervisana_sjedista": r.rezervisana_sjedista,
            "ukupna_cijena": r.ukupna_cijena
        }

    return jsonify([serialize_rez(r) for r in rezervacije]), 200


@routes.route("/fetch-payment", methods=["GET"])
@login_required
def get_payment():
    placanje = Placanje.query.filter_by(korisnik_id=current_user.korisnik_id).first()
    if not placanje:
        return jsonify({"msg": "Nema sačuvanih podataka o plaćanju."}), 404

    if current_user.has_role("user"):
        return jsonify({
            "first_name": placanje.first_name,
            "last_name": placanje.last_name,
            "date_of_expiration": placanje.date_of_expiration,
            "billing_address": placanje.billing_address,
            "country": placanje.country
        }), 200

    elif current_user.has_role("admin"):
        return jsonify({
            "first_name": placanje.first_name,
            "last_name": placanje.last_name,
            "country": placanje.country
        }), 200

    return jsonify({"error": "Nepoznata rola korisnika."}), 403


@routes.route("/delete-payment", methods=["DELETE"])
@login_required
def delete_payment():
    if current_user.has_role("admin"):
        data = request.get_json(silent=True) or {}
        if "payment_id" not in data:
            return jsonify({"error": "Nedostaje payment_id za admin brisanje."}), 400

        placanje = Placanje.query.get(data["payment_id"])
        if not placanje:
            return jsonify({"msg": "Nema plaćanja sa tim ID-jem."}), 200
    else:
        placanje = Placanje.query.filter_by(korisnik_id=current_user.korisnik_id).first()
        if not placanje:
            return jsonify({"msg": "Nema registrovanog plaćanja."}), 200

    db.session.delete(placanje)
    db.session.commit()
    return jsonify({"msg": "Plaćanje obrisano."}), 200




