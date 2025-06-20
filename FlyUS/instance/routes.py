from flask import Blueprint, request, jsonify, render_template
from flask_login import login_user, logout_user, login_required, current_user
from config_files.models import db, Korisnik, Role, Let, Rezervacija, Placanje

routes = Blueprint("routes", __name__)


@routes.route('/')
def index():
    return render_template('index.html')


@routes.route('/login', methods=['GET'])
def login_page():
    return render_template('login.html')


@routes.route('/register', methods=['GET'])
def register_page():
    return render_template('register.html')


@routes.route('/api/login', methods=['POST'])
def api_login():
    data = request.json or {}
    korisnik = Korisnik.query.filter_by(email=data.get("email")).first()

    if not korisnik or not korisnik.provjeri_lozinku(data.get("lozinka")):
        return jsonify({"error": "Pogrešan email ili lozinka."}), 401

    login_user(korisnik)
    return jsonify({"msg": "Uspješno ste se prijavili."}), 200


@routes.route('/api/register', methods=['POST'])
def api_register():
    data = request.json or {}
    required_fields = ["ime", "prezime", "email", "lozinka"]

    if not all(field in data for field in required_fields):
        return jsonify({"error": "Nedostaju podaci za registraciju."}), 400

    if Korisnik.query.filter_by(email=data["email"]).first():
        return jsonify({"error": "Email je već u upotrebi."}), 400

    korisnik = Korisnik(
        ime=data["ime"],
        prezime=data["prezime"],
        email=data["email"],
        is_admin=data.get("is_admin", False)
    )
    korisnik.set_lozinku(data["lozinka"])

    korisnik.broj_telefona = data.get("broj_telefona")
    korisnik.profile_slika = data.get("profile_slika")

    db.session.add(korisnik)
    db.session.commit()

    return jsonify({"msg": "Registracija uspješna."}), 201


@routes.route("/logout", methods=["POST"])
@login_required
def logout():
    logout_user()
    return jsonify({"msg": "Uspješno ste se odjavili."}), 200

@routes.route('/logout', methods=['GET'])
@login_required
def logout_page():
    return render_template('logout.html')


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


@routes.route("/api/change-password", methods=["POST"])
def change_password():
    data = request.json or {}

    email = data.get("email")
    ime = data.get("ime")
    nova_lozinka = data.get("nova_lozinka")

    korisnik = Korisnik.query.filter_by(email=email).first()
    if not korisnik or korisnik.ime != ime:
        return jsonify({"error": "Email i ime ne odgovaraju nijednom korisniku."}), 403

    
    if not nova_lozinka:
        return jsonify({"msg": "Korisnik potvrđen. Molimo unesite novu lozinku."}), 200

    
    if len(nova_lozinka) < 6:  
        return jsonify({"error": "Nova lozinka nije validna (mora imati bar 6 znakova)."}), 400

    
    korisnik.set_lozinku(nova_lozinka)
    db.session.commit()

    return jsonify({"msg": "Lozinka promijenjena."}), 200

@routes.route("/change-password", methods=['GET'])
def change_password_page():
    return render_template('change_password.html')



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

    
    print(f"[ADMIN PORUKA] Za korisnika {korisnik.email}: {poruka}")

    return jsonify({"msg": "Poruka poslana korisniku."}), 200


@routes.route("/letovi", methods=["GET"])
def prikaz_letova():
    return render_template("letovi.html")


@routes.route("/api/letovi", methods=["GET"])
def svi_letovi_api():
    letovi = Let.query.all()
    return jsonify([let.serialize() for let in letovi]), 200


@routes.route('/bookings', methods=['GET'])
@login_required
def bookings_page():
    return render_template('bookings.html')


@routes.route('/api/bookings', methods=['GET'])
@login_required
def get_my_bookings():
    rezervacije = Rezervacija.query.filter_by(korisnik_id=current_user.korisnik_id).all()

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

@routes.route("/api/placanja", methods=["GET"])
@login_required
def api_placanja():
    if not current_user.has_role("admin"):
        return jsonify({"error": "Pristup zabranjen."}), 403

    placanja = Placanje.query.all()

    def serialize(p):
        return {
            "payment_id": p.payment_id,
            "korisnik_id": p.korisnik_id,
            "first_name": p.first_name,
            "last_name": p.last_name,
            "billing_address": p.billing_address,
            "country": p.country
        }

    return jsonify([serialize(p) for p in placanja]), 200

@routes.route('/admin_letovi')
@login_required
def admin_letovi():
    if not current_user.has_role('admin'):
        return redirect(url_for('routes.index'))  
    return render_template('admin_letovi.html')


@routes.route('/placanja')
@login_required
def placanja():
    if not current_user.has_role('admin'):
        return redirect(url_for('routes.index'))
    return render_template('placanja.html')

@routes.route("/info")
def info():
    return render_template("info.html")

@routes.route("/privacy_policy")
def privacy_policy():
    return render_template("privacy.html")

@routes.route("/contact")
def contact():
    return render_template("contact.html")

@routes.route("/admin/users", methods=["GET"])
@login_required
def admin_get_users():
    if not current_user.has_role("admin"):
        return jsonify({"error": "Pristup zabranjen."}), 403

    korisnici = Korisnik.query.all()
    users_list = [{
        "korisnik_id": k.korisnik_id,
        "ime": k.ime,
        "broj_telefona": k.broj_telefona,
        "email": k.email
    } for k in korisnici]

    return jsonify(users_list), 200

@routes.route("/admin/users/<int:korisnik_id>", methods=["DELETE"])
@login_required
def admin_delete_user(korisnik_id):
    if not current_user.has_role("admin"):
        return jsonify({"error": "Pristup zabranjen."}), 403

    korisnik = Korisnik.query.get(korisnik_id)
    if not korisnik:
        return jsonify({"error": "Korisnik ne postoji."}), 404

    
    if korisnik.korisnik_id == current_user.korisnik_id:
        return jsonify({"error": "Ne možete obrisati svoj nalog."}), 400

    db.session.delete(korisnik)
    db.session.commit()

    return jsonify({"msg": f"Korisnik {korisnik.ime} obrisan."}), 200

    from flask import render_template
from flask_login import login_required, current_user

@routes.route("/admin/users/view")
@login_required
def admin_users_view():
    if not current_user.has_role("admin"):
        return "Pristup zabranjen", 403
    return render_template("admin_users.html")

